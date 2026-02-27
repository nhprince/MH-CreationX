
import React, { useState } from 'react';
import { useAppStore } from '../store';
import { Users, UserPlus, Trash2, Shield, UserCircle, ShieldCheck, Eye, EyeOff } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

const UserManagement: React.FC = () => {
  const { users, addUser, deleteUser, currentUser } = useAppStore();
  const isAdmin = currentUser?.role === 'Admin';
  const isMainAdmin = currentUser?.username === 'moazzem@mahi';

  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [role, setRole] = useState<'Admin' | 'Team'>('Team');
  const [showPassMap, setShowPassMap] = useState<Record<string, boolean>>({});

  const handleAddUser = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!username.trim() || !password.trim() || !email.trim()) return;
    if (await addUser(username.trim(), email.trim(), password.trim(), role)) {
      setUsername(''); setEmail(''); setPassword('');
    } else {
      alert('Identity conflict detected.');
    }
  };

  const togglePass = (id: string) => {
    setShowPassMap(prev => ({ ...prev, [id]: !prev[id] }));
  };

  return (
    <div className="max-w-6xl mx-auto space-y-10 pb-20">
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-3xl font-black tracking-tighter">Control Center</h2>
          <p className="text-slate-500 font-bold uppercase text-[9px] tracking-[0.2em] mt-1">Identity Provisioning</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-10">
        {isAdmin ? (
          <div className="glass p-8 rounded-[2.5rem] h-fit border border-slate-200 dark:border-slate-800 shadow-xl">
            <h3 className="text-base font-black mb-6 flex items-center gap-2">
              <UserPlus size={20} className="text-indigo-600" /> Provision Account
            </h3>
            <form onSubmit={handleAddUser} className="space-y-5">
              <div>
                <label className="text-[8px] font-black uppercase text-slate-400 ml-1">Account Name</label>
                <input value={username} onChange={e => setUsername(e.target.value)} className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-100 dark:border-slate-800 rounded-xl px-5 py-3.5 font-bold outline-none focus:border-indigo-500 transition-all mt-1" placeholder="Full Name" />
              </div>
              <div>
                <label className="text-[8px] font-black uppercase text-slate-400 ml-1">Email Address</label>
                <input type="email" value={email} onChange={e => setEmail(e.target.value)} className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-100 dark:border-slate-800 rounded-xl px-5 py-3.5 font-bold outline-none focus:border-indigo-500 transition-all mt-1" placeholder="user@example.com" />
              </div>
              <div>
                <label className="text-[8px] font-black uppercase text-slate-400 ml-1">Access Key</label>
                <input type="password" value={password} onChange={e => setPassword(e.target.value)} className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-100 dark:border-slate-800 rounded-xl px-5 py-3.5 font-bold outline-none focus:border-indigo-500 transition-all mt-1" placeholder="Password" />
              </div>
              <div>
                <label className="text-[8px] font-black uppercase text-slate-400 ml-1">Access Class</label>
                <select value={role} onChange={e => setRole(e.target.value as any)} className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-100 dark:border-slate-800 rounded-xl px-5 py-3.5 font-bold outline-none focus:border-indigo-500 transition-all mt-1">
                  <option value="Admin">Administrator</option>
                  <option value="Team">Team Member</option>
                </select>
              </div>
              <button type="submit" className="w-full bg-indigo-600 text-white py-4 rounded-xl font-black uppercase tracking-widest text-[9px] shadow-lg active:scale-95 transition-all">Authorize Identity</button>
            </form>
          </div>
        ) : (
          <div className="glass p-8 rounded-[2.5rem] h-fit border border-slate-200 dark:border-slate-800 shadow-xl flex items-center justify-center">
            <div className="text-center">
              <div className="w-14 h-14 mx-auto rounded-2xl bg-slate-100 dark:bg-slate-800 flex items-center justify-center text-slate-400 mb-4">
                <Shield size={22} />
              </div>
              <p className="font-black text-sm">Admin tools restricted</p>
              <p className="text-slate-500 font-bold text-xs mt-1">You can view the team list, but only Admin can create or remove accounts.</p>
            </div>
          </div>
        )}

        <div className="lg:col-span-2 space-y-4">
          {/* Static Main Admin Preview */}
          <div className="glass p-6 rounded-[2rem] flex items-center justify-between border-2 border-indigo-500/20 bg-indigo-500/5">
            <div className="flex items-center gap-4">
              <div className="w-10 h-10 bg-indigo-600 text-white rounded-xl flex items-center justify-center shadow-lg"><ShieldCheck size={20} /></div>
              <div>
                <h4 className="font-black text-sm">moazzem@mahi</h4>
                <p className="text-[8px] font-black uppercase text-indigo-600 tracking-widest">Main Admin • Master Account</p>
              </div>
            </div>
          </div>

          {/* Dynamic User List with Password Preview for Main Admin */}
          {users.map(u => (
            <motion.div layout key={u.id} className="glass p-6 rounded-[2rem] flex items-center justify-between border border-slate-200 dark:border-slate-800 hover:shadow-lg transition-all">
              <div className="flex items-center gap-4">
                <div className="w-10 h-10 bg-slate-100 dark:bg-slate-800 rounded-xl flex items-center justify-center text-slate-400"><UserCircle size={20} /></div>
                <div>
                  <h4 className="font-black text-sm">{u.username}</h4>
                  <div className="flex items-center gap-3 mt-0.5">
                    <span className="text-[8px] font-black uppercase text-indigo-600 tracking-widest">{u.role}</span>
                    {isMainAdmin && (
                      <span className="flex items-center gap-1.5 text-[8px] font-black text-slate-400 uppercase tracking-widest">
                        Pass: {showPassMap[u.id] ? u.pass : '••••••••'}
                        <button onClick={() => togglePass(u.id)} className="hover:text-indigo-600 transition-colors">
                          {showPassMap[u.id] ? <EyeOff size={10} /> : <Eye size={10} />}
                        </button>
                      </span>
                    )}
                  </div>
                </div>
              </div>
              {isAdmin && (
                <button onClick={() => deleteUser(u.id)} className="p-2.5 bg-rose-50 text-rose-600 rounded-xl hover:bg-rose-600 hover:text-white transition-all">
                  <Trash2 size={16} />
                </button>
              )}
            </motion.div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default UserManagement;
