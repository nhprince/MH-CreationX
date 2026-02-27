
import React, { useState } from 'react';
import { useAppStore } from '../store';
import { UserCheck, Search, Briefcase, TrendingUp, Filter, ArrowRight } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import ProjectCard from './ProjectCard';

const DirectorProfiles: React.FC = () => {
  const { projects } = useAppStore();
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedDirector, setSelectedDirector] = useState<string | null>(null);

  // Extract unique directors
  const directorStats = Array.from(new Set(projects.map(p => p.director))).map(directorName => {
    const directorProjects = projects.filter(p => p.director === directorName);
    const totalEarnings = directorProjects.reduce((acc, p) => acc + p.paidAmount, 0);
    return {
      // Cast directorName to string to avoid unknown type errors
      name: directorName as string,
      projectCount: directorProjects.length,
      totalEarnings,
      lastActive: directorProjects.sort((a,b) => new Date(b.createDate).getTime() - new Date(a.createDate).getTime())[0].createDate
    };
    // Cast d.name to string to safely call toLowerCase()
  }).filter(d => (d.name as string).toLowerCase().includes(searchTerm.toLowerCase()));

  const filteredProjects = selectedDirector 
    ? projects.filter(p => p.director === selectedDirector).sort((a,b) => new Date(b.createDate).getTime() - new Date(a.createDate).getTime())
    : [];

  return (
    <div className="space-y-10 pb-20">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-6">
        <div>
          <h2 className="text-4xl font-black text-slate-900 dark:text-white tracking-tight">Director Network</h2>
          <p className="text-slate-500 font-semibold">Organized by individual project oversight.</p>
        </div>
        <div className="relative">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
          <input 
            type="text" 
            placeholder="Find Director..." 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl py-4 pl-12 pr-6 w-full md:w-80 shadow-sm focus:outline-none font-bold"
          />
        </div>
      </div>

      {!selectedDirector ? (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
          {directorStats.map(director => (
            <motion.div 
              key={director.name}
              whileHover={{ y: -5 }}
              onClick={() => setSelectedDirector(director.name)}
              className="glass p-8 rounded-[3rem] border border-slate-200 dark:border-slate-800 group cursor-pointer hover:border-indigo-500 transition-all shadow-sm hover:shadow-2xl"
            >
              <div className="flex items-center gap-6 mb-8">
                 <div className="w-16 h-16 bg-indigo-50 dark:bg-indigo-950/40 rounded-3xl flex items-center justify-center text-indigo-600">
                    <UserCheck size={32} />
                 </div>
                 <div>
                    <h3 className="text-2xl font-black tracking-tight">{director.name}</h3>
                    <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest">Active Partner</p>
                 </div>
              </div>
              
              <div className="grid grid-cols-2 gap-4 mb-8">
                <div className="p-4 bg-slate-50 dark:bg-slate-800/50 rounded-2xl border border-slate-100">
                   <p className="text-[9px] font-black text-slate-400 uppercase mb-1">Projects</p>
                   <p className="text-xl font-black">{director.projectCount}</p>
                </div>
                <div className="p-4 bg-slate-50 dark:bg-slate-800/50 rounded-2xl border border-slate-100">
                   <p className="text-[9px] font-black text-slate-400 uppercase mb-1">Yield</p>
                   <p className="text-xl font-black text-emerald-600">৳{director.totalEarnings.toLocaleString()}</p>
                </div>
              </div>

              <div className="flex items-center justify-between text-[10px] font-black uppercase text-slate-500 group-hover:text-indigo-600 transition-colors">
                 <span>Recent Activity: {new Date(director.lastActive).toLocaleDateString()}</span>
                 <ArrowRight size={16} />
              </div>
            </motion.div>
          ))}
          {directorStats.length === 0 && (
            <div className="col-span-full py-20 text-center glass rounded-[3rem] border-dashed border-2">
              <p className="text-slate-400 font-black uppercase tracking-widest">No directors found in active registry.</p>
            </div>
          )}
        </div>
      ) : (
        <div className="space-y-8">
           <button 
             onClick={() => setSelectedDirector(null)}
             className="flex items-center gap-2 bg-white dark:bg-slate-900 px-6 py-3 rounded-2xl font-black text-xs uppercase tracking-widest border border-slate-200 hover:text-indigo-600 transition-all"
           >
             <Filter size={16} /> Clear Grouping
           </button>
           <div className="bg-indigo-600 p-10 rounded-[3rem] flex justify-between items-center text-white shadow-2xl shadow-indigo-600/30">
              <div>
                <h3 className="text-4xl font-black tracking-tight">{selectedDirector}</h3>
                <p className="text-indigo-200 font-black uppercase tracking-widest text-[10px] mt-2">Managing {filteredProjects.length} Projects</p>
              </div>
              <UserCheck size={64} className="opacity-20" />
           </div>
           <div className="grid grid-cols-1 gap-6">
              {filteredProjects.map(p => <ProjectCard key={p.id} project={p} />)}
           </div>
        </div>
      )}
    </div>
  );
};

export default DirectorProfiles;
