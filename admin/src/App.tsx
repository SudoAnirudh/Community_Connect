import React, { useEffect, useState } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { supabase } from './supabase';
import type { User } from '@supabase/supabase-js';

import './index.css';
import Layout from './components/Layout';
const Login = React.lazy(() => import('./Login'));
const FamiliesDashboard = React.lazy(() => import('./FamiliesDashboard'));
const NoticesDashboard = React.lazy(() => import('./NoticesDashboard'));
const OverviewDashboard = React.lazy(() => import('./pages/OverviewDashboard'));
const AnalyticsDashboard = React.lazy(() => import('./pages/AnalyticsDashboard'));
const UsersDashboard = React.lazy(() => import('./pages/UsersDashboard'));
const InvitationsDashboard = React.lazy(() => import('./pages/InvitationsDashboard'));
const ReportsDashboard = React.lazy(() => import('./pages/ReportsDashboard'));
const SettingsDashboard = React.lazy(() => import('./pages/SettingsDashboard'));

const ProtectedRoute = ({ children }: { children: React.ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null);
      setLoading(false);
    });

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
      setLoading(false);
    });

    return () => subscription.unsubscribe();
  }, []);

  if (loading) {
    return <div style={{ display: 'flex', height: '100vh', justifyContent: 'center', alignItems: 'center', color: 'var(--text-primary)' }}>Loading...</div>;
  }

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  return <Layout>{children}</Layout>;
};

function App() {
  return (
    <BrowserRouter>
      <React.Suspense fallback={<div style={{ display: 'flex', height: '100vh', justifyContent: 'center', alignItems: 'center', color: 'var(--text-primary)' }}>Loading...</div>}>
        <Routes>
        <Route path="/login" element={<Login />} />
        
        <Route path="/" element={<Navigate to="/overview" replace />} />
        
        <Route path="/overview" element={<ProtectedRoute><OverviewDashboard /></ProtectedRoute>} />
        <Route path="/analytics" element={<ProtectedRoute><AnalyticsDashboard /></ProtectedRoute>} />
        
        <Route path="/users" element={<ProtectedRoute><UsersDashboard /></ProtectedRoute>} />
        <Route path="/families" element={<ProtectedRoute><FamiliesDashboard /></ProtectedRoute>} />
        <Route path="/invitations" element={<ProtectedRoute><InvitationsDashboard /></ProtectedRoute>} />
        
        <Route path="/notices" element={<ProtectedRoute><NoticesDashboard /></ProtectedRoute>} />
        <Route path="/reports" element={<ProtectedRoute><ReportsDashboard /></ProtectedRoute>} />
        
        <Route path="/settings" element={<ProtectedRoute><SettingsDashboard /></ProtectedRoute>} />
        </Routes>
      </React.Suspense>
    </BrowserRouter>
  );
}

export default App;


