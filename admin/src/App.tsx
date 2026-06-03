import React, { useEffect, useState } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { supabase } from './supabase';
import type { User } from '@supabase/supabase-js';

import './index.css';
import Layout from './components/Layout';
import Login from './Login';
import FamiliesDashboard from './FamiliesDashboard';
import NoticesDashboard from './NoticesDashboard';
import OverviewDashboard from './pages/OverviewDashboard';
import AnalyticsDashboard from './pages/AnalyticsDashboard';
import UsersDashboard from './pages/UsersDashboard';
import InvitationsDashboard from './pages/InvitationsDashboard';
import ReportsDashboard from './pages/ReportsDashboard';
import SettingsDashboard from './pages/SettingsDashboard';

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
    </BrowserRouter>
  );
}

export default App;


