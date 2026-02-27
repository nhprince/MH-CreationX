
import React, { useState } from 'react';
import { useAppStore } from '../store';
import { DollarSign, TrendingUp, TrendingDown, Wallet, Plus, Trash2, Calendar, FileText, Banknote, CreditCard } from 'lucide-react';
import { motion } from 'framer-motion';
import { PaymentStatus, ProjectStatus } from '../types';

const FinanceHub: React.FC = () => {
  const { projects, expenses, addExpense, deleteExpense, currentUser } = useAppStore();
  const isAdmin = currentUser?.role === 'Admin';

  const [reason, setReason] = useState('');
  const [amount, setAmount] = useState('');
  const [category, setCategory] = useState('Operating');

  if (!isAdmin) return <div className="p-20 text-center">Unauthorized Access</div>;

  // Integrated Calculations
  const totalReceived = projects.reduce((acc, p) => acc + (p.paidAmount || 0), 0);
  const totalEarnings = projects.reduce((acc, p) => acc + (p.price || 0), 0);

  const totalExpense = expenses.reduce((acc, e) => acc + e.amount, 0);
  const totalDue = Math.max(0, totalEarnings - totalReceived);

  const handleAddExpense = (e: React.FormEvent) => {
    e.preventDefault();
    if (!reason || !amount) return;
    addExpense({ reason, amount: Number(amount), category, date: new Date().toISOString() });
    setReason(''); setAmount('');
  };

  return (
    <div className="max-w-6xl mx-auto space-y-10 pb-20">
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
        <div>
          <h2 className="text-3xl font-black tracking-tight">Financial Treasury</h2>
          <p className="text-slate-500 font-bold uppercase text-[9px] tracking-[0.2em] mt-1">Audit, Expenditure & Revenue Control</p>
        </div>
        <div className="flex flex-wrap gap-3 md:gap-4 no-print">
          <button onClick={() => window.print()} className="flex-1 md:flex-none bg-white dark:bg-slate-900 border px-4 md:px-6 py-3 md:py-3.5 rounded-xl md:rounded-2xl font-black text-[8px] md:text-[9px] uppercase tracking-widest flex items-center justify-center gap-2 hover:border-indigo-600 transition-all">
            <FileText size={16} /> Monthly Voucher
          </button>
          <button onClick={() => window.print()} className="flex-1 md:flex-none bg-indigo-600 text-white px-4 md:px-6 py-3 md:py-3.5 rounded-xl md:rounded-2xl font-black text-[8px] md:text-[9px] uppercase tracking-widest shadow-xl flex items-center justify-center gap-2 hover:bg-indigo-500 transition-all">
            <Calendar size={16} /> Yearly Audit
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <MetricBox label="Total Earnings" value={totalEarnings} icon={<TrendingUp />} color="text-emerald-500" bg="bg-emerald-50/50 dark:bg-emerald-950/20" />
        <MetricBox label="Received Amnt" value={totalReceived} icon={<Banknote />} color="text-indigo-500" bg="bg-indigo-50/50 dark:bg-indigo-950/20" />
        <MetricBox label="Outstanding Due" value={totalDue} icon={<CreditCard />} color="text-rose-500" bg="bg-rose-50/50 dark:bg-rose-950/20" />
        <MetricBox label="Total Expenses" value={totalExpense} icon={<TrendingDown />} color="text-rose-600" bg="bg-rose-50/50 dark:bg-rose-950/20" />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 md:gap-10">
        <div className="glass p-6 md:p-8 rounded-[2rem] md:rounded-[2.5rem] border border-slate-200 dark:border-slate-800 shadow-xl h-fit">
          <h3 className="text-base font-black mb-6 flex items-center gap-2">
            <Plus className="text-indigo-600" size={20} /> Record Voucher
          </h3>
          <form onSubmit={handleAddExpense} className="space-y-4 md:space-y-5">
            <div>
              <label className="text-[8px] font-black uppercase text-slate-400 ml-1">Expense Title</label>
              <input value={reason} onChange={e => setReason(e.target.value)} className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-100 dark:border-slate-800 rounded-xl px-5 py-3 md:py-3.5 font-bold outline-none focus:border-indigo-500 transition-all mt-1" />
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 sm:gap-3">
              <div>
                <label className="text-[8px] font-black uppercase text-slate-400 ml-1">Amount (৳)</label>
                <input type="number" value={amount} onChange={e => setAmount(e.target.value)} className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-100 dark:border-slate-800 rounded-xl px-5 py-3 md:py-3.5 font-bold outline-none focus:border-indigo-500 transition-all mt-1" />
              </div>
              <div>
                <label className="text-[8px] font-black uppercase text-slate-400 ml-1">Class</label>
                <select value={category} onChange={e => setCategory(e.target.value)} className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-100 dark:border-slate-800 rounded-xl px-5 py-3 md:py-3.5 font-bold outline-none focus:border-indigo-500 transition-all mt-1">
                  <option>Operating</option>
                  <option>Production</option>
                  <option>Assets</option>
                </select>
              </div>
            </div>
            <button className="w-full bg-indigo-600 text-white py-4 rounded-xl font-black uppercase tracking-widest text-[9px] shadow-lg active:scale-95 transition-all">Post Record</button>
          </form>
        </div>

        <div className="lg:col-span-2 space-y-4 md:space-y-6">
          <div className="flex items-center justify-between px-4">
            <h3 className="text-lg md:text-xl font-black">Expenditure Ledger</h3>
            <p className="text-[8px] font-black text-slate-400 uppercase tracking-widest">{expenses.length} Records</p>
          </div>
          <div className="space-y-3">
            {expenses.map(e => (
              <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} key={e.id} className="glass p-5 md:p-6 rounded-[1.5rem] md:rounded-[2rem] flex items-center justify-between border border-slate-200 dark:border-slate-800 group transition-all">
                <div className="flex items-center gap-4 md:gap-5">
                  <div className="w-10 h-10 bg-rose-50 dark:bg-rose-950/20 rounded-xl flex items-center justify-center text-rose-500 shrink-0"><TrendingDown size={18} /></div>
                  <div className="min-w-0">
                    <h4 className="font-black text-sm text-slate-900 dark:text-white leading-tight truncate">{e.reason}</h4>
                    <p className="text-[8px] font-black uppercase text-slate-400 tracking-widest mt-0.5">{e.category} • {new Date(e.date).toLocaleDateString()}</p>
                  </div>
                </div>
                <div className="flex items-center gap-3 md:gap-4 shrink-0">
                  <p className="text-base md:text-lg font-black text-rose-600">-৳{e.amount.toLocaleString()}</p>
                  <button
                    type="button"
                    onClick={() => {
                      if (confirm(`Delete expense "${e.reason}" (৳${e.amount})?`)) deleteExpense(e.id);
                    }}
                    className="p-2 text-slate-300 hover:text-rose-600 transition-all opacity-0 group-hover:opacity-100 focus:opacity-100"
                    title="Delete expense"
                  >
                    <Trash2 size={16} />
                  </button>
                </div>
              </motion.div>
            ))}
            {expenses.length === 0 && (
              <div className="p-16 md:p-20 text-center glass rounded-[1.5rem] md:rounded-[2rem] border-dashed border-2 border-slate-200 dark:border-slate-800">
                <p className="text-slate-400 font-black uppercase tracking-widest text-[10px]">No expenses recorded</p>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

const MetricBox = ({ label, value, icon, color, bg }: any) => (
  <div className={`${bg} p-5 md:p-6 rounded-2xl md:rounded-3xl border border-white/10 shadow-sm transition-all hover:scale-[1.02]`}>
    <div className={`w-10 h-10 bg-white/50 dark:bg-white/5 rounded-xl flex items-center justify-center mb-3 md:mb-4 shadow-sm ${color} shrink-0`}>
      {React.cloneElement(icon, { size: 20 })}
    </div>
    <p className="text-[8px] font-black uppercase text-slate-500 tracking-widest mb-1 leading-none">{label}</p>
    <p className={`text-xl md:text-2xl font-black tracking-tighter ${color} leading-none`}>৳{value.toLocaleString()}</p>
  </div>
);

export default FinanceHub;
