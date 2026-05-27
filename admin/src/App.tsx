import React from 'react';
import { BrowserRouter, Routes, Route, NavLink, Navigate } from 'react-router-dom';
import { Buildings, Megaphone, Users, SignOut, ShieldCheck } from '@phosphor-icons/react';
import FamiliesDashboard from './FamiliesDashboard';
import NoticesDashboard from './NoticesDashboard';
import './index.css';

// Simple mockup of a login state for the Super Admin
const Layout = ({ children }: { children: React.ReactNode }) => {
  return (
    <div className="app-container">
      <nav className="sidebar">
        <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '40px' }}>
          <ShieldCheck size={32} color="var(--primary)" weight="fill" />
          <h2 style={{ fontSize: '20px' }}>Super Admin</h2>
        </div>
        
        <div style={{ flex: 1 }}>
          <NavLink to="/families" className={({ isActive }) => `nav-link ${isActive ? 'active' : ''}`}>
            <Buildings size={24} />
            Family Approvals
          </NavLink>
          <NavLink to="/notices" className={({ isActive }) => `nav-link ${isActive ? 'active' : ''}`}>
            <Megaphone size={24} />
            Notice Board
          </NavLink>
        </div>

        <button className="btn btn-danger" style={{ justifyContent: 'center' }}>
          <SignOut size={20} />
          Logout
        </button>
      </nav>
      
      <main className="main-content">
        {children}
      </main>
    </div>
  );
};

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Navigate to="/families" replace />} />
        <Route path="/families" element={<Layout><FamiliesDashboard /></Layout>} />
        <Route path="/notices" element={<Layout><NoticesDashboard /></Layout>} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
