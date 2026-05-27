import React, { useState, useEffect } from 'react';
import { collection, addDoc, query, orderBy, onSnapshot, serverTimestamp } from 'firebase/firestore';
import { db } from './firebase';
import { PaperPlaneRight, Megaphone, CircleNotch } from '@phosphor-icons/react';

const ICONS = ['info', 'warning', 'check', 'calendar', 'megaphone', 'drop'];
const COLORS = ['#3b82f6', '#ef4444', '#10b981', '#f59e0b', '#8b5cf6'];

const NoticesDashboard = () => {
  const [notices, setNotices] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  
  // Form State
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [priority, setPriority] = useState('high');
  const [selectedIcon, setSelectedIcon] = useState('info');
  const [selectedColor, setSelectedColor] = useState('#3b82f6');
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    const q = query(collection(db, 'notices'), orderBy('createdAt', 'desc'));
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const data: any[] = [];
      snapshot.forEach((doc) => {
        data.push({ id: doc.id, ...doc.data() });
      });
      setNotices(data);
      setLoading(false);
    });

    return () => unsubscribe();
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!title || !description) return;

    setSubmitting(true);
    try {
      await addDoc(collection(db, 'notices'), {
        title,
        description,
        priority,
        icon: selectedIcon,
        colorHex: selectedColor,
        createdAt: serverTimestamp(),
      });
      
      setTitle('');
      setDescription('');
      alert("Notice posted successfully!");
    } catch (error) {
      console.error("Error adding notice: ", error);
      alert("Failed to post notice.");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div>
      <div style={{ marginBottom: '32px' }}>
        <h1>Notice Board</h1>
        <p style={{ color: 'var(--text-muted)' }}>Publish announcements to the community mobile app.</p>
      </div>

      <div style={{ display: 'flex', gap: '32px', alignItems: 'flex-start' }}>
        {/* Publish Form */}
        <div className="glass-card" style={{ flex: '0 0 400px' }}>
          <h2 style={{ marginBottom: '24px', fontSize: '18px', display: 'flex', alignItems: 'center', gap: '8px' }}>
            <Megaphone /> Create Notice
          </h2>
          <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
            <div>
              <label style={{ display: 'block', marginBottom: '8px', fontSize: '14px' }}>Title</label>
              <input 
                className="input" 
                value={title} 
                onChange={e => setTitle(e.target.value)} 
                placeholder="e.g. Water Supply Interruption" 
                required 
              />
            </div>
            <div>
              <label style={{ display: 'block', marginBottom: '8px', fontSize: '14px' }}>Description</label>
              <textarea 
                className="input" 
                value={description} 
                onChange={e => setDescription(e.target.value)} 
                placeholder="Details about the announcement..." 
                rows={4} 
                required 
              />
            </div>
            <div style={{ display: 'flex', gap: '16px' }}>
              <div style={{ flex: 1 }}>
                <label style={{ display: 'block', marginBottom: '8px', fontSize: '14px' }}>Priority</label>
                <select className="input" value={priority} onChange={e => setPriority(e.target.value)}>
                  <option value="high">High</option>
                  <option value="medium">Medium</option>
                  <option value="low">Low</option>
                </select>
              </div>
              <div style={{ flex: 1 }}>
                <label style={{ display: 'block', marginBottom: '8px', fontSize: '14px' }}>Icon</label>
                <select className="input" value={selectedIcon} onChange={e => setSelectedIcon(e.target.value)}>
                  {ICONS.map(i => <option key={i} value={i}>{i}</option>)}
                </select>
              </div>
            </div>
            <div>
              <label style={{ display: 'block', marginBottom: '8px', fontSize: '14px' }}>Theme Color</label>
              <div style={{ display: 'flex', gap: '8px' }}>
                {COLORS.map(c => (
                  <button
                    key={c}
                    type="button"
                    onClick={() => setSelectedColor(c)}
                    style={{
                      width: '32px', height: '32px', borderRadius: '50%', border: 'none',
                      backgroundColor: c, cursor: 'pointer',
                      boxShadow: selectedColor === c ? `0 0 0 2px white, 0 0 0 4px ${c}` : 'none'
                    }}
                  />
                ))}
              </div>
            </div>
            
            <button type="submit" className="btn" disabled={submitting} style={{ marginTop: '16px', justifyContent: 'center' }}>
              {submitting ? <CircleNotch className="spinner" /> : <><PaperPlaneRight weight="fill" /> Publish Notice</>}
            </button>
          </form>
        </div>

        {/* Recent Notices Feed */}
        <div style={{ flex: 1 }}>
          <h2 style={{ marginBottom: '24px', fontSize: '18px' }}>Recent Notices</h2>
          {loading ? (
            <div style={{ textAlign: 'center', padding: '40px' }}><CircleNotch size={32} className="spinner" /></div>
          ) : notices.length === 0 ? (
            <div className="glass-card" style={{ textAlign: 'center', color: 'var(--text-muted)' }}>
              No notices published yet.
            </div>
          ) : (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
              {notices.map(notice => (
                <div key={notice.id} className="glass-card" style={{ display: 'flex', gap: '16px', alignItems: 'flex-start' }}>
                  <div style={{ 
                    width: '48px', height: '48px', borderRadius: '50%', 
                    backgroundColor: notice.colorHex, opacity: 0.8,
                    display: 'flex', justifyContent: 'center', alignItems: 'center'
                  }}>
                    <Megaphone size={24} color="white" />
                  </div>
                  <div style={{ flex: 1 }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '4px' }}>
                      <h3 style={{ fontSize: '16px' }}>{notice.title}</h3>
                      <span className={`badge`} style={{ border: `1px solid ${notice.colorHex}`, color: notice.colorHex }}>
                        {notice.priority}
                      </span>
                    </div>
                    <p style={{ color: 'var(--text-muted)', fontSize: '14px', lineHeight: 1.5 }}>{notice.description}</p>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default NoticesDashboard;
