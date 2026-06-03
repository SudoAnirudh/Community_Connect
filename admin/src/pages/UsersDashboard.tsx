import { useState, useEffect } from 'react';
import { supabase } from '../supabase';
import { MagnifyingGlass, Funnel, Trash, ShieldSlash, CheckCircle, XCircle } from '@phosphor-icons/react';

const UsersDashboard = () => {
  const [users, setUsers] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterRole, setFilterRole] = useState('all');

  const fetchUsers = async () => {
    const { data, error } = await supabase
      .from('users')
      .select('*')
      .order('created_at', { ascending: false });
    if (error) {
      console.error("Error fetching users:", error);
      return;
    }
    setUsers(
      data.map(u => ({
        id: u.uid,
        name: u.name,
        phone: u.phone,
        role: u.role,
        familyId: u.family_id,
        suspended: u.suspended,
        created_at: u.created_at
      }))
    );
    setLoading(false);
  };

  useEffect(() => {
    fetchUsers();

    const channel = supabase
      .channel('users-changes')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'users' }, () => {
        fetchUsers();
      })
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, []);

  const handleSuspend = async (userId: string, currentStatus: boolean) => {
    if (window.confirm(`Are you sure you want to ${currentStatus ? 'un-suspend' : 'suspend'} this user?`)) {
      try {
        const { error } = await supabase
          .from('users')
          .update({ suspended: !currentStatus })
          .eq('uid', userId);
        if (error) throw error;
      } catch (e) {
        console.error("Error suspending user:", e);
        alert("Failed to update user status.");
      }
    }
  };

  const handleDelete = async (userId: string) => {
    if (window.confirm("Are you sure you want to PERMANENTLY delete this user? This cannot be undone.")) {
      try {
        const { error } = await supabase
          .from('users')
          .delete()
          .eq('uid', userId);
        if (error) throw error;
      } catch (e) {
        console.error("Error deleting user:", e);
        alert("Failed to delete user.");
      }
    }
  };

  const filteredUsers = users.filter(user => {
    const matchesSearch = user.name?.toLowerCase().includes(searchTerm.toLowerCase()) || 
                          user.phone?.includes(searchTerm);
    const matchesRole = filterRole === 'all' || user.role === filterRole;
    return matchesSearch && matchesRole;
  });

  return (
    <div>
      <div style={{ marginBottom: '32px', display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end' }}>
        <div>
          <h1>User Management</h1>
          <p style={{ color: 'var(--text-muted)' }}>Manage platform users, roles, and suspensions.</p>
        </div>
        
        <div style={{ display: 'flex', gap: '16px' }}>
          <div className="input-group" style={{ position: 'relative', width: '250px' }}>
            <MagnifyingGlass size={20} color="var(--text-muted)" style={{ position: 'absolute', left: '12px', top: '12px' }} />
            <input 
              type="text" 
              className="input" 
              placeholder="Search by name or phone..." 
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              style={{ paddingLeft: '40px' }}
            />
          </div>
          <div className="input-group" style={{ position: 'relative' }}>
            <Funnel size={20} color="var(--text-muted)" style={{ position: 'absolute', left: '12px', top: '12px' }} />
            <select 
              className="input" 
              value={filterRole} 
              onChange={(e) => setFilterRole(e.target.value)}
              style={{ paddingLeft: '40px', appearance: 'none', width: '150px' }}
            >
              <option value="all">All Roles</option>
              <option value="member">Members</option>
              <option value="admin">Admins</option>
            </select>
          </div>
        </div>
      </div>

      <div className="glass-card" style={{ padding: '0', overflow: 'hidden' }}>
        {loading ? (
          <div style={{ padding: '40px', textAlign: 'center' }}>Loading users...</div>
        ) : (
          <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
            <thead style={{ backgroundColor: 'rgba(255,255,255,0.05)', borderBottom: '1px solid var(--border)' }}>
              <tr>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Name</th>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Phone</th>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Role</th>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Family ID</th>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Status</th>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredUsers.length === 0 ? (
                <tr>
                  <td colSpan={6} style={{ padding: '40px', textAlign: 'center', color: 'var(--text-muted)' }}>
                    No users found matching your criteria.
                  </td>
                </tr>
              ) : (
                filteredUsers.map((user) => (
                  <tr key={user.id} style={{ borderBottom: '1px solid var(--border)' }}>
                    <td style={{ padding: '16px 24px', fontWeight: '500' }}>{user.name || 'Unknown'}</td>
                    <td style={{ padding: '16px 24px' }}>{user.phone}</td>
                    <td style={{ padding: '16px 24px' }}>
                      <span className="badge" style={{ backgroundColor: user.role === 'admin' ? 'rgba(59, 130, 246, 0.1)' : 'rgba(255, 255, 255, 0.1)', color: user.role === 'admin' ? '#3b82f6' : 'white' }}>
                        {user.role || 'member'}
                      </span>
                    </td>
                    <td style={{ padding: '16px 24px', color: 'var(--text-muted)', fontSize: '14px' }}>
                      {user.familyId || 'Not Joined'}
                    </td>
                    <td style={{ padding: '16px 24px' }}>
                      {user.suspended ? (
                        <span style={{ display: 'flex', alignItems: 'center', gap: '6px', color: '#ef4444', fontSize: '14px' }}>
                          <XCircle weight="fill" /> Suspended
                        </span>
                      ) : (
                        <span style={{ display: 'flex', alignItems: 'center', gap: '6px', color: '#10b981', fontSize: '14px' }}>
                          <CheckCircle weight="fill" /> Active
                        </span>
                      )}
                    </td>
                    <td style={{ padding: '16px 24px' }}>
                      <div style={{ display: 'flex', gap: '8px' }}>
                        <button 
                          onClick={() => handleSuspend(user.id, user.suspended || false)}
                          style={{ background: 'none', border: 'none', cursor: 'pointer', color: user.suspended ? '#10b981' : '#f59e0b' }}
                          title={user.suspended ? 'Restore User' : 'Suspend User'}
                        >
                          {user.suspended ? <CheckCircle size={20} /> : <ShieldSlash size={20} />}
                        </button>
                        <button 
                          onClick={() => handleDelete(user.id)}
                          style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#ef4444' }}
                          title="Delete User"
                        >
                          <Trash size={20} />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
};

export default UsersDashboard;
