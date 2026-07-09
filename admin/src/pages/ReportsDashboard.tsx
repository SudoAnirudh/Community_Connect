import { useState, useEffect } from 'react';
import { supabase } from '../supabase';
import { EyeSlash, CheckCircle, Warning, MagnifyingGlass } from '@phosphor-icons/react';

const ReportsDashboard = () => {
  const [reports, setReports] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');

  const fetchReports = async () => {
    const { data, error } = await supabase
      .from('reports')
      .select('*')
      .order('created_at', { ascending: false });
    if (error) {
      console.error("Error fetching reports:", error);
      setLoading(false);
      return;
    }
    setReports(
      data.map(rep => ({
        id: rep.id,
        contentType: rep.content_type,
        contentId: rep.content_id,
        reason: rep.reason,
        reportedBy: rep.reported_by,
        status: rep.status,
        actionTaken: rep.action_taken,
        created_at: rep.created_at
      }))
    );
    setLoading(false);
  };

  useEffect(() => {
    fetchReports();

    const channel = supabase
      .channel('reports-changes')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'reports' }, () => {
        fetchReports();
      })
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, []);

  const handleHideContent = async (reportId: string, contentId: string, contentType: string) => {
    if (window.confirm("Hide this content? It will no longer be visible to regular users.")) {
      try {
        // Mark report as resolved
        const { error: repErr } = await supabase
          .from('reports')
          .update({
            status: 'resolved',
            action_taken: 'hidden'
          })
          .eq('id', reportId);
        if (repErr) throw repErr;
        
        // Hide the actual content based on its type
        if (contentType && contentId) {
          const { error: contentErr } = await supabase
            .from(contentType)
            .update({ hidden: true })
            .eq('id', contentId);
          if (contentErr) throw contentErr;
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
        const { error } = await supabase
          .from('reports')
          .update({
            status: 'dismissed',
            action_taken: 'none'
          })
          .eq('id', reportId);
        if (error) throw error;
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
                      {rep.created_at ? new Date(rep.created_at).toLocaleDateString() : 'Unknown'}
                    </td>
                    <td style={{ padding: '16px 24px' }}>
                      {rep.status === 'pending' || !rep.status ? (
                        <div style={{ display: 'flex', gap: '8px' }}>
                          <button 
                            onClick={() => handleHideContent(rep.id, rep.contentId, rep.contentType)}
                            style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#ef4444' }}
                            title="Hide Content"
                            aria-label="Hide Content"
                          >
                            <EyeSlash size={20} />
                          </button>
                          <button 
                            onClick={() => handleDismissReport(rep.id)}
                            style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#10b981' }}
                            title="Dismiss Report"
                            aria-label="Dismiss Report"
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
