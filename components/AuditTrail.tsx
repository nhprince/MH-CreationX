
import React, { useState, useEffect } from 'react';
import { useAppStore } from '../store';
import { AuditLog } from '../types';
import { History, Search, Filter, Trash2, User, Briefcase, CreditCard, Settings, Clock } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

const AuditTrail: React.FC = () => {
  const { auditLogs, clearAuditLogs, currentUser, loadInitialData } = useAppStore();
  const isAdmin = currentUser?.role === 'Admin';
  const isStaff = !!currentUser;
  const [isLoading, setIsLoading] = useState(false);

  const formatDetails = (log: AuditLog) => {
    const details = log?.details || '';
    if (log?.action === 'Update Project' && details.startsWith('Updated fields:')) {
      const raw = details
        .replace(/^Updated fields:\s*/i, '')
        .replace(/\s*for project\s+/i, ' for project ');

      const parts = raw.split(/\s+for project\s+/i);
      const fieldsPart = (parts[0] || '').trim();
      const projectId = (parts[1] || '').trim();

      const map: Record<string, string> = {
        title: 'Title',
        description: 'Description',
        category: 'Category',
        status: 'Status',
        delivery_date: 'Delivery date',
        price: 'Price',
        advance_amount: 'Advance',
        paid_amount: 'Payment received',
        discount: 'Discount',
        payment_status: 'Payment status',
        payment_method: 'Payment method',
        payment_details: 'Payment details',
        drive_link: 'Download link',
        designer_name: 'Designer name',
        assistant_name: 'Assistant name',
        is_visible_on_public: 'Public visibility',
        show_in_animation: 'Show in animation',
        show_in_previous: 'Show in previous'
      };

      const friendlyFields = fieldsPart
        .split(',')
        .map((f) => f.trim())
        .filter(Boolean)
        .map((f) => map[f] || f);

      if (friendlyFields.length > 0 && projectId) {
        return `Updated project ${projectId}: ${friendlyFields.join(', ')}`;
      }
    }

    return details;
  };

  // Ensure audit logs are loaded
  useEffect(() => {
    const loadAudits = async () => {
      if (isStaff && (!auditLogs || auditLogs.length === 0)) {
        setIsLoading(true);
        try {
          await loadInitialData(true);
        } catch (error) {
          console.error('Failed to load audit logs:', error);
        } finally {
          setIsLoading(false);
        }
      }
    };
    loadAudits();
  }, [isStaff]);

  const [searchTerm, setSearchTerm] = useState('');
  const [categoryFilter, setCategoryFilter] = useState<AuditLog['category'] | 'all'>('all');

  // Safe filtering with null check to prevent crashes
  const filteredLogs = (auditLogs || []).filter(log => {
    const action = log?.action || '';
    const userName = log?.userName || '';
    const details = log?.details || '';

    const matchesSearch = action.toLowerCase().includes(searchTerm.toLowerCase()) ||
      userName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      details.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = categoryFilter === 'all' || log.category === categoryFilter;
    return matchesSearch && matchesCategory;
  });

  const getCategoryIcon = (category: AuditLog['category']) => {
    switch (category) {
      case 'project': return <Briefcase size={16} className="text-indigo-500" />;
      case 'finance': return <CreditCard size={16} className="text-emerald-500" />;
      case 'user': return <User size={16} className="text-amber-500" />;
      case 'system': return <Settings size={16} className="text-slate-500" />;
      default: return <History size={16} />;
    }
  };

  const getCategoryColor = (category: AuditLog['category']) => {
    switch (category) {
      case 'project': return 'bg-indigo-50 dark:bg-indigo-950/20 text-indigo-600 border-indigo-100 dark:border-indigo-800';
      case 'finance': return 'bg-emerald-50 dark:bg-emerald-950/20 text-emerald-600 border-emerald-100 dark:border-emerald-800';
      case 'user': return 'bg-amber-50 dark:bg-amber-950/20 text-amber-600 border-amber-100 dark:border-amber-800';
      case 'system': return 'bg-slate-50 dark:bg-slate-800 text-slate-600 border-slate-200 dark:border-slate-700';
      default: return 'bg-slate-50 text-slate-600';
    }
  };

  return (
    <div className="max-w-6xl mx-auto space-y-10 pb-20">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-6">
        <div>
          <h2 className="text-4xl font-black text-slate-900 dark:text-white tracking-tight">Audit Trail</h2>
          <p className="text-slate-500 font-medium">Monitoring all administrative activities and system changes.</p>
        </div>
        {isAdmin && auditLogs.length > 0 && (
          <button
            onClick={() => { if (confirm('Permanently clear all logs?')) clearAuditLogs(); }}
            className="flex items-center gap-3 bg-rose-50 dark:bg-rose-950/20 hover:bg-rose-500 hover:text-white text-rose-500 px-6 py-3 rounded-2xl font-black text-xs uppercase tracking-widest transition-all border border-rose-200 dark:border-rose-900/50"
          >
            <Trash2 size={18} />
            Purge History
          </button>
        )}
      </div>

      <div className="flex flex-col md:flex-row gap-6">
        <div className="relative flex-1">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={20} />
          <input
            type="text"
            placeholder="Search by user, action or description..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl py-4 pl-12 pr-6 shadow-sm focus:ring-2 focus:ring-indigo-500 outline-none transition-all"
          />
        </div>
        <div className="flex items-center gap-3 bg-white dark:bg-slate-900 p-2 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm overflow-x-auto whitespace-nowrap">
          <Filter size={16} className="text-slate-400 mx-2 hidden md:block" />
          {(['all', 'project', 'finance', 'user', 'system'] as const).map(cat => (
            <button
              key={cat}
              onClick={() => setCategoryFilter(cat)}
              className={`px-6 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all ${categoryFilter === cat ? 'bg-indigo-600 text-white shadow-lg' : 'text-slate-500 hover:bg-slate-50 dark:hover:bg-slate-800'}`}
            >
              {cat}
            </button>
          ))}
        </div>
      </div>

      <div className="space-y-4">
        <AnimatePresence mode="popLayout">
          {filteredLogs.length > 0 ? filteredLogs.map((log) => (
            <motion.div
              key={log.id}
              layout
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.95 }}
              className="glass p-6 md:p-8 rounded-[2.5rem] border border-slate-200 dark:border-slate-800 flex flex-col md:flex-row md:items-center gap-6 group hover:shadow-xl transition-all"
            >
              <div className={`w-14 h-14 shrink-0 rounded-2xl flex items-center justify-center border ${getCategoryColor(log.category)}`}>
                {getCategoryIcon(log.category)}
              </div>

              <div className="flex-1 space-y-2">
                <div className="flex flex-wrap items-center gap-x-4 gap-y-2">
                  <h4 className="text-lg font-black text-slate-900 dark:text-white tracking-tight">{log.action}</h4>
                  <span className={`px-3 py-1 rounded-lg text-[8px] font-black uppercase tracking-widest border ${getCategoryColor(log.category)}`}>
                    {log.category}
                  </span>
                </div>
                <p className="text-sm text-slate-600 dark:text-slate-400 font-medium leading-relaxed italic">
                  "{formatDetails(log)}"
                </p>
                <div className="flex items-center gap-6 pt-2">
                  <div className="flex items-center gap-2 text-[10px] font-black uppercase text-slate-400 tracking-widest">
                    <User size={12} className="text-indigo-500" />
                    <span>{log.userName}</span>
                  </div>
                  <div className="flex items-center gap-2 text-[10px] font-black uppercase text-slate-400 tracking-widest">
                    <Clock size={12} className="text-indigo-500" />
                    <span>{new Date(log.timestamp).toLocaleString()}</span>
                  </div>
                </div>
              </div>
            </motion.div>
          )) : (
            <div className="glass p-24 text-center rounded-[3rem] border-2 border-dashed border-slate-200 dark:border-slate-800">
              <History size={48} className="mx-auto mb-4 text-slate-300" />
              <p className="text-slate-400 font-bold text-lg">No audit records found matching your criteria.</p>
            </div>
          )}
        </AnimatePresence>
      </div>
    </div>
  );
};

export default AuditTrail;
