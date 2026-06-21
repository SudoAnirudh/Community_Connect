import { useState, useEffect } from 'react';
import { supabase } from '../supabase';
import { Users, Buildings, ShieldWarning, ArrowRight } from '@phosphor-icons/react';
import { Link } from 'react-router-dom';

const OverviewDashboard = () => {
  const [stats, setStats] = useState({ users: 0, families: 0, pendingReports: 0 });
  const [recentUsers, setRecentUsers] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchOverviewData = async () => {
      try {
        const [usersRes, familiesRes, reportsRes, recentUsersRes] = await Promise.all([
          supabase.from('users').select('*', { count: 'exact', head: true }),
          supabase.from('families').select('*', { count: 'exact', head: true }),
          // ⚡ Bolt: Use count instead of fetching full rows to reduce payload size
          supabase.from('reports').select('*', { count: 'exact', head: true }).eq('status', 'pending'),
          supabase.from('users').select('*').order('created_at', { ascending: false }).limit(5)
        ]);

        setStats({
          users: usersRes.count || 0,
          families: familiesRes.count || 0,
          pendingReports: reportsRes.count || 0
        });

        if (recentUsersRes.data) {
          setRecentUsers(recentUsersRes.data.map(u => ({ id: u.uid, ...u })));
        }

      } catch (error) {
        console.error("Error fetching overview data:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchOverviewData();
  }, []);

  return (
    <div>
      <div style={{ marginBottom: '32px' }}>
        <h1>Overview Dashboard</h1>
        <p style={{ color: 'var(--text-muted)' }}>Welcome back, Super Admin. Here is what's happening today.</p>
      </div>
      
      {loading ? (
        <div style={{ padding: '40px', textAlign: 'center' }}>Loading dashboard...</div>
      ) : (
        <>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', gap: '24px', marginBottom: '32px' }}>
            <div className="glass-card" style={{ padding: '24px', display: 'flex', flexDirection: 'column', gap: '16px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div style={{ padding: '12px', backgroundColor: 'rgba(59, 130, 246, 0.1)', borderRadius: '12px' }}>
                  <Users size={24} color="#3b82f6" />
                </div>
                <Link to="/users" style={{ color: 'var(--primary)', textDecoration: 'none', display: 'flex', alignItems: 'center', gap: '4px', fontSize: '14px' }}>
                  View All <ArrowRight size={16} />
                </Link>
              </div>
              <div>
                <div style={{ fontSize: '32px', fontWeight: 'bold' }}>{stats.users}</div>
                <div style={{ color: 'var(--text-muted)', fontSize: '14px' }}>Total Registered Users</div>
              </div>
            </div>

            <div className="glass-card" style={{ padding: '24px', display: 'flex', flexDirection: 'column', gap: '16px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div style={{ padding: '12px', backgroundColor: 'rgba(16, 185, 129, 0.1)', borderRadius: '12px' }}>
                  <Buildings size={24} color="#10b981" />
                </div>
                <Link to="/families" style={{ color: 'var(--primary)', textDecoration: 'none', display: 'flex', alignItems: 'center', gap: '4px', fontSize: '14px' }}>
                  View All <ArrowRight size={16} />
                </Link>
              </div>
              <div>
                <div style={{ fontSize: '32px', fontWeight: 'bold' }}>{stats.families}</div>
                <div style={{ color: 'var(--text-muted)', fontSize: '14px' }}>Verified Families</div>
              </div>
            </div>

            <div className="glass-card" style={{ padding: '24px', display: 'flex', flexDirection: 'column', gap: '16px', border: stats.pendingReports > 0 ? '1px solid rgba(245, 158, 11, 0.3)' : undefined }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div style={{ padding: '12px', backgroundColor: 'rgba(245, 158, 11, 0.1)', borderRadius: '12px' }}>
                  <ShieldWarning size={24} color="#f59e0b" />
                </div>
                <Link to="/reports" style={{ color: 'var(--primary)', textDecoration: 'none', display: 'flex', alignItems: 'center', gap: '4px', fontSize: '14px' }}>
                  Review <ArrowRight size={16} />
                </Link>
              </div>
              <div>
                <div style={{ fontSize: '32px', fontWeight: 'bold', color: stats.pendingReports > 0 ? '#f59e0b' : 'inherit' }}>
                  {stats.pendingReports}
                </div>
                <div style={{ color: 'var(--text-muted)', fontSize: '14px' }}>Pending Reports</div>
              </div>
            </div>
          </div>

          <div className="glass-card" style={{ padding: '0', overflow: 'hidden' }}>
            <div style={{ padding: '24px', borderBottom: '1px solid var(--border)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <h3 style={{ margin: 0, fontWeight: '500' }}>Recently Joined Users</h3>
            </div>
            <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
              <thead style={{ backgroundColor: 'rgba(255,255,255,0.02)' }}>
                <tr>
                  <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Name</th>
                  <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Phone</th>
                  <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Role</th>
                  <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Joined Date</th>
                </tr>
              </thead>
              <tbody>
                {recentUsers.length === 0 ? (
                  <tr>
                    <td colSpan={4} style={{ padding: '24px', textAlign: 'center', color: 'var(--text-muted)' }}>No recent users</td>
                  </tr>
                ) : (
                  recentUsers.map((user) => (
                    <tr key={user.id} style={{ borderBottom: '1px solid var(--border)' }}>
                      <td style={{ padding: '16px 24px', fontWeight: '500' }}>{user.name || 'Unknown'}</td>
                      <td style={{ padding: '16px 24px' }}>{user.phone}</td>
                      <td style={{ padding: '16px 24px' }}>
                        <span className="badge" style={{ backgroundColor: user.role === 'admin' ? 'rgba(59, 130, 246, 0.1)' : 'rgba(255, 255, 255, 0.1)', color: user.role === 'admin' ? '#3b82f6' : 'white' }}>
                          {user.role || 'member'}
                        </span>
                      </td>
                      <td style={{ padding: '16px 24px', color: 'var(--text-muted)' }}>
                        {user.created_at ? new Date(user.created_at).toLocaleDateString() : 'Just now'}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </>
      )}
    </div>
  );
};

export default OverviewDashboard;
