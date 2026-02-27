import React, { useState } from 'react';
import { useAppStore } from '../store';
import { Trash2, Plus, Receipt, Loader2 } from 'lucide-react';

const Expenses: React.FC = () => {
  const { expenses, addExpense, deleteExpense } = useAppStore();
  const [reason, setReason] = useState('');
  const [amount, setAmount] = useState('');
  const [category, setCategory] = useState('Operational');
  const [date, setDate] = useState(new Date().toISOString().split('T')[0]);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!reason || !amount) return;

    try {
      setLoading(true);
      await addExpense({
        reason,
        amount: Number(amount),
        category,
        date
      });
      setReason('');
      setAmount('');
      setCategory('Operational');
    } catch (error) {
      console.error(error);
      alert('Failed to record expense');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-4xl mx-auto space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-3xl font-bold">Expenses & Costs</h2>
          <p className="text-gray-400">Track all operational expenditures.</p>
        </div>
        <div className="glass px-6 py-3 rounded-2xl">
          <p className="text-xs text-gray-400 uppercase tracking-widest">Total Expenses</p>
          <p className="text-2xl font-bold text-red-400">৳{expenses.reduce((acc, e) => acc + Number(e.amount), 0).toLocaleString()}</p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
        <div className="glass p-6 rounded-2xl h-fit">
          <h3 className="text-lg font-semibold mb-6 flex items-center gap-2">
            <Plus className="text-purple-400" size={20} />
            Record Expense
          </h3>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-xs text-gray-400 mb-1.5 ml-1">Reason / Item</label>
              <input
                value={reason}
                onChange={e => setReason(e.target.value)}
                className="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 focus:outline-none"
                placeholder="e.g. Photoshop Subscription"
                required
              />
            </div>
            <div>
              <label className="block text-xs text-gray-400 mb-1.5 ml-1">Category</label>
              <select
                value={category}
                onChange={e => setCategory(e.target.value)}
                className="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 focus:outline-none appearance-none"
              >
                <option value="Operational">Operational</option>
                <option value="Marketing">Marketing</option>
                <option value="Salary">Salary</option>
                <option value="Utility">Utility</option>
                <option value="Food">Food</option>
                <option value="Other">Other</option>
              </select>
            </div>
            <div>
              <label className="block text-xs text-gray-400 mb-1.5 ml-1">Amount (BDT)</label>
              <input
                type="number"
                value={amount}
                onChange={e => setAmount(e.target.value)}
                className="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 focus:outline-none"
                placeholder="0.00"
                required
              />
            </div>
            <div>
              <label className="block text-xs text-gray-400 mb-1.5 ml-1">Date</label>
              <input
                type="date"
                value={date}
                onChange={e => setDate(e.target.value)}
                className="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2.5 focus:outline-none"
              />
            </div>
            <button disabled={loading} className="w-full bg-purple-600 hover:bg-purple-500 py-3 rounded-xl font-bold shadow-lg shadow-purple-600/20 transition-all flex items-center justify-center gap-2">
              {loading ? <Loader2 className="animate-spin" size={16} /> : null}
              {loading ? 'Saving...' : 'Save Record'}
            </button>
          </form>
        </div>

        <div className="md:col-span-2 glass p-6 rounded-2xl min-h-[400px]">
          <h3 className="text-lg font-semibold mb-6 flex items-center gap-2">
            <Receipt className="text-pink-400" size={20} />
            History
          </h3>
          <div className="space-y-3">
            {expenses.length > 0 ? expenses.slice().reverse().map(e => (
              <div key={e.id} className="flex items-center justify-between p-4 bg-white/5 rounded-xl border border-white/5 hover:border-white/10 transition-all group">
                <div>
                  <h4 className="font-semibold text-gray-100">{e.reason}</h4>
                  <p className="text-xs text-gray-500 flex gap-2">
                    <span>{new Date(e.date).toLocaleDateString()}</span>
                    <span className="text-gray-600">•</span>
                    <span className="text-purple-400">{e.category}</span>
                  </p>
                </div>
                <div className="flex items-center gap-4">
                  <span className="font-bold text-red-400">-৳{Number(e.amount).toLocaleString()}</span>
                  {/* Delete removed as per request */
                  /* <button
                    onClick={() => { if (confirm('Delete expense?')) deleteExpense(e.id); }}
                    className="p-2 text-gray-600 hover:text-red-500 opacity-0 group-hover:opacity-100 transition-all"
                  >
                    <Trash2 size={16} />
                  </button> */}
                </div>
              </div>
            )) : (
              <div className="flex flex-col items-center justify-center py-20 text-gray-500">
                <Receipt size={48} className="mb-4 opacity-10" />
                <p>Your expense history is currently empty.</p>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Expenses;
