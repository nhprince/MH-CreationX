
import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { AlertTriangle, Maximize, X, Image as ImageIcon, CheckCircle2, Ruler } from 'lucide-react';
// Changed REQUIRED_POSTER_WIDTH/HEIGHT to PREFERRED_POSTER_WIDTH/HEIGHT
import { PREFERRED_POSTER_WIDTH, PREFERRED_POSTER_HEIGHT, resizeImageToHQ } from '../utils/imageValidator';

interface PosterResizeModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: (resizedDataUrl: string) => void;
  imagePreview: string;
  currentWidth: number;
  currentHeight: number;
}

const PosterResizeModal: React.FC<PosterResizeModalProps> = ({
  isOpen, onClose, onConfirm, imagePreview, currentWidth, currentHeight
}) => {
  const [isResizing, setIsResizing] = useState(false);
  const [isDone, setIsDone] = useState(false);

  const handleResize = async () => {
    setIsResizing(true);
    try {
      const result = await resizeImageToHQ(imagePreview);
      setIsDone(true);
      // Small delay to show completion state
      setTimeout(() => {
        onConfirm(result);
        setIsDone(false);
      }, 800);
    } catch (error) {
      console.error("Resize failed", error);
      alert("Critical: Image optimization failed. Please check source file.");
    } finally {
      setIsResizing(false);
    }
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <div className="fixed inset-0 z-modal flex items-center justify-center p-6 md:p-12">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={onClose}
            className="absolute inset-0 bg-slate-950/95 backdrop-blur-xl"
          />

          <motion.div
            initial={{ scale: 0.95, opacity: 0, y: 40 }}
            animate={{ scale: 1, opacity: 1, y: 0 }}
            exit={{ scale: 0.95, opacity: 0, y: 40 }}
            className="relative w-full max-w-4xl bg-white dark:bg-slate-900 rounded-[4rem] shadow-[0_32px_128px_-16px_rgba(0,0,0,0.5)] border border-white/10 overflow-hidden"
          >
            <div className="p-10 md:p-16 space-y-12">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-6">
                  <div className="w-16 h-16 bg-amber-500 text-white rounded-[1.8rem] flex items-center justify-center shadow-2xl shadow-amber-500/30">
                    <AlertTriangle size={32} />
                  </div>
                  <div>
                    <h3 className="text-4xl font-black tracking-tighter text-slate-900 dark:text-white">Dimension Mismatch</h3>
                    <p className="text-slate-400 text-[10px] font-black uppercase tracking-[0.3em] mt-2 flex items-center gap-2">
                      <Ruler size={12} className="text-indigo-600" /> MH Creation X Output Standards
                    </p>
                  </div>
                </div>
                <button onClick={onClose} className="p-4 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-2xl transition-all">
                  <X size={28} className="text-slate-400" />
                </button>
              </div>

              <div className="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
                <div className="aspect-[3/4] rounded-[3rem] overflow-hidden border-8 border-slate-50 dark:border-slate-800 bg-slate-100 dark:bg-slate-950 shadow-2xl group relative">
                  <img src={imagePreview} alt="Asset Preview" className="w-full h-full object-contain" />
                  <div className="absolute inset-0 bg-indigo-600/10 mix-blend-overlay" />
                  <div className="absolute bottom-6 left-6 right-6 p-4 glass rounded-2xl border border-white/20 backdrop-blur-xl">
                    <p className="text-[10px] font-black text-center uppercase tracking-widest text-slate-600 dark:text-white">Live Asset Preview</p>
                  </div>
                </div>

                <div className="space-y-10">
                  <div className="grid grid-cols-1 gap-6">
                    <div className="p-8 rounded-[2.5rem] bg-rose-50 dark:bg-rose-950/20 border border-rose-100 dark:border-rose-900/30">
                      <p className="text-[10px] font-black uppercase text-rose-400 tracking-widest mb-4">Detected Size</p>
                      <div className="flex items-baseline gap-3">
                        <p className="text-4xl font-black text-rose-600 tracking-tight">{currentWidth}</p>
                        <span className="text-rose-300 font-bold">×</span>
                        <p className="text-4xl font-black text-rose-600 tracking-tight">{currentHeight}</p>
                        <span className="text-rose-400 text-xs font-black ml-2">PX</span>
                      </div>
                    </div>

                    <div className="p-8 rounded-[2.5rem] bg-emerald-50 dark:bg-emerald-950/20 border border-emerald-100 dark:border-emerald-900/30">
                      <p className="text-[10px] font-black uppercase text-emerald-400 tracking-widest mb-4">Required Size</p>
                      <div className="flex items-baseline gap-3">
                        <p className="text-4xl font-black text-emerald-600 tracking-tight">{PREFERRED_POSTER_WIDTH}</p>
                        <span className="text-emerald-300 font-bold">×</span>
                        <p className="text-4xl font-black text-emerald-600 tracking-tight">{PREFERRED_POSTER_HEIGHT}</p>
                        <span className="text-emerald-400 text-xs font-black ml-2">PX</span>
                      </div>
                    </div>
                  </div>

                  <div className="p-8 bg-indigo-50 dark:bg-indigo-950/30 rounded-[2.5rem] border border-indigo-100 dark:border-indigo-900/30">
                    <div className="flex gap-4">
                      <ImageIcon className="text-indigo-600 shrink-0" size={24} />
                      <p className="text-xs font-bold text-indigo-900 dark:text-indigo-200 leading-relaxed italic">
                        "Enforcing high-definition standards. Resizing will intelligently map your canvas to the 3546x4433 HQ master format."
                      </p>
                    </div>
                  </div>
                </div>
              </div>

              <div className="flex gap-6 pt-6">
                <button
                  onClick={onClose}
                  className="px-12 py-8 rounded-[2.5rem] font-black text-[11px] uppercase tracking-widest text-slate-500 hover:bg-slate-100 dark:hover:bg-slate-800 transition-all border border-slate-200 dark:border-slate-800"
                >
                  Discard Asset
                </button>
                <button
                  onClick={handleResize}
                  disabled={isResizing || isDone}
                  className="flex-1 bg-indigo-600 text-white py-8 rounded-[2.5rem] font-black text-[12px] uppercase tracking-[0.2em] shadow-[0_24px_48px_-12px_rgba(79,70,229,0.4)] hover:bg-indigo-500 active:scale-95 transition-all flex items-center justify-center gap-4 disabled:opacity-50"
                >
                  {isResizing ? (
                    <div className="flex items-center gap-4">
                      <div className="w-5 h-5 border-3 border-white/30 border-t-white rounded-full animate-spin" />
                      HQ Engine Running...
                    </div>
                  ) : isDone ? (
                    <div className="flex items-center gap-4 animate-in zoom-in duration-300">
                      <CheckCircle2 size={24} />
                      Standards Met
                    </div>
                  ) : (
                    <>
                      <Maximize size={22} /> Standardize & Confirm
                    </>
                  )}
                </button>
              </div>
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
};

export default PosterResizeModal;
