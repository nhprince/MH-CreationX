
import React, { useEffect } from 'react';
import { useParams, Navigate, Link } from 'react-router-dom';
import { useAppStore } from '../store';
import { Printer, ChevronLeft, Hash, UserCheck, Phone, Mail } from 'lucide-react';
import { PaymentStatus } from '../types';

const CashMemo: React.FC = () => {
  const { projectId } = useParams();
  const { projects } = useAppStore();
  const project = projects.find(p => p.id === projectId);

  useEffect(() => {
    if (project) {
      const timer = setTimeout(() => {
        window.print();
      }, 1000);
      return () => clearTimeout(timer);
    }
  }, [project]);

  if (!project) return <Navigate to="/" />;

  const isPaid = project.paymentStatus === PaymentStatus.PAID;
  const totalPaid = project.paidAmount || project.advanceAmount || 0;
  const balanceDue = Math.max(0, project.price - totalPaid);

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 p-4 md:p-10">
      <div className="max-w-4xl mx-auto mb-8 flex justify-between items-center no-print">
        <Link to="/" className="flex items-center gap-2 text-slate-600 bg-white dark:bg-slate-900 px-6 py-3 rounded-2xl border border-slate-200 shadow-sm font-black text-xs uppercase tracking-widest">
          <ChevronLeft size={20} /> Back to Dashboard
        </Link>
        <button
          onClick={() => window.print()}
          className="bg-indigo-600 hover:bg-indigo-500 text-white px-10 py-4 rounded-2xl font-black flex items-center gap-3 shadow-xl text-xs uppercase tracking-widest"
        >
          <Printer size={20} /> Print Again
        </button>
      </div>

      <div className="cash-memo-container bg-white text-black mx-auto border-[0.5mm] border-slate-200 relative print:border-none print:p-0">
        <div className="p-10 space-y-10">
          <div className="flex justify-between items-start border-b-4 border-indigo-600 pb-10">
            <div>
              <h1 className="text-5xl font-black tracking-tighter text-indigo-600 mb-1 leading-none">MH Creation X</h1>
              <p className="text-[10px] font-black text-slate-400 uppercase tracking-[0.4em]">Professional Design Services</p>
              <div className="mt-8 space-y-1.5 text-[10px] font-black uppercase text-slate-500 tracking-widest">
                <div className="flex items-center gap-2"><Phone size={12} className="text-indigo-600" /> +880 1768 443633</div>
                <div className="flex items-center gap-2"><Mail size={12} className="text-indigo-600" /> mhcreationx@gmail.com</div>
                <div className="flex items-center gap-2"><UserCheck size={12} className="text-indigo-600" /> System Verified Document</div>
              </div>
            </div>
            <div className="text-right">
              <h2 className="text-2xl font-black uppercase tracking-[0.2em] text-slate-300 mb-4 leading-none">Invoice</h2>
              <p className="text-xl font-black leading-none">Ref: <span className="text-indigo-600">#{project.id}</span></p>
              <p className="text-[9px] font-black text-slate-400 uppercase tracking-widest mt-2">Date: {new Date(project.createDate).toLocaleDateString()}</p>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-16 py-8 border-b border-slate-100">
            <div className="space-y-2">
              <p className="text-[9px] font-black uppercase text-slate-400 tracking-widest">Client Identity</p>
              <h3 className="text-2xl font-black leading-tight">{project.clientName}</h3>
              <p className="text-[9px] font-bold text-slate-500 uppercase tracking-widest">ID: {project.customerId} • {project.clientType}</p>
            </div>
            <div className="text-right space-y-2">
              <p className="text-[9px] font-black uppercase text-slate-400 tracking-widest">Particulars</p>
              <h3 className="text-2xl font-black uppercase leading-tight">{project.category}</h3>
              <p className="text-[9px] font-bold text-slate-500 uppercase tracking-widest">Subject: {project.title}</p>
            </div>
          </div>

          <div className="py-8 space-y-6">
            <div className="flex justify-between items-center text-[10px] font-black border-b pb-4 border-slate-100 text-slate-400 uppercase tracking-[0.2em]">
              <span>Description</span>
              <span>Valuation</span>
            </div>
            <div className="flex justify-between items-start py-4">
              <div className="space-y-1">
                <p className="font-black text-xl leading-tight">{project.title}</p>
                <p className="text-[10px] text-slate-500 uppercase font-black tracking-widest">{project.category} Design Service Package</p>
              </div>
              <p className="font-black text-2xl">৳{project.price.toLocaleString()}</p>
            </div>
          </div>

          <div className="pt-8 border-t-2 border-slate-100 flex justify-end">
            <div className="w-full md:w-80 space-y-4">
              <div className="flex justify-between text-[10px] font-black uppercase tracking-widest text-slate-500">
                <span>Subtotal</span>
                <span className="text-slate-900">৳{project.price.toLocaleString()}</span>
              </div>
              <div className="flex justify-between text-[10px] font-black uppercase tracking-widest text-emerald-600">
                <span>Amount Received</span>
                <span>৳{totalPaid.toLocaleString()}</span>
              </div>
              <div className={`flex justify-between p-6 rounded-[2rem] border-2 ${isPaid ? 'bg-emerald-50 border-emerald-100 text-emerald-600' : 'bg-indigo-600 border-indigo-500 text-white shadow-xl print:bg-white print:text-black print:border-indigo-600'}`}>
                <span className="text-[10px] font-black uppercase tracking-widest">{isPaid ? 'Settled' : 'Balance Due'}</span>
                <span className="text-3xl font-black leading-none">৳{balanceDue.toLocaleString()}</span>
              </div>
            </div>
          </div>

          <div className="pt-24 flex justify-between items-end">
            <div className="text-center">
              <div className="w-48 border-b-2 border-slate-900 mb-2"></div>
              <p className="text-[9px] font-black uppercase tracking-widest text-slate-400">Authorized Signature</p>
            </div>
            <p className="text-[8px] font-black text-slate-300 uppercase tracking-widest italic">Electronic Audit Pass • Unique Ref: {project.id}</p>
          </div>
          <div className="text-center pt-6 border-t border-slate-50">
            <p className="text-[8px] font-black uppercase tracking-[0.3em] text-slate-300">Engineered by Moazzem Hossen • MH Creation X</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CashMemo;
