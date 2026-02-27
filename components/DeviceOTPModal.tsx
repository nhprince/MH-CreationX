import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useAppStore } from '../store';
import { X, ShieldCheck, CheckCircle } from 'lucide-react';

const DeviceOTPModal = () => {
    const { otpRequired, verifyDeviceOTP, setShowLoginModal } = useAppStore();
    const [otp, setOtp] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    if (!otpRequired) return null;

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setLoading(true);
        setError(null);

        // We need email to verify. 
        // Assuming email is stored in temp state or we ask user again?
        // The previous login action stored credentials temporarily? 
        // Or we should ask user to re-enter email?
        // For better UX, we could store email in store.ts when login requires OTP.
        // But for now, let's ask user to confirm email or just input OTP if we can persist email.
        // Actually store.ts login() implementation didn't store the email.
        // Let's assume we prompt for it or update store to hold temp email.
        // Let's prompt for email to be safe and simple.

        // Wait, verifyDeviceOTP in store.ts takes (email, otp).
        // Let's add email field to this modal.
    };

    // Correct implementation with email input
    const handleVerify = async (e: React.FormEvent) => {
        e.preventDefault();

        const emailInput = (document.getElementById('otp-email') as HTMLInputElement)?.value;

        if (!emailInput || !otp) {
            setError("Please enter your email and the code sent to it.");
            return;
        }

        setLoading(true);
        try {
            const success = await verifyDeviceOTP(emailInput, otp);
            if (!success) {
                setError("Verification failed. Please try again.");
            }
        } catch (err) {
            // Error is handled in store
        } finally {
            setLoading(false);
        }
    };

    return (
        <AnimatePresence>
            <div className="fixed inset-0 z-modal flex items-center justify-center p-4 md:p-6 bg-slate-900/80 backdrop-blur-sm">
                <motion.div
                    initial={{ opacity: 0, scale: 0.95 }}
                    animate={{ opacity: 1, scale: 1 }}
                    exit={{ opacity: 0, scale: 0.95 }}
                    className="relative w-full max-w-md bg-white dark:bg-slate-900 rounded-3xl shadow-2xl overflow-hidden border border-slate-200 dark:border-slate-800"
                >
                    <button
                        onClick={() => useAppStore.setState({ otpRequired: false })}
                        className="absolute top-4 right-4 p-2 rounded-full hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors"
                    >
                        <X size={20} className="text-slate-400" />
                    </button>

                    <div className="p-8">
                        <div className="text-center mb-6">
                            <div className="w-16 h-16 bg-indigo-50 dark:bg-indigo-900/20 rounded-2xl flex items-center justify-center mx-auto mb-4 text-indigo-600">
                                <ShieldCheck size={32} />
                            </div>
                            <h2 className="text-2xl font-black text-slate-900 dark:text-white mb-2">Device Verification</h2>
                            <p className="text-sm text-slate-500 font-medium">New device detected. Please enter the code sent to your email.</p>
                        </div>

                        {error && (
                            <div className="mb-6 p-4 bg-rose-50 dark:bg-rose-900/20 border border-rose-100 dark:border-rose-900/30 rounded-xl text-rose-600 text-xs font-bold text-center">
                                {error}
                            </div>
                        )}

                        <form onSubmit={handleVerify} className="space-y-4">
                            <div>
                                <label className="block text-xs font-black uppercase text-slate-400 mb-2">Email</label>
                                <input
                                    id="otp-email"
                                    type="email"
                                    required
                                    className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl py-3 px-4 font-medium focus:ring-2 focus:ring-indigo-500 outline-none transition-all"
                                    placeholder="Confirm your email"
                                />
                            </div>
                            <div>
                                <label className="block text-xs font-black uppercase text-slate-400 mb-2">Verification Code</label>
                                <input
                                    type="text"
                                    required
                                    value={otp}
                                    onChange={(e) => setOtp(e.target.value)}
                                    className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl py-3 px-4 font-bold tracking-widest text-lg text-center focus:ring-2 focus:ring-indigo-500 outline-none transition-all"
                                    placeholder="******"
                                    maxLength={6}
                                />
                            </div>

                            <button
                                type="submit"
                                disabled={loading}
                                className="w-full bg-indigo-600 hover:bg-indigo-500 text-white py-4 rounded-xl font-black text-xs uppercase tracking-widest shadow-lg shadow-indigo-500/20 transition-all flex items-center justify-center gap-2"
                            >
                                {loading ? 'Verifying...' : 'Verify Device'} <CheckCircle size={16} />
                            </button>
                        </form>
                    </div>
                </motion.div>
            </div>
        </AnimatePresence>
    );
};

export default DeviceOTPModal;
