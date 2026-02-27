
import React from 'react';
import { useAppStore } from '../store';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, AreaChart, Area, Cell, PieChart, Pie } from 'recharts';
import { Users, Eye, TrendingUp, Activity, Briefcase, DollarSign, BarChart3, LayoutTemplate } from 'lucide-react';
import { motion } from 'framer-motion';

const Analytics: React.FC = () => {
  const { projects, visitorCount, auditLogs, customers } = useAppStore();

  const categoryData = Object.values(projects.reduce((acc: any, p) => {
    acc[p.category] = acc[p.category] || { name: p.category, value: 0 };
    acc[p.category].value += 1;
    return acc;
  }, {})) as { name: string, value: number }[];

  const activityData = auditLogs.slice(0, 20).reduce((acc: any, log) => {
    const date = new Date(log.timestamp).toLocaleDateString();
    acc[date] = acc[date] || { date, interactions: 0 };
    acc[date].interactions += 1;
    return acc;
  }, {});

  const chartData = Object.values(activityData).reverse();
  const COLORS = ['#6366f1', '#10b981', '#f59e0b', '#ef4444', '#ec4899', '#8b5cf6'];

  return (
    <div className="space-y-12 pb-20">
      <div className="flex flex-col md:flex-row justify-between items-start md:items-end gap-6">
        <motion.div initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }}>
          <h2 className="text-4xl font-black tracking-tighter">Viewer Analysis</h2>
          <p className="text-[10px] font-black uppercase text-slate-500 tracking-[0.4em] mt-3">Engagement & System Intelligence</p>
        </motion.div>
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          className="flex items-center gap-4 bg-white dark:bg-slate-900 px-8 py-4 rounded-[2rem] border border-slate-200 dark:border-slate-800 shadow-xl"
        >
          <Activity className="text-indigo-600" size={24} />
          <div>
            <p className="text-[10px] font-black uppercase text-slate-400">System Pulse</p>
            <p className="text-xl font-black">Live & Healthy</p>
          </div>
        </motion.div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
        <StatCard label="Unique Visitors" value={visitorCount} icon={<Users />} color="text-indigo-500" delay={0} />
        <StatCard label="Total Audit Events" value={auditLogs.length} icon={<Eye />} color="text-emerald-500" delay={0.1} />
        <StatCard label="Active Projects" value={projects.length} icon={<Briefcase />} color="text-amber-500" delay={0.2} />
        <StatCard label="Client Base" value={customers.length} icon={<TrendingUp />} color="text-pink-500" delay={0.3} />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-12">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="glass p-10 md:p-12 rounded-[4rem] border border-white/10 shadow-2xl h-[500px] flex flex-col"
        >
          <h3 className="text-xl font-black mb-10 flex items-center gap-3">
            <BarChart3 className="text-indigo-500" /> Interaction Frequency
          </h3>
          <div className="flex-1 min-h-[300px]">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={chartData}>
                <defs>
                  <linearGradient id="colorInter" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#6366f1" stopOpacity={0.8} />
                    <stop offset="95%" stopColor="#6366f1" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="rgba(100,100,100,0.1)" />
                <XAxis dataKey="date" hide />
                <Tooltip
                  contentStyle={{ borderRadius: '20px', border: 'none', fontWeight: 'bold' }}
                  itemStyle={{ color: '#6366f1' }}
                />
                <Area type="monotone" dataKey="interactions" stroke="#6366f1" fillOpacity={1} fill="url(#colorInter)" animationDuration={1500} />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="glass p-10 md:p-12 rounded-[4rem] border border-white/10 shadow-2xl flex flex-col"
        >
          <h3 className="text-xl font-black mb-10 flex items-center gap-3">
            <LayoutTemplate className="text-pink-500" /> Production Mix
          </h3>
          <div className="flex-1 min-h-[300px]">
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={categoryData}
                  cx="50%"
                  cy="50%"
                  innerRadius={60}
                  outerRadius={100}
                  paddingAngle={8}
                  dataKey="value"
                  animationBegin={500}
                  animationDuration={1500}
                >
                  {categoryData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip contentStyle={{ borderRadius: '20px', border: 'none', fontWeight: 'bold' }} />
              </PieChart>
            </ResponsiveContainer>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3 mt-8 max-h-32 overflow-y-auto">
            {categoryData.map((c, i) => (
              <div key={c.name} className="flex items-center gap-2 min-w-0">
                <div className="w-3 h-3 rounded-full shrink-0" style={{ backgroundColor: COLORS[i % COLORS.length] }} />
                <span className="text-[10px] font-black uppercase text-slate-500 truncate">{c.name} ({c.value})</span>
              </div>
            ))}
          </div>
        </motion.div>
      </div>
    </div>
  );
};

const StatCard = ({ label, value, icon, color, delay }: any) => (
  <motion.div
    initial={{ opacity: 0, scale: 0.9 }}
    animate={{ opacity: 1, scale: 1 }}
    transition={{ delay, duration: 0.5 }}
    whileHover={{ y: -5, scale: 1.05 }}
    className="glass p-8 rounded-[3rem] border border-white/10 shadow-xl flex flex-col items-center justify-center text-center transition-all"
  >
    <div className={`w-14 h-14 rounded-2xl bg-slate-50 dark:bg-slate-800 flex items-center justify-center mb-6 shadow-sm ${color}`}>
      {React.cloneElement(icon, { size: 28 })}
    </div>
    <p className="text-[10px] font-black uppercase text-slate-400 tracking-widest mb-1">{label}</p>
    <p className="text-3xl font-black">{value.toLocaleString()}</p>
  </motion.div>
);

export default Analytics;
