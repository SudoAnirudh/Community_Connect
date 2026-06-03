import { useState, useEffect } from 'react';
import { supabase } from '../supabase';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, LineChart, Line } from 'recharts';
import { Users, Buildings, Megaphone, Warning } from '@phosphor-icons/react';

const AnalyticsDashboard = () => {
  const [stats, setStats] = useState({
    users: 0,
    families: 0,
    notices: 0,
    reports: 0
  });
  const [loading, setLoading] = useState(true);

  // Mock data for charts - in a production environment, this would be aggregated over time via Cloud Functions
  const mockActivityData = [
    { name: 'Mon', activeUsers: 120, notices: 4 },
    { name: 'Tue', activeUsers: 132, notices: 6 },
    { name: 'Wed', activeUsers: 101, notices: 2 },
    { name: 'Thu', activeUsers: 145, notices: 8 },
    { name: 'Fri', activeUsers: 190, notices: 12 },
    { name: 'Sat', activeUsers: 210, notices: 5 },
    { name: 'Sun', activeUsers: 180, notices: 3 },
  ];

  const mockGrowthData = [
    { month: 'Jan', families: 10, users: 40 },
    { month: 'Feb', families: 15, users: 65 },
    { month: 'Mar', families: 22, users: 90 },
    { month: 'Apr', families: 30, users: 130 },
    { month: 'May', families: 45, users: 180 },
  ];

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const [usersSnap, familiesSnap, noticesSnap, reportsSnap] = await Promise.all([
          supabase.from('users').select('*', { count: 'exact', head: true }),
          supabase.from('families').select('*', { count: 'exact', head: true }),
          supabase.from('notices').select('*', { count: 'exact', head: true }),
          supabase.from('reports').select('*', { count: 'exact', head: true })
        ]);

        setStats({
          users: usersSnap.count || 0,
          families: familiesSnap.count || 0,
          notices: noticesSnap.count || 0,
          reports: reportsSnap.count || 0
        });
      } catch (error) {
        console.error("Error fetching analytics stats:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchStats();
  }, []);

  return (
    <div>
      <div style={{ marginBottom: '32px' }}>
        <h1>Analytics Dashboard</h1>
        <p style={{ color: 'var(--text-muted)' }}>Platform engagement and growth metrics.</p>
      </div>
      
      {loading ? (
        <div style={{ padding: '40px', textAlign: 'center' }}>Loading metrics...</div>
      ) : (
        <>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '24px', marginBottom: '32px' }}>
            <div className="glass-card" style={{ display: 'flex', alignItems: 'center', gap: '16px', padding: '24px' }}>
              <div style={{ padding: '16px', backgroundColor: 'rgba(59, 130, 246, 0.1)', borderRadius: '12px' }}>
                <Users size={32} color="#3b82f6" />
              </div>
              <div>
                <div style={{ fontSize: '24px', fontWeight: 'bold' }}>{stats.users}</div>
                <div style={{ color: 'var(--text-muted)', fontSize: '14px' }}>Total Users</div>
              </div>
            </div>

            <div className="glass-card" style={{ display: 'flex', alignItems: 'center', gap: '16px', padding: '24px' }}>
              <div style={{ padding: '16px', backgroundColor: 'rgba(16, 185, 129, 0.1)', borderRadius: '12px' }}>
                <Buildings size={32} color="#10b981" />
              </div>
              <div>
                <div style={{ fontSize: '24px', fontWeight: 'bold' }}>{stats.families}</div>
                <div style={{ color: 'var(--text-muted)', fontSize: '14px' }}>Registered Families</div>
              </div>
            </div>

            <div className="glass-card" style={{ display: 'flex', alignItems: 'center', gap: '16px', padding: '24px' }}>
              <div style={{ padding: '16px', backgroundColor: 'rgba(168, 85, 247, 0.1)', borderRadius: '12px' }}>
                <Megaphone size={32} color="#a855f7" />
              </div>
              <div>
                <div style={{ fontSize: '24px', fontWeight: 'bold' }}>{stats.notices}</div>
                <div style={{ color: 'var(--text-muted)', fontSize: '14px' }}>Total Notices</div>
              </div>
            </div>

            <div className="glass-card" style={{ display: 'flex', alignItems: 'center', gap: '16px', padding: '24px' }}>
              <div style={{ padding: '16px', backgroundColor: 'rgba(239, 68, 68, 0.1)', borderRadius: '12px' }}>
                <Warning size={32} color="#ef4444" />
              </div>
              <div>
                <div style={{ fontSize: '24px', fontWeight: 'bold' }}>{stats.reports}</div>
                <div style={{ color: 'var(--text-muted)', fontSize: '14px' }}>User Reports</div>
              </div>
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '24px' }}>
            <div className="glass-card" style={{ padding: '24px' }}>
              <h3 style={{ marginBottom: '24px', fontWeight: '500' }}>Weekly Activity</h3>
              <div style={{ height: '300px' }}>
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={mockActivityData}>
                    <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
                    <XAxis dataKey="name" stroke="var(--text-muted)" />
                    <YAxis stroke="var(--text-muted)" />
                    <Tooltip 
                      contentStyle={{ backgroundColor: '#1a1a1a', border: '1px solid #333', borderRadius: '8px' }}
                    />
                    <Bar dataKey="activeUsers" fill="#3b82f6" name="Active Users" radius={[4, 4, 0, 0]} />
                    <Bar dataKey="notices" fill="#a855f7" name="Notices Sent" radius={[4, 4, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </div>

            <div className="glass-card" style={{ padding: '24px' }}>
              <h3 style={{ marginBottom: '24px', fontWeight: '500' }}>Platform Growth</h3>
              <div style={{ height: '300px' }}>
                <ResponsiveContainer width="100%" height="100%">
                  <LineChart data={mockGrowthData}>
                    <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
                    <XAxis dataKey="month" stroke="var(--text-muted)" />
                    <YAxis stroke="var(--text-muted)" />
                    <Tooltip 
                      contentStyle={{ backgroundColor: '#1a1a1a', border: '1px solid #333', borderRadius: '8px' }}
                    />
                    <Line type="monotone" dataKey="users" stroke="#3b82f6" strokeWidth={3} name="Total Users" />
                    <Line type="monotone" dataKey="families" stroke="#10b981" strokeWidth={3} name="Total Families" />
                  </LineChart>
                </ResponsiveContainer>
              </div>
            </div>
          </div>
        </>
      )}
    </div>
  );
};

export default AnalyticsDashboard;
