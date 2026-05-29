import { NavLink } from 'react-router-dom';
import { 
  SquaresFour, 
  Users, 
  Buildings, 
  EnvelopeSimple, 
  Megaphone, 
  ShieldWarning, 
  ChartLineUp, 
  Gear,
  SignOut,
  ShieldCheck
} from '@phosphor-icons/react';
import { signOut } from 'firebase/auth';
import { auth } from '../firebase';

const Sidebar = () => {
  const handleLogout = () => {
    signOut(auth);
  };

  return (
    <nav className="sidebar">
      <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '40px' }}>
        <ShieldCheck size={32} color="var(--primary)" weight="fill" />
        <h2 style={{ fontSize: '20px' }}>Super Admin</h2>
      </div>
      
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: '8px', overflowY: 'auto' }}>
        <div className="nav-section-title" style={{ fontSize: '12px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px', marginTop: '16px', marginBottom: '8px', paddingLeft: '12px' }}>Overview</div>
        <NavLink to="/overview" className={({ isActive }) => `nav-link ${isActive ? 'active' : ''}`}>
          <SquaresFour size={24} /> Dashboard
        </NavLink>
        <NavLink to="/analytics" className={({ isActive }) => `nav-link ${isActive ? 'active' : ''}`}>
          <ChartLineUp size={24} /> Analytics
        </NavLink>

        <div className="nav-section-title" style={{ fontSize: '12px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px', marginTop: '24px', marginBottom: '8px', paddingLeft: '12px' }}>Community</div>
        <NavLink to="/users" className={({ isActive }) => `nav-link ${isActive ? 'active' : ''}`}>
          <Users size={24} /> Users
        </NavLink>
        <NavLink to="/families" className={({ isActive }) => `nav-link ${isActive ? 'active' : ''}`}>
          <Buildings size={24} /> Families
        </NavLink>
        <NavLink to="/invitations" className={({ isActive }) => `nav-link ${isActive ? 'active' : ''}`}>
          <EnvelopeSimple size={24} /> Invitations
        </NavLink>

        <div className="nav-section-title" style={{ fontSize: '12px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px', marginTop: '24px', marginBottom: '8px', paddingLeft: '12px' }}>Content & Moderation</div>
        <NavLink to="/notices" className={({ isActive }) => `nav-link ${isActive ? 'active' : ''}`}>
          <Megaphone size={24} /> Notice Board
        </NavLink>
        <NavLink to="/reports" className={({ isActive }) => `nav-link ${isActive ? 'active' : ''}`}>
          <ShieldWarning size={24} /> Reports
        </NavLink>

        <div className="nav-section-title" style={{ fontSize: '12px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px', marginTop: '24px', marginBottom: '8px', paddingLeft: '12px' }}>System</div>
        <NavLink to="/settings" className={({ isActive }) => `nav-link ${isActive ? 'active' : ''}`}>
          <Gear size={24} /> Settings
        </NavLink>
      </div>

      <button className="btn btn-danger" style={{ justifyContent: 'center', marginTop: '24px' }} onClick={handleLogout}>
        <SignOut size={20} /> Logout
      </button>
    </nav>
  );
};

export default Sidebar;
