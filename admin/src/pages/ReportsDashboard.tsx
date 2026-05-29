import { useState, useEffect } from 'react';
import { collection, query, orderBy, onSnapshot, doc, updateDoc } from 'firebase/firestore';
import { db } from '../firebase';
import { EyeSlash, CheckCircle, Warning, MagnifyingGlass } from '@phosphor-icons/react';

const ReportsDashboard = () => {
  const [reports, setReports] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    // Listen to reports collection
    const q = query(collection(db, 'reports'), orderBy('createdAt', 'desc'));
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const data: any[] = [];
      snapshot.forEach((doc) => {
        data.push({ id: doc.id, ...doc.data() });
      });
      setReports(data);
      setLoading(false);
    }, (error) => {
      console.error("Error fetching reports:", error);
      setLoading(false);
    });

    return () => unsubscribe();
  }, []);

  const handleHideContent = async (reportId: string, contentId: string, contentType: string) => {
    if (window.confirm("Hide this content? It will no longer be visible to regular users.")) {
      try {
        // Mark report as resolved
        await updateDoc(doc(db, 'reports', reportId), {
          status: 'resolved',
          actionTaken: 'hidden'
        });
        
        // Hide the actual content based on its type
        if (contentType && contentId) {
           await updateDoc(doc(db, contentType, contentId), {
             hidden: true
           });
        }
      } catch (e) {
        console.error("Error hiding content:", e);
        alert("Failed to update content status.");
      }
    }
  };

  const handleDismissReport = async (reportId: string) => {
    if (window.confirm("Dismiss this report? The content will remain visible.")) {
      try {
        await updateDoc(doc(db, 'reports', reportId), {
          status: 'dismissed',
          actionTaken: 'none'
        });
      } catch (e) {
        console.error("Error dismissing report:", e);
        alert("Failed to dismiss report.");
      }
    }
  };

  const filteredReports = reports.filter(rep => 
    rep.reason?.toLowerCase().includes(searchTerm.toLowerCase()) || 
    rep.reportedBy?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div>
      <div style={{ marginBottom: '32px', display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end' }}>
        <div>
          <h1>Reports & Moderation</h1>
          <p style={{ color: 'var(--text-muted)' }}>Review and moderate user-flagged content.</p>
        </div>
        
        <div className="input-group" style={{ position: 'relative', width: '250px' }}>
          <MagnifyingGlass size={20} color="var(--text-muted)" style={{ position: 'absolute', left: '12px', top: '12px' }} />
          <input 
            type="text" 
            className="input" 
            placeholder="Search reason or user ID..." 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            style={{ paddingLeft: '40px' }}
          />
        </div>
      </div>

      <div className="glass-card" style={{ padding: '0', overflow: 'hidden' }}>
        {loading ? (
          <div style={{ padding: '40px', textAlign: 'center' }}>Loading reports...</div>
        ) : (
          <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
            <thead style={{ backgroundColor: 'rgba(255,255,255,0.05)', borderBottom: '1px solid var(--border)' }}>
              <tr>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Type</th>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Reason</th>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Reported By</th>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Status</th>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Date</th>
                <th style={{ padding: '16px 24px', fontWeight: '500', color: 'var(--text-muted)' }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredReports.length === 0 ? (
                <tr>
                  <td colSpan={6} style={{ padding: '40px', textAlign: 'center', color: 'var(--text-muted)' }}>
                    No pending reports.
                  </td>
                </tr>
              ) : (
                filteredReports.map((rep) => (
                  <tr key={rep.id} style={{ borderBottom: '1px solid var(--border)', opacity: rep.status === 'pending' ? 1 : 0.6 }}>
                    <td style={{ padding: '16px 24px', textTransform: 'capitalize' }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                        <Warning color="var(--primary)" />
                        {rep.contentType || 'Unknown'}
                      </div>
                    </td>
                    <td style={{ padding: '16px 24px', maxWidth: '300px', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                      {rep.reason}
                    </td>
                    <td style={{ padding: '16px 24px', color: 'var(--text-muted)', fontSize: '14px' }}>
                      {rep.reportedBy}
                    </td>
                    <td style={{ padding: '16px 24px' }}>
                      <span className="badge" style={{ backgroundColor: rep.status === 'pending' ? 'rgba(245, 158, 11, 0.1)' : 'rgba(255, 255, 255, 0.1)', color: rep.status === 'pending' ? '#f59e0b' : 'white' }}>
                        {rep.status || 'pending'}
                      </span>
                    </td>
                    <td style={{ padding: '16px 24px', color: 'var(--text-muted)' }}>
                      {rep.createdAt?.toDate ? rep.createdAt.toDate().toLocaleDateString() : 'Unknown'}
                    </td>
                    <td style={{ padding: '16px 24px' }}>
                      {rep.status === 'pending' || !rep.status ? (
                        <div style={{ display: 'flex', gap: '8px' }}>
                          <button 
                            onClick={() => handleHideContent(rep.id, rep.contentId, rep.contentType)}
                            style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#ef4444' }}
                            title="Hide Content"
                          >
                            <EyeSlash size={20} />
                          </button>
                          <button 
                            onClick={() => handleDismissReport(rep.id)}
                            style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#10b981' }}
                            title="Dismiss Report"
                          >
                            <CheckCircle size={20} />
                          </button>
                        </div>
                      ) : (
                        <span style={{ fontSize: '14px', color: 'var(--text-muted)' }}>Resolved</span>
                      )}
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

export default ReportsDashboard;
