import { useEffect, useState, useMemo } from 'react';
import { supabase } from './supabase';
import { Check, X, CircleNotch } from '@phosphor-icons/react';

interface Family {
  id: string;
  name: string;
  houseName: string;
  wardNumber: string;
  verificationStatus: string;
}

const FamiliesDashboard = () => {
  const [families, setFamilies] = useState<Family[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchFamilies = async () => {
      const { data, error } = await supabase.from('families').select('*');
      if (error) {
        console.error("Error fetching families:", error);
        return;
      }
      setFamilies(
        data.map(f => ({
          id: f.id,
          name: f.name,
          houseName: f.house_name,
          wardNumber: f.ward_number,
          verificationStatus: f.verification_status,
        }))
      );
      setLoading(false);
    };

    fetchFamilies();

    const channel = supabase
      .channel('families-changes')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'families' }, () => {
        fetchFamilies();
      })
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, []);

  const handleUpdateStatus = async (id: string, status: 'approved' | 'rejected') => {
    try {
      const { error } = await supabase
        .from('families')
        .update({ verification_status: status })
        .eq('id', id);
      if (error) throw error;
    } catch (error) {
      console.error("Error updating status: ", error);
      alert("Failed to update status.");
    }
  };

  const pending = useMemo(() => families.filter(f => f.verificationStatus === 'pending'), [families]);
  const others = useMemo(() => families.filter(f => f.verificationStatus !== 'pending'), [families]);

  if (loading) {
    return (
      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100%' }}>
        <CircleNotch size={48} className="spinner" />
      </div>
    );
  }

  return (
    <div>
      <div style={{ marginBottom: '32px' }}>
        <h1>Family Approvals</h1>
        <p style={{ color: 'var(--text-muted)' }}>Manage community family verification requests.</p>
      </div>

      <h2 style={{ marginBottom: '16px', fontSize: '18px' }}>Pending Requests ({pending.length})</h2>
      {pending.length === 0 ? (
        <div className="glass-card" style={{ marginBottom: '32px', textAlign: 'center', color: 'var(--text-muted)' }}>
          No pending requests.
        </div>
      ) : (
        <div className="grid-2" style={{ marginBottom: '40px' }}>
          {pending.map(family => (
            <div key={family.id} className="glass-card">
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '12px' }}>
                <span className="badge badge-pending">Pending</span>
                <span style={{ fontSize: '12px', color: 'var(--text-muted)' }}>Ward {family.wardNumber}</span>
              </div>
              <h3 style={{ marginBottom: '4px' }}>{family.name}</h3>
              <p style={{ color: 'var(--text-muted)', marginBottom: '24px' }}>{family.houseName}</p>
              
              <div style={{ display: 'flex', gap: '12px' }}>
                <button 
                  className="btn btn-success" 
                  style={{ flex: 1, justifyContent: 'center' }}
                  onClick={() => handleUpdateStatus(family.id, 'approved')}
                >
                  <Check weight="bold" /> Approve
                </button>
                <button 
                  className="btn btn-danger" 
                  style={{ flex: 1, justifyContent: 'center' }}
                  onClick={() => handleUpdateStatus(family.id, 'rejected')}
                >
                  <X weight="bold" /> Reject
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      <h2 style={{ marginBottom: '16px', fontSize: '18px' }}>Processed Families</h2>
      <div className="glass-card" style={{ padding: 0, overflow: 'hidden' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
          <thead>
            <tr style={{ borderBottom: '1px solid var(--surface-border)', background: 'rgba(0,0,0,0.2)' }}>
              <th style={{ padding: '16px' }}>Family Name</th>
              <th style={{ padding: '16px' }}>House</th>
              <th style={{ padding: '16px' }}>Ward</th>
              <th style={{ padding: '16px' }}>Status</th>
            </tr>
          </thead>
          <tbody>
            {others.map(family => (
              <tr key={family.id} style={{ borderBottom: '1px solid var(--surface-border)' }}>
                <td style={{ padding: '16px' }}>{family.name}</td>
                <td style={{ padding: '16px', color: 'var(--text-muted)' }}>{family.houseName}</td>
                <td style={{ padding: '16px' }}>{family.wardNumber}</td>
                <td style={{ padding: '16px' }}>
                  <span className={`badge badge-${family.verificationStatus.toLowerCase()}`}>
                    {family.verificationStatus}
                  </span>
                </td>
              </tr>
            ))}
            {others.length === 0 && (
              <tr>
                <td colSpan={4} style={{ padding: '24px', textAlign: 'center', color: 'var(--text-muted)' }}>
                  No processed families yet.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default FamiliesDashboard;
