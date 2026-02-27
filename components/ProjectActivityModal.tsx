import React from 'react';
import { X, Activity, Clock } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { auditService } from '../services/auditService';
import type { AuditLog } from '../types';

const ProjectActivityModal = ({ isOpen, onClose, projectId, title }: { isOpen: boolean; onClose: () => void; projectId: string; title: string }) => {
    const [projectLogs, setProjectLogs] = React.useState<AuditLog[]>([]);
    const [isLoading, setIsLoading] = React.useState(false);

    React.useEffect(() => {
        let cancelled = false;

        const load = async () => {
            if (!isOpen) return;
            setIsLoading(true);
            try {
                const logs = await auditService.getProjectLogs(projectId, 200);
                if (!cancelled) {
                    const sorted = (logs || []).slice().sort((a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime());
                    setProjectLogs(sorted);
                }
            } catch (e) {
                if (!cancelled) setProjectLogs([]);
            } finally {
                if (!cancelled) setIsLoading(false);
            }
        };

        load();

        return () => {
            cancelled = true;
        };
    }, [isOpen, projectId]);

    return (
        <AnimatePresence>
            {isOpen && (
                <div className="fixed inset-0 z-modal flex items-center justify-center p-4">
                    <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} onClick={onClose} className="absolute inset-0 bg-slate-950/90 backdrop-blur-xl" />
                    <motion.div initial={{ scale: 0.9, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} exit={{ scale: 0.9, opacity: 0 }} className="relative w-full max-w-2xl bg-white dark:bg-slate-900 rounded-[3rem] shadow-2xl overflow-hidden border border-white/10">
                        <div className="p-8 md:p-12">
                            <div className="flex justify-between items-center mb-10">
                                <div>
                                    <h3 className="text-2xl font-black tracking-tight">{title}</h3>
                                    <p className="text-[10px] font-black text-indigo-500 uppercase tracking-widest mt-1">Audit Record • {projectId}</p>
                                </div>
                                <button onClick={onClose} className="p-3 bg-slate-50 dark:bg-slate-800 rounded-xl transition-colors hover:bg-rose-500 hover:text-white"><X size={20} /></button>
                            </div>

                            <div className="space-y-6 max-h-[60vh] overflow-y-auto pr-4 custom-scrollbar">
                                {isLoading ? (
                                    <div className="py-20 text-center opacity-50">
                                        <Activity size={48} className="mx-auto mb-4" />
                                        <p className="text-sm font-black uppercase tracking-widest">Syncing activity…</p>
                                    </div>
                                ) : projectLogs.length > 0 ? projectLogs.map((log) => (
                                    <div key={log.id} className="relative pl-10 border-l-2 border-slate-100 dark:border-slate-800 py-2">
                                        <div className="absolute left-[-9px] top-4 w-4 h-4 rounded-full bg-indigo-600 border-4 border-white dark:border-slate-900 shadow-xl" />
                                        <div className="flex flex-col">
                                            <span className="text-[10px] font-black uppercase text-indigo-500 tracking-widest">{log.action}</span>
                                            <p className="text-sm font-bold text-slate-700 dark:text-slate-200 my-1">{log.details}</p>
                                            <div className="flex items-center gap-3 text-[9px] font-black text-slate-400 uppercase tracking-widest">
                                                <Clock size={10} /> {new Date(log.timestamp).toLocaleString()}
                                                <span className="text-slate-500">• {log.userName}</span>
                                            </div>
                                        </div>
                                    </div>
                                )) : (
                                    <div className="py-20 text-center opacity-30">
                                        <Activity size={48} className="mx-auto mb-4" />
                                        <p className="text-sm font-black uppercase tracking-widest">No activity synchronized</p>
                                    </div>
                                )}
                            </div>
                        </div>
                    </motion.div>
                </div>
            )}
        </AnimatePresence>
    );
};

export default ProjectActivityModal;
