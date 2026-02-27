
import React, { useState } from 'react';
import { useAppStore } from '../store';
import { Calculator, TrendingUp, TrendingDown, Download, Phone, Mail } from 'lucide-react';

const MonthlyAccounting: React.FC = () => {
  const { projects, expenses, currentUser } = useAppStore();
  const now = new Date();
  const [selectedYear, setSelectedYear] = useState(now.getFullYear());
  const [selectedMonth, setSelectedMonth] = useState<number | 'all'>(now.getMonth() + 1);

  if (currentUser?.role !== 'Admin') return null;

  const years = Array.from(new Set([
    ...projects.filter(p => p.createDate).map(p => new Date(p.createDate).getFullYear()),
    ...expenses.filter(e => e.date).map(e => new Date(e.date).getFullYear())
  ])).sort((a, b) => b - a);

  const monthIncome = projects.filter(p => {
    if (!p.createDate) return false;
    if (selectedMonth === 'all') return true;
    const d = new Date(p.createDate);
    return d.getFullYear() === selectedYear && (d.getMonth() + 1) === selectedMonth;
  });

  const monthExpenses = expenses.filter(e => {
    if (!e.date) return false;
    if (selectedMonth === 'all') return true;
    const d = new Date(e.date);
    return d.getFullYear() === selectedYear && (d.getMonth() + 1) === selectedMonth;
  });

  const totalIncome = monthIncome.reduce((acc, p) => acc + (p.paidAmount || 0), 0);
  const totalExpense = monthExpenses.reduce((acc, e) => acc + e.amount, 0);
  const netProfit = totalIncome - totalExpense;

  const safeDate = selectedMonth === 'all'
    ? null
    : new Date(`${selectedYear}-${String(selectedMonth).padStart(2, '0')}-01`);
  const [monthName, yearName] = safeDate
    ? safeDate.toLocaleDateString('en-US', { month: 'long', year: 'numeric' }).split(' ')
    : ['ALL', 'TIME'];

  return (
    <div className="space-y-12 pb-20">
      {/* Metrics & Control Panel - Hidden during print */}
      <div className="no-print space-y-12">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-8">
          <div>
            <h2 className="text-4xl font-black text-slate-900 dark:text-white tracking-tighter">Fiscal Audit Ledger</h2>
            <p className="text-[11px] font-black uppercase text-slate-400 tracking-widest mt-2">Monthly Operational Summary</p>
          </div>
          <div className="flex items-center gap-6">
            <select value={selectedYear} onChange={(e) => setSelectedYear(parseInt(e.target.value, 10))} className="bg-white dark:bg-slate-900 border-2 border-slate-200 dark:border-slate-800 rounded-3xl py-5 px-8 font-black shadow-sm outline-none focus:border-indigo-500 transition-all text-xs">
              {years.map(y => (
                <option key={y} value={y}>{y}</option>
              ))}
            </select>
            <select
              value={selectedMonth}
              onChange={(e) => {
                const v = e.target.value;
                setSelectedMonth(v === 'all' ? 'all' : parseInt(v, 10));
              }}
              className="bg-white dark:bg-slate-900 border-2 border-slate-200 dark:border-slate-800 rounded-3xl py-5 px-8 font-black shadow-sm outline-none focus:border-indigo-500 transition-all text-xs"
            >
              <option value="all">All</option>
              {Array.from({ length: 12 }, (_, i) => i + 1).map(m => (
                <option key={m} value={m}>{new Date(`${selectedYear}-${String(m).padStart(2, '0')}-01`).toLocaleDateString('en-US', { month: 'long' })}</option>
              ))}
            </select>
            <button onClick={() => window.print()} className="bg-indigo-600 text-white px-10 py-5 rounded-[2rem] font-black text-[11px] uppercase tracking-widest shadow-2xl flex items-center gap-3 active:scale-95 transition-all">
              <Download size={20} /> Export Audit
            </button>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <MetricBox label="Settled Revenue" value={totalIncome} icon={<TrendingUp />} color="text-emerald-600" bg="bg-emerald-50 dark:bg-emerald-950/20" />
          <MetricBox label="Operational Costs" value={totalExpense} icon={<TrendingDown />} color="text-rose-600" bg="bg-rose-50 dark:bg-rose-950/20" />
          <MetricBox label="Net Profitability" value={netProfit} icon={<Calculator />} color={netProfit >= 0 ? "text-indigo-600" : "text-rose-600"} bg="bg-indigo-50 dark:bg-indigo-950/20" />
        </div>
      </div>

      {/* Official Financial Audit Ledger */}
      <div className="print-container bg-white dark:bg-slate-900 p-16 md:p-24 rounded-[4rem] border border-slate-200 dark:border-slate-800 shadow-2xl print:shadow-none print:border-none print:p-0 print:bg-white print:text-black">
        <div className="flex justify-between items-start mb-16 pb-10 border-b-2 border-slate-100 dark:border-slate-800 print:border-slate-200">
          <div>
            <h1 className="text-5xl font-black text-indigo-600 tracking-tighter mb-1">MH Creation X</h1>
            <p className="text-[10px] font-black uppercase text-slate-400 tracking-[0.5em] mb-6">Internal Financial Audit</p>
            <div className="space-y-1.5 text-[10px] font-black uppercase text-slate-500 tracking-widest">
              <div className="flex items-center gap-2"><Phone size={12} className="text-indigo-600" /> +880 1768 443633</div>
              <div className="flex items-center gap-2"><Mail size={12} className="text-indigo-600" /> mhcreationx@gmail.com</div>
            </div>
          </div>
          <div className="text-right">
            <h3 className="text-3xl font-black text-slate-900 dark:text-white print:text-black uppercase tracking-tight">{monthName} {yearName}</h3>
            <p className="text-[9px] font-black uppercase text-slate-400 tracking-[0.3em] mt-2">Fiscal Statement Report</p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-16 print:gap-10">
          <div className="space-y-8">
            <h4 className="flex items-center gap-3 text-[11px] font-black uppercase tracking-[0.3em] text-emerald-600 border-b border-emerald-100 pb-4">
              <TrendingUp size={20} /> Received Revenue
            </h4>
            <div className="space-y-3">
              {monthIncome.map(p => (
                <div key={p.id} className="flex justify-between items-center p-5 bg-slate-50 dark:bg-slate-800/40 print:bg-white rounded-[1.5rem] border border-slate-100 dark:border-slate-800 print:border-slate-100">
                  <div className="truncate pr-4">
                    <p className="font-black text-sm">{p.title}</p>
                    <p className="text-[9px] font-black uppercase text-slate-400 tracking-widest">{p.id}</p>
                  </div>
                  <span className="font-black text-emerald-600 text-lg">৳{(p.paidAmount || 0).toLocaleString()}</span>
                </div>
              ))}
              {monthIncome.length === 0 && <p className="text-center py-8 text-slate-400 text-[10px] font-black uppercase tracking-widest">No income records</p>}
            </div>
          </div>

          <div className="space-y-8">
            <h4 className="flex items-center gap-3 text-[11px] font-black uppercase tracking-[0.3em] text-rose-600 border-b border-rose-100 pb-4">
              <TrendingDown size={20} /> Operational Outflow
            </h4>
            <div className="space-y-3">
              {monthExpenses.map(e => (
                <div key={e.id} className="flex justify-between items-center p-5 bg-slate-50 dark:bg-slate-800/40 print:bg-white rounded-[1.5rem] border border-slate-100 dark:border-slate-800 print:border-slate-100">
                  <div className="truncate pr-4">
                    <p className="font-black text-sm">{e.reason}</p>
                    <p className="text-[9px] font-black uppercase text-slate-400 tracking-widest">{new Date(e.date).toLocaleDateString()}</p>
                  </div>
                  <span className="font-black text-rose-600 text-lg">৳{e.amount.toLocaleString()}</span>
                </div>
              ))}
              {monthExpenses.length === 0 && <p className="text-center py-8 text-slate-400 text-[10px] font-black uppercase tracking-widest">No expense records</p>}
            </div>
          </div>
        </div>

        <div className="mt-20 p-12 bg-indigo-600 rounded-[3rem] text-white shadow-2xl print:bg-white print:text-black print:border-2 print:border-indigo-600 print:shadow-none">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-12 text-center">
            <div>
              <p className="text-[10px] font-black uppercase text-indigo-200 print:text-slate-400 tracking-[0.4em] mb-3">Gross Revenue</p>
              <p className="text-4xl font-black">৳{totalIncome.toLocaleString()}</p>
            </div>
            <div>
              <p className="text-[10px] font-black uppercase text-indigo-200 print:text-slate-400 tracking-[0.4em] mb-3">Gross Outflow</p>
              <p className="text-4xl font-black">৳{totalExpense.toLocaleString()}</p>
            </div>
            <div className="bg-white/10 print:bg-indigo-600/5 p-6 rounded-[2rem] border border-white/20 print:border-indigo-200">
              <p className="text-[10px] font-black uppercase text-white print:text-indigo-600 tracking-[0.4em] mb-3">Fiscal Balance</p>
              <p className="text-4xl font-black text-white print:text-indigo-600">৳{netProfit.toLocaleString()}</p>
            </div>
          </div>
        </div>
        <div className="mt-20 flex justify-between items-end print:block print:mt-32">
          <div className="text-center print:inline-block print:w-64">
            <div className="w-64 border-b-2 border-slate-900 dark:border-white print:border-black mb-2 mx-auto"></div>
            <p className="text-[9px] font-black uppercase tracking-widest text-slate-400">Chief Auditor</p>
          </div>
          <p className="text-[8px] font-black text-slate-300 dark:text-slate-700 print:text-slate-400 uppercase tracking-widest italic">Electronic Audit Pass • Engineered by Moazzem Hossen</p>
        </div>
      </div>
    </div>
  );
};

const MetricBox = ({ label, value, icon, color, bg }: any) => (
  <div className={`p-10 rounded-[3.5rem] border border-slate-100 dark:border-slate-800 transition-all hover:shadow-2xl ${bg}`}>
    <div className={`w-14 h-14 rounded-2xl bg-white dark:bg-slate-900 flex items-center justify-center mb-8 shadow-sm ${color}`}>
      {React.cloneElement(icon, { size: 28 })}
    </div>
    <p className="text-[11px] font-black uppercase text-slate-500 tracking-widest mb-2">{label}</p>
    <p className={`text-4xl font-black tracking-tight ${color}`}>৳{value.toLocaleString()}</p>
  </div>
);

export default MonthlyAccounting;
