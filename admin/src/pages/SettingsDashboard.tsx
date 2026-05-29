import { useState } from 'react';
import { Bell, Shield, Database } from '@phosphor-icons/react';

const SettingsDashboard = () => {
  const [loading, setLoading] = useState(false);
  const [settings, setSettings] = useState({
    allowNewRegistrations: true,
    requireAdminVerification: true,
    enablePushNotifications: true,
    maintenanceMode: false,
    dataRetentionDays: 365
  });

  const handleSave = () => {
    setLoading(true);
    // In production, save to a 'settings/global' document in Firestore
    setTimeout(() => {
      setLoading(false);
      alert('Platform settings saved successfully.');
    }, 800);
  };

  return (
    <div style={{ paddingBottom: '60px' }}>
      <div style={{ marginBottom: '32px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div>
          <h1>System Settings</h1>
          <p style={{ color: 'var(--text-muted)' }}>Manage global platform configurations and maintenance.</p>
        </div>
        <button 
          className="btn btn-primary" 
          onClick={handleSave} 
          disabled={loading}
          style={{ width: '120px', justifyContent: 'center' }}
        >
          {loading ? 'Saving...' : 'Save Changes'}
        </button>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr', gap: '24px', maxWidth: '800px' }}>
        
        {/* Security & Access */}
        <div className="glass-card" style={{ padding: '32px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '24px' }}>
            <Shield size={24} color="var(--primary)" />
            <h3 style={{ margin: 0 }}>Security & Access</h3>
          </div>
          
          <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <div>
                <div style={{ fontWeight: '500', marginBottom: '4px' }}>Allow New Registrations</div>
                <div style={{ fontSize: '14px', color: 'var(--text-muted)' }}>Users can create new accounts via the mobile app.</div>
              </div>
              <label className="switch">
                <input 
                  type="checkbox" 
                  checked={settings.allowNewRegistrations}
                  onChange={(e) => setSettings({...settings, allowNewRegistrations: e.target.checked})}
                />
                <span className="slider round"></span>
              </label>
            </div>
            
            <hr style={{ borderTop: '1px solid var(--border)', borderBottom: 'none' }} />

            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <div>
                <div style={{ fontWeight: '500', marginBottom: '4px' }}>Require Admin Verification for Families</div>
                <div style={{ fontSize: '14px', color: 'var(--text-muted)' }}>New families must be verified before appearing in search.</div>
              </div>
              <label className="switch">
                <input 
                  type="checkbox" 
                  checked={settings.requireAdminVerification}
                  onChange={(e) => setSettings({...settings, requireAdminVerification: e.target.checked})}
                />
                <span className="slider round"></span>
              </label>
            </div>
          </div>
        </div>

        {/* Notifications & System */}
        <div className="glass-card" style={{ padding: '32px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '24px' }}>
            <Bell size={24} color="var(--primary)" />
            <h3 style={{ margin: 0 }}>Notifications & Push</h3>
          </div>
          
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <div style={{ fontWeight: '500', marginBottom: '4px' }}>Enable Push Notifications globally</div>
              <div style={{ fontSize: '14px', color: 'var(--text-muted)' }}>Allow the system to trigger Firebase Cloud Messaging.</div>
            </div>
            <label className="switch">
              <input 
                type="checkbox" 
                checked={settings.enablePushNotifications}
                onChange={(e) => setSettings({...settings, enablePushNotifications: e.target.checked})}
              />
              <span className="slider round"></span>
            </label>
          </div>
        </div>

        {/* Danger Zone */}
        <div className="glass-card" style={{ padding: '32px', border: '1px solid rgba(239, 68, 68, 0.3)' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '24px' }}>
            <Database size={24} color="#ef4444" />
            <h3 style={{ margin: 0, color: '#ef4444' }}>Danger Zone</h3>
          </div>
          
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <div style={{ fontWeight: '500', marginBottom: '4px' }}>Maintenance Mode</div>
              <div style={{ fontSize: '14px', color: 'var(--text-muted)' }}>Disable access to all mobile apps and display a maintenance screen.</div>
            </div>
            <label className="switch">
              <input 
                type="checkbox" 
                checked={settings.maintenanceMode}
                onChange={(e) => setSettings({...settings, maintenanceMode: e.target.checked})}
              />
              <span className="slider round"></span>
            </label>
          </div>
        </div>
        
      </div>
    </div>
  );
};

export default SettingsDashboard;
