import { useState, useEffect } from 'react';
import { collection, query, orderBy, onSnapshot, deleteDoc, doc } from 'firebase/firestore';
import { db } from '../firebase';
import { Trash, EnvelopeSimple, MagnifyingGlass } from '@phosphor-icons/react';

const InvitationsDashboard = () => {
  const [invitations, setInvitations] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    // Assuming invitations collection exists and has createdAt
    const q = query(collection(db, 'invitations'), orderBy('createdAt', 'desc'));
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const data: any[] = [];
      snapshot.forEach((doc) => {
        data.push({ id: doc.id, ...doc.data() });
      });
      setInvitations(data);
      setLoading(false);
    }, (error) => {
      console.error("Error fetching invitations:", error);
      // Fallback if index is missing or collection is empty
      setLoading(false);
    });

    return () => unsubscribe();
  }, []);

  const handleDelete = async (invitationId: string) => {
    if (window.confirm("Are you sure you want to delete this invitation?")) {
      try {
        await deleteDoc(doc(db, 'invitations', invitationId));
      } catch (e) {
        console.error("Error deleting invitation:", e);
        alert("Failed to delete invitation.");
      }
    }
  };

  const filteredInvitations = invitations.filter(inv => 
    inv.code?.toLowerCase().includes(searchTerm.toLowerCase()) || 
    inv.familyId?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div>
      <div style={{ marginBottom: '32px', display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end' }}>
        <div>
          <h1>Invitations Management</h1>
          <p style={{ color: 'var(--text-muted)' }}>Monitor active family join invitations and links.</p>
        </div>
        
        <div className="input-group" style={{ position: 'relative', width: '250px' }}>
          <MagnifyingGlass size={20} color="var(--text-muted)" style={{ position: 'absolute', left: '12px', top: '12px' }} />
          <input 
            type="text" 
            className="input" 
            placeholder="Search code or family ID..." 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            style={{ paddingLeft: '40px' }}
          />
        </div>
      </div>

      <div className="glass-card" style={{ padding: '0', overflow: 'hidden' }}>
        {loading ? (
          <div style={{ padding: '40px', textAlign: 'center' }}>Loading invitations...</div>
        ) : (
          <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
            <thead style={{ backgroundColor: 'rgba(255,255,255,0.05)', borderBottom: '1px solid var(--border)' }}>
              <tr>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Code</th>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Family ID</th>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Status</th>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Created At</th>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredInvitations.length === 0 ? (
                <tr>
                  <td colSpan={5} style={{ padding: '40px', textAlign: 'center', color: 'var(--text-muted)' }}>
                    No active invitations found.
                  </td>
                </tr>
              ) : (
                filteredInvitations.map((inv) => (
                  <tr key={inv.id} style={{ borderBottom: '1px solid var(--border)' }}>
                    <td style={{ padding: '16px 24px', fontWeight: '500', fontFamily: 'monospace', letterSpacing: '2px' }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                        <EnvelopeSimple color="var(--primary)" />
                        {inv.code}
                      </div>
                    </td>
                    <td style={{ padding: '16px 24px', color: 'var(--text-muted)' }}>{inv.familyId}</td>
                    <td style={{ padding: '16px 24px' }}>
                      <span className="badge" style={{ backgroundColor: inv.used ? 'rgba(239, 68, 68, 0.1)' : 'rgba(16, 185, 129, 0.1)', color: inv.used ? '#ef4444' : '#10b981' }}>
                        {inv.used ? 'Used' : 'Active'}
                      </span>
                    </td>
                    <td style={{ padding: '16px 24px', color: 'var(--text-muted)' }}>
                      {inv.createdAt?.toDate ? inv.createdAt.toDate().toLocaleDateString() : 'Unknown'}
                    </td>
                    <td style={{ padding: '16px 24px' }}>
                      <button 
                        onClick={() => handleDelete(inv.id)}
                        style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#ef4444' }}
                        title="Delete Invitation"
                      >
                        <Trash size={20} />
                      </button>
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

export default InvitationsDashboard;
