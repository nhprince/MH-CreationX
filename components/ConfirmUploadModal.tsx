
import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Check, X, ImageIcon } from 'lucide-react';

interface ConfirmUploadModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  imagePreview: string;
  type: string;
}

const ConfirmUploadModal: React.FC<ConfirmUploadModalProps> = ({ isOpen, onClose, onConfirm, imagePreview, type }) => {
  return (
    <AnimatePresence>
      {isOpen && (
        <div className="fixed inset-0 z-modal flex items-center justify-center p-6">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={onClose}
            className="absolute inset-0 bg-slate-950/80 backdrop-blur-sm"
          />
          <motion.div
            initial={{ scale: 0.9, opacity: 0, y: 20 }}
            animate={{ scale: 1, opacity: 1, y: 0 }}
            exit={{ scale: 0.9, opacity: 0, y: 20 }}
            className="relative w-full max-w-md bg-white dark:bg-slate-900 rounded-[3.5rem] shadow-2xl border border-slate-200 dark:border-slate-800 overflow-hidden p-10"
          >
            <div className="text-center space-y-2 mb-8">
              <h3 className="text-2xl font-black tracking-tight text-slate-900 dark:text-white">Confirm Provision</h3>
              <p className="text-[10px] font-black text-indigo-600 uppercase tracking-[0.2em]">Asset Class: {type}</p>
            </div>

            <div className="aspect-square rounded-[2.5rem] overflow-hidden border-4 border-slate-50 dark:border-slate-800 bg-slate-100 dark:bg-slate-950 mb-10 shadow-inner group relative">
              <img src={imagePreview} alt="Preview" className="w-full h-full object-cover" />
              <div className="absolute inset-0 bg-indigo-600/10 opacity-0 group-hover:opacity-100 transition-opacity" />
            </div>

            <div className="flex gap-4">
              <button
                onClick={onClose}
                className="flex-1 py-5 rounded-2xl font-black text-[10px] uppercase tracking-widest text-slate-500 hover:bg-slate-100 dark:hover:bg-slate-800 transition-all border border-slate-200 dark:border-slate-800"
              >
                Discard
              </button>
              <button
                onClick={onConfirm}
                className="flex-1 bg-indigo-600 text-white py-5 rounded-2xl font-black text-[10px] uppercase tracking-widest shadow-xl shadow-indigo-600/20 hover:bg-indigo-500 active:scale-95 transition-all flex items-center justify-center gap-2"
              >
                <Check size={18} /> Confirm Asset
              </button>
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
};

export default ConfirmUploadModal;
