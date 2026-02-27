
import React from 'react';
import { useParams, Navigate, Link } from 'react-router-dom';
import { useAppStore } from '../store';
import { PaymentStatus, ProjectStatus } from '../types';
import { Printer, CheckCircle2, AlertCircle, Mail, Phone, Hash } from 'lucide-react';

const ClientPortal: React.FC = () => {
  const { projectId, secureToken } = useParams();
  const { projects, customers, currentCustomer, currentUser } = useAppStore();

  const project = projects.find(p => p.id === projectId && (p.secureToken === secureToken || currentUser?.role === 'Admin'));
  const customer = customers.find(c => c.id === project?.customerId);

  if (!project) return <Navigate to="/" />;
  if (currentCustomer && project.customerId !== currentCustomer.id) return <Navigate to="/" />;

  const isPaid = project.paymentStatus === PaymentStatus.PAID;
  const totalPaid = project.paidAmount || project.advanceAmount || 0;
  const dueAmount = Math.max(0, project.price - totalPaid);

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 p-6 md:p-12">
      <div className="max-w-5xl mx-auto mb-10 flex justify-between items-center no-print">
        <Link to="/" className="bg-white dark:bg-slate-900 px-8 py-4 rounded-2xl shadow-sm border border-slate-200 font-black text-[11px] uppercase tracking-widest text-slate-500 hover:text-indigo-600 transition-all">← Workspace</Link>
        <button onClick={() => window.print()} className="bg-indigo-600 text-white px-10 py-5 rounded-[2rem] font-black text-xs uppercase tracking-widest shadow-2xl flex items-center gap-3 active:scale-95 transition-all">
          <Printer size={20} /> Generate Official Memo
        </button>
      </div>

      <div className="print-container bg-white text-black rounded-[4rem] shadow-2xl overflow-hidden">
        <div className="p-16 md:p-24 space-y-16">
          {/* OFFICIAL HEADER */}
          <div className="flex flex-col md:flex-row justify-between items-start md:items-center border-b-8 border-indigo-600 pb-16 gap-12">
            <div>
              <h1 className="text-6xl font-black tracking-tighter text-indigo-600 mb-2">MH Creation X Studio</h1>
              <p className="text-[11px] font-black text-slate-400 uppercase tracking-[0.4em] mb-12">Live Project – Professional Record</p>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-x-12 gap-y-3 text-[11px] font-black uppercase text-slate-500 tracking-widest">
                <div className="flex items-center gap-3"><Phone size={16} className="text-indigo-600" /> +880 1768 443633</div>
                <div className="flex items-center gap-3"><Mail size={16} className="text-indigo-600" /> mhcreationx@gmail.com</div>
                <div className="flex items-center gap-3"><Hash size={16} className="text-indigo-600" /> Valid Document Registry</div>
              </div>
            </div>
            <div className="text-right shrink-0">
              <h2 className="text-4xl font-black text-slate-100 uppercase tracking-[0.3em] mb-6">Voucher</h2>
              <div className="space-y-1">
                <p className="text-2xl font-black">Ref: <span className="text-indigo-600">#{project.id}</span></p>
                <p className="text-[11px] font-black text-slate-400 uppercase tracking-widest">Dated: {new Date(project.createDate).toLocaleDateString()}</p>
              </div>
            </div>
          </div>

          {/* PROJECT & CLIENT INFO */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-20 py-8">
            <div className="space-y-6">
              <h4 className="text-[11px] font-black uppercase tracking-widest text-indigo-600 border-b pb-4">Client Registry</h4>
              <h3 className="text-5xl font-black tracking-tight">{project.clientName}</h3>
              <p className="text-[11px] font-black text-slate-400 uppercase tracking-widest">Customer ID: {project.customerId} • {project.clientType}</p>
              <div className="pt-8">
                <p className="text-[11px] font-black uppercase text-slate-400 mb-2">Subject</p>
                <p className="text-2xl font-black">{project.title}</p>
              </div>
            </div>
            <div className="md:text-right space-y-6">
              <h4 className="text-[11px] font-black uppercase tracking-widest text-indigo-600 border-b pb-4 md:border-b-0 md:border-b-indigo-600">Service Particulars</h4>
              <div className="space-y-4">
                <p className="text-3xl font-black uppercase">{project.category}</p>
                <div className="flex flex-col md:items-end gap-3 mt-4">
                  <span className={`px-6 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest text-white ${project.status === ProjectStatus.DELIVERED ? 'bg-emerald-600' : 'bg-amber-500'
                    }`}>Status: {project.status}</span>
                </div>
              </div>
            </div>
          </div>

          {/* FINANCIALS */}
          <div className="pt-20 border-t border-slate-100">
            <div className="flex flex-col md:flex-row justify-between items-end gap-16">
              <div className="flex-1 space-y-4">
                <div className={`p-10 rounded-[3.5rem] border-4 ${isPaid ? 'bg-emerald-50 border-emerald-100 text-emerald-600' : 'bg-rose-50 border-rose-100 text-rose-600'}`}>
                  <p className="text-[10px] font-black uppercase tracking-widest mb-2 flex items-center gap-2">
                    {isPaid ? <CheckCircle2 size={16} /> : <AlertCircle size={16} />}
                    Record Status
                  </p>
                  <h4 className="text-4xl font-black uppercase tracking-tight">{project.paymentStatus}</h4>
                  {isPaid && project.paymentMethod && (
                    <p className="mt-4 text-[11px] font-black uppercase tracking-widest">Method: {project.paymentMethod} {project.paymentDetails?.walletNumber || project.paymentDetails?.accountNumber}</p>
                  )}
                </div>
              </div>
              <div className="w-full md:w-[450px] space-y-8">
                <div className="flex justify-between items-center text-[11px] font-black uppercase tracking-widest text-slate-400">
                  <span>Gross Project Valuation</span>
                  <span className="text-slate-900 text-xl">৳{project.price.toLocaleString()}</span>
                </div>
                <div className="flex justify-between items-center text-[11px] font-black uppercase tracking-widest text-slate-400">
                  <span>Amount Received</span>
                  <span className="text-emerald-600 text-xl">৳{totalPaid.toLocaleString()}</span>
                </div>
                <div className={`flex justify-between items-center p-10 rounded-[3rem] border-4 ${isPaid ? 'bg-emerald-50 border-emerald-200 text-emerald-600' : 'bg-indigo-600 text-white border-indigo-500 shadow-2xl'}`}>
                  <span className="text-[11px] font-black uppercase tracking-widest">{isPaid ? 'Settled' : 'Balance Due'}</span>
                  <span className="text-4xl font-black">৳{dueAmount.toLocaleString()}</span>
                </div>
              </div>
            </div>
          </div>

          <div className="pt-24 flex justify-between items-end">
            <div className="text-center">
              <div className="w-64 border-b-4 border-slate-900 mb-4"></div>
              <p className="text-[10px] font-black uppercase text-slate-400 tracking-widest">Authorized Signature</p>
            </div>
            <p className="text-[9px] font-black text-slate-200 uppercase tracking-widest italic">Electronic Audit Pass • Ref: {project.id}</p>
          </div>
          <div className="text-center pt-10 border-t border-slate-50">
            <p className="text-[9px] font-black uppercase tracking-[0.3em] text-slate-300">Engineered by Moazzem Hossen • MH Creation X</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ClientPortal;
