import { useState, useEffect, useRef } from 'react';
import type { FC, ChangeEvent, FormEvent } from 'react';
import { useAppStore } from '../store';
import { ProjectCategory, ProjectImage, PaymentStatus, PaymentMethod, ProjectStatus } from '../types';
import { useNavigate, useParams } from 'react-router-dom';
import { X, ImageIcon, FileCheck, Save, Youtube, Facebook, LayoutTemplate, Globe, Ruler, Shield, ExternalLink, Activity, User, MonitorPlay, History, Loader2 } from 'lucide-react';
import ConfirmUploadModal from './ConfirmUploadModal';
import { projectService } from '../services/projectService';
import { prepareProjectPayload } from '../utils/mapping';

const ProjectForm: FC = () => {
  const { projectId } = useParams();
  const navigate = useNavigate();
  const { currentUser, customers } = useAppStore();

  const isEdit = !!projectId;
  const [loading, setLoading] = useState(false);
  const [uploading, setUploading] = useState(false);

  const [clientSearch, setClientSearch] = useState('');
  const [showClientDropdown, setShowClientDropdown] = useState(false);
  const clientSelectorRef = useRef<HTMLDivElement | null>(null);

  const [formData, setFormData] = useState({
    title: '',
    customerId: '',
    description: '',
    category: ProjectCategory.MOVIE,
    status: ProjectStatus.PENDING,
    deliveryDate: new Date().toISOString().split('T')[0],
    price: 0,
    advanceAmount: 0,
    paymentStatus: PaymentStatus.UNPAID,
    paymentMethod: PaymentMethod.NONE,
    isVisibleOnPublic: true,
    showInAnimation: false,
    showInPrevious: false,
    downloadLink: '',
    designerName: 'Moazzem Hossen',
    assistantName: ''
  });

  const [images, setImages] = useState<ProjectImage[]>([]);

  // Load existing data if edit
  useEffect(() => {
    const fetchProject = async () => {
      if (isEdit && projectId) {
        try {
          setLoading(true);
          // Ideally fetch specific project, but read API returns all. 
          // For now, we reuse the list or implement getById if needed. 
          // Assuming the list view passed data or we fetch list and find.
          // Let's rely on Dashboard fetching and store being populated OR fetch fresh.
          // Since we moved to API, store projects might be empty on direct load.
          // Let's fetch fresh list and find.
          const allProjects = await projectService.getProjects(1000, 0, '', 'All'); // potential perf issue later
          const project = allProjects.find((p: any) => p.id === projectId);

          if (project) {
            setFormData({
              title: project.title,
              customerId: project.customerId,
              description: project.description,
              category: project.category,
              status: project.status,
              deliveryDate: project.deliveryDate || new Date().toISOString().split('T')[0],
              price: project.price,
              advanceAmount: project.advanceAmount,
              paymentStatus: project.paymentStatus,
              paymentMethod: project.paymentMethod,
              isVisibleOnPublic: project.isVisibleOnPublic,
              showInAnimation: project.showInAnimation,
              showInPrevious: project.showInPrevious,
              downloadLink: project.downloadLink,
              designerName: project.designerName,
              assistantName: project.assistantName
            });

            setImages(project.images);
          }
        } catch (error) {
          console.error("Failed to load project", error);
        } finally {
          setLoading(false);
        }
      }
    };

    fetchProject();
  }, [isEdit, projectId]);

  useEffect(() => {
    const onPointerDown = (e: PointerEvent) => {
      const el = clientSelectorRef.current;
      if (!el) return;
      if (e.target instanceof Node && !el.contains(e.target)) {
        setShowClientDropdown(false);
      }
    };

    const onKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        setShowClientDropdown(false);
      }
    };

    document.addEventListener('pointerdown', onPointerDown);
    document.addEventListener('keydown', onKeyDown);
    return () => {
      document.removeEventListener('pointerdown', onPointerDown);
      document.removeEventListener('keydown', onKeyDown);
    };
  }, []);

  const [confirmModal, setConfirmModal] = useState<{
    isOpen: boolean;
    preview: string;
    file: File | null;
    type: ProjectImage['type'];
  }>({ isOpen: false, preview: '', file: null, type: 'custom' });

  const handleImageUploadRequest = (e: ChangeEvent<HTMLInputElement>, type: ProjectImage['type'] = 'custom') => {
    const file = e.target.files?.[0];
    if (!file) return;

    // 2MB Size Limit (Increased for better quality)
    const MAX_SIZE = 2 * 1024 * 1024;
    if (file.size > MAX_SIZE) {
      alert(`File "${file.name}" exceeds the 2MB limit.`);
      e.target.value = '';
      return;
    }

    const reader = new FileReader();
    reader.onload = (re) => {
      setConfirmModal({
        isOpen: true,
        preview: re.target?.result as string,
        file: file,
        type: type
      });
    };
    reader.readAsDataURL(file);
    e.target.value = '';
  };

  const handleConfirmUpload = async () => {
    const { file, type } = confirmModal;
    setConfirmModal(prev => ({ ...prev, isOpen: false }));

    if (!file) return;

    try {
      setUploading(true);
      const data = await projectService.uploadImage(file);
      // Cloudinary returns secure_url
      setImages(prev => [...prev, { id: crypto.randomUUID(), url: data.secure_url, type }]);
    } catch (error) {
      alert('Upload failed. Please try again.');
      console.error(error);
    } finally {
      setUploading(false);
    }
  };

  const filteredCustomers = customers
    .filter(c => {
      const q = clientSearch.trim().toLowerCase();
      if (!q) return true;
      return c.id.toLowerCase().includes(q) || c.name.toLowerCase().includes(q);
    })
    .slice(0, 20);

  const selectedCustomer = customers.find(c => c.id === formData.customerId);

  const removeImage = (id: string) => setImages(prev => prev.filter(img => img.id !== id));

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();

    if (formData.advanceAmount > formData.price) {
      alert('Advance cannot exceed total project price.');
      return;
    }

    try {
      setLoading(true);
      const payload = prepareProjectPayload({ ...formData, images, id: projectId });

      if (isEdit && projectId) {
        await projectService.updateProject(projectId, payload);
      } else {
        await projectService.createProject(payload);
      }
      navigate('/');
    } catch (error) {
      console.error("Submission failed", error);
      alert("Failed to save project. Please check network.");
    } finally {
      setLoading(false);
    }
  };

  const hasPoster = images.some(img => img.type === 'poster');

  if (!currentUser) return (
    <div className="min-h-[60vh] flex flex-col items-center justify-center text-center">
      <Shield className="text-rose-500 mb-6" size={64} />
      <h2 className="text-3xl font-black">Restricted Access</h2>
    </div>
  );

  return (
    <div className="space-y-12 pb-32">
      <div className="flex flex-col md:flex-row justify-between items-end gap-6">
        <div>
          <h2 className="text-5xl font-black tracking-tighter leading-none">{isEdit ? 'Update Asset' : 'Initialize Asset'}</h2>
          <p className="text-[10px] font-black uppercase text-slate-500 tracking-[0.4em] mt-3">Studio Operational Protocol</p>
        </div>
        <div className="bg-emerald-600/10 text-emerald-600 px-8 py-4 rounded-[2rem] font-black uppercase text-[10px] tracking-widest border border-emerald-500/20 flex items-center gap-3">
          <FileCheck size={20} /> Identity Verified
        </div>
      </div>

      <form onSubmit={handleSubmit} className="space-y-16">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-12">
          <div className="lg:col-span-2 space-y-12">
            <div className="glass p-12 md:p-20 rounded-[4rem] space-y-12 shadow-2xl border border-white/10">
              <div className="flex flex-wrap items-center gap-4 border-b border-slate-100 dark:border-slate-800 pb-10">
                <h3 className="text-[11px] font-black uppercase tracking-[0.4em] text-indigo-500 flex-1">Master Record Configuration</h3>

                <div className="flex flex-wrap items-center gap-3">
                  <button
                    type="button"
                    onClick={() => setFormData({ ...formData, isVisibleOnPublic: !formData.isVisibleOnPublic })}
                    className={`flex items-center gap-3 px-6 py-3 rounded-full font-black text-[9px] uppercase tracking-widest transition-all ${formData.isVisibleOnPublic ? 'bg-indigo-600 text-white shadow-lg' : 'bg-slate-100 dark:bg-slate-800 text-slate-400'}`}
                    title="Legacy visibility toggle"
                  >
                    <Globe size={14} />
                    Public: {formData.isVisibleOnPublic ? 'ON' : 'OFF'}
                  </button>

                  <button
                    type="button"
                    onClick={() => setFormData({ ...formData, showInAnimation: !formData.showInAnimation })}
                    className={`flex items-center gap-3 px-6 py-3 rounded-full font-black text-[9px] uppercase tracking-widest transition-all ${formData.showInAnimation ? 'bg-indigo-500 text-white shadow-lg' : 'bg-slate-100 dark:bg-slate-800 text-slate-400'}`}
                  >
                    <MonitorPlay size={14} />
                    In Animation: {formData.showInAnimation ? 'YES' : 'NO'}
                  </button>

                  <button
                    type="button"
                    onClick={() => setFormData({ ...formData, showInPrevious: !formData.showInPrevious })}
                    className={`flex items-center gap-3 px-6 py-3 rounded-full font-black text-[9px] uppercase tracking-widest transition-all ${formData.showInPrevious ? 'bg-indigo-500 text-white shadow-lg' : 'bg-slate-100 dark:bg-slate-800 text-slate-400'}`}
                  >
                    <History size={14} />
                    In Previous: {formData.showInPrevious ? 'YES' : 'NO'}
                  </button>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-10">
                <div className="space-y-4">
                  <label className="text-[9px] font-black uppercase tracking-widest text-slate-400 ml-2">Client Identity</label>
                  <div className="relative" ref={clientSelectorRef}>
                    <input
                      type="text"
                      value={selectedCustomer ? `${selectedCustomer.id} — ${selectedCustomer.name}` : clientSearch}
                      onChange={e => {
                        setClientSearch(e.target.value);
                        setFormData({ ...formData, customerId: '' });
                        setShowClientDropdown(true);
                      }}
                      onFocus={() => setShowClientDropdown(true)}
                      placeholder="Search client (optional)…"
                      className="w-full bg-slate-50 dark:bg-slate-950 border-2 border-slate-100 dark:border-slate-800 rounded-[2rem] px-10 py-6 font-bold outline-none focus:border-indigo-500 shadow-sm"
                    />

                    {(formData.customerId || clientSearch) && (
                      <button
                        type="button"
                        onClick={() => {
                          setFormData({ ...formData, customerId: '' });
                          setClientSearch('');
                          setShowClientDropdown(false);
                        }}
                        className="absolute right-4 top-1/2 -translate-y-1/2 p-2 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-800"
                        title="Clear client"
                      >
                        <X size={16} />
                      </button>
                    )}

                    {showClientDropdown && !selectedCustomer && filteredCustomers.length > 0 && (
                      <div className="absolute z-50 mt-3 w-full max-h-80 overflow-auto rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-950 shadow-2xl">
                        {filteredCustomers.map(c => (
                          <button
                            key={c.id}
                            type="button"
                            onClick={() => {
                              setFormData({ ...formData, customerId: c.id });
                              setClientSearch('');
                              setShowClientDropdown(false);
                            }}
                            className="w-full text-left px-8 py-5 hover:bg-slate-50 dark:hover:bg-slate-900"
                          >
                            <div className="font-black text-xs">{c.id}</div>
                            <div className="text-[11px] font-bold text-slate-500">{c.name}</div>
                          </button>
                        ))}
                      </div>
                    )}
                  </div>
                </div>
                <div className="space-y-4">
                  <label className="text-[9px] font-black uppercase tracking-widest text-slate-400 ml-2">Master Title</label>
                  <input required type="text" value={formData.title} onChange={e => setFormData({ ...formData, title: e.target.value })} className="w-full bg-slate-50 dark:bg-slate-950 border-2 border-slate-100 dark:border-slate-800 rounded-[2rem] px-10 py-6 font-bold outline-none focus:border-indigo-500 shadow-sm" placeholder="Title for Deliverable" />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-10">
                <div className="space-y-4">
                  <label className="text-[9px] font-black uppercase text-slate-400 ml-2">Designer Name</label>
                  <input type="text" value={formData.designerName} onChange={e => setFormData({ ...formData, designerName: e.target.value })} className="w-full bg-slate-50 dark:bg-slate-950 border-2 border-slate-100 dark:border-slate-800 rounded-[2rem] px-10 py-6 font-bold outline-none focus:border-indigo-500 shadow-sm" placeholder="Primary Creator" />
                </div>
                <div className="space-y-4">
                  <label className="text-[9px] font-black uppercase text-slate-400 ml-2">Designer's Assistant</label>
                  <input type="text" value={formData.assistantName} onChange={e => setFormData({ ...formData, assistantName: e.target.value })} className="w-full bg-slate-50 dark:bg-slate-950 border-2 border-slate-100 dark:border-slate-800 rounded-[2rem] px-10 py-6 font-bold outline-none focus:border-indigo-500 shadow-sm" placeholder="Associate Creator" />
                </div>
              </div>

              <div className="space-y-4">
                <label className="text-[9px] font-black uppercase tracking-widest text-slate-400 ml-2">Technical Brief</label>
                <textarea rows={5} value={formData.description} onChange={e => setFormData({ ...formData, description: e.target.value })} className="w-full bg-slate-50 dark:bg-slate-950 border-2 border-slate-100 dark:border-slate-800 rounded-[3rem] px-10 py-8 font-bold outline-none resize-none focus:border-indigo-500 shadow-sm" placeholder="Provide design parameters..." />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-10">
                <div className="space-y-4">
                  <label className="text-[9px] font-black uppercase text-slate-400 ml-2">Modality Class</label>
                  <select value={formData.category} onChange={e => setFormData({ ...formData, category: e.target.value as any })} className="w-full bg-slate-50 dark:bg-slate-950 border-2 border-slate-100 dark:border-slate-800 rounded-[2rem] px-10 py-6 font-bold outline-none shadow-sm appearance-none">
                    {Object.values(ProjectCategory).map(v => <option key={v} value={v}>{v}</option>)}
                  </select>
                </div>
                <div className="space-y-4">
                  <label className="text-[9px] font-black uppercase text-slate-400 ml-2">Production Status</label>
                  <select value={formData.status} onChange={e => setFormData({ ...formData, status: e.target.value as any })} className="w-full bg-slate-50 dark:bg-slate-950 border-2 border-slate-100 dark:border-slate-800 rounded-[2rem] px-10 py-6 font-bold outline-none shadow-sm appearance-none">
                    {Object.values(ProjectStatus).map(v => <option key={v} value={v}>{v}</option>)}
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-10">
                <div className="space-y-4">
                  <label className="text-[9px] font-black uppercase text-slate-400 ml-2">Protocol Deadline</label>
                  <input type="date" value={formData.deliveryDate} onChange={e => setFormData({ ...formData, deliveryDate: e.target.value })} className="w-full bg-slate-50 dark:bg-slate-950 border-2 border-slate-100 dark:border-slate-800 rounded-[2rem] px-10 py-6 font-bold outline-none shadow-sm" />
                </div>
                <div className="space-y-4">
                  <label className="text-[9px] font-black uppercase text-slate-400 ml-2 flex items-center gap-2">
                    <ExternalLink size={12} className="text-indigo-500" /> Deliverable Archive (G-Drive)
                  </label>
                  <input type="url" value={formData.downloadLink} onChange={e => setFormData({ ...formData, downloadLink: e.target.value })} className="w-full bg-slate-50 dark:bg-slate-950 border-2 border-slate-100 dark:border-slate-800 rounded-[2rem] px-10 py-6 font-bold outline-none focus:border-indigo-500 shadow-sm" placeholder="https://drive.google.com/..." />
                </div>
              </div>
            </div>

            <div className="glass p-12 md:p-20 rounded-[4rem] space-y-12 shadow-2xl border border-white/10">
              <h3 className="text-[11px] font-black uppercase tracking-[0.4em] text-indigo-500 border-b border-slate-100 dark:border-slate-800 pb-10">Treasury & Valuation</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-12">
                <div className="space-y-4">
                  <label className="text-[9px] font-black uppercase text-slate-400 mb-2 block ml-2">Total Project Value (৳)</label>
                  <input type="number" required value={formData.price} onChange={e => setFormData({ ...formData, price: Number(e.target.value) })} className="w-full bg-slate-50 dark:bg-slate-900 border-2 border-slate-100 dark:border-slate-800 rounded-[3rem] px-12 py-10 font-black text-5xl text-indigo-600 outline-none focus:border-indigo-500 shadow-xl" />
                </div>
                <div className="space-y-4">
                  <label className="text-[9px] font-black uppercase text-slate-400 mb-2 block ml-2">Advance Deposit (৳)</label>
                  <input type="number" value={formData.advanceAmount} onChange={e => setFormData({ ...formData, advanceAmount: Number(e.target.value) })} disabled={formData.paymentStatus === PaymentStatus.PAID} className="w-full bg-slate-50 dark:bg-slate-900 border-2 border-slate-100 dark:border-slate-800 rounded-[3rem] px-12 py-10 font-black text-5xl text-emerald-600 outline-none focus:border-emerald-500 shadow-xl disabled:opacity-60 disabled:cursor-not-allowed" />
                </div>
              </div>
            </div>
          </div>

          <div className="space-y-12">
            <div className="glass p-10 rounded-[3.5rem] h-fit shadow-2xl border border-white/10">
              <h3 className="text-[11px] font-black uppercase tracking-[0.4em] text-indigo-500 border-b border-slate-100 dark:border-slate-800 pb-8 flex items-center gap-4">
                <ImageIcon size={22} /> Asset Provision
                {uploading && <Loader2 className="animate-spin text-indigo-500 ml-auto" />}
              </h3>

              <div className="mt-10 space-y-10">
                <div className="bg-amber-500/5 border border-amber-500/20 p-6 rounded-3xl">
                  <p className="flex items-center gap-3 text-[10px] font-black uppercase tracking-widest text-amber-500">
                    <Ruler size={14} /> Preferred Resolution
                  </p>
                  <p className="text-xs font-bold text-amber-700 dark:text-amber-300 mt-2 italic">Standard: 3546 × 4433 HQ. Max Size: 2MB.</p>
                </div>

                {/* Disable new uploads while uploading */}
                {!hasPoster ? (
                  <AssetUpload label="REQUIRED: Main Cover" icon={<LayoutTemplate className="text-indigo-600" />} onUpload={(e: any) => handleImageUploadRequest(e, 'poster')} disabled={uploading} />
                ) : (
                  <div className="space-y-8 animate-in fade-in zoom-in duration-700">
                    <p className="text-[10px] font-black uppercase text-emerald-600 text-center tracking-widest border border-emerald-500/20 py-4 rounded-2xl bg-emerald-500/5">Main Cover Locked</p>
                    <AssetUpload label="YouTube Thumbnail" icon={<Youtube className="text-rose-600" />} onUpload={(e: any) => handleImageUploadRequest(e, 'youtube')} disabled={uploading} />
                    <AssetUpload label="Facebook Cover" icon={<Facebook className="text-indigo-600" />} onUpload={(e: any) => handleImageUploadRequest(e, 'facebook')} disabled={uploading} />
                    <AssetUpload label="Custom Graphics" icon={<ImageIcon className="text-slate-400" />} onUpload={(e: any) => handleImageUploadRequest(e, 'custom')} disabled={uploading} />
                  </div>
                )}

                <div className="grid grid-cols-2 gap-6 pt-6">
                  {images.map(img => (
                    <div key={img.id} className="relative group rounded-[2.5rem] overflow-hidden border-4 border-white dark:border-slate-800 shadow-2xl aspect-square bg-slate-950">
                      <img src={img.url} className="w-full h-full object-cover" alt="Preview" />
                      <div className="absolute inset-0 bg-slate-900/70 opacity-0 group-hover:opacity-100 transition-all flex flex-col items-center justify-center gap-4">
                        <span className="text-[10px] font-black text-white uppercase bg-indigo-600 px-4 py-2 rounded-xl shadow-lg">{img.type}</span>
                        <button type="button" onClick={() => removeImage(img.id)} className="p-4 bg-rose-500 text-white rounded-2xl shadow-2xl hover:scale-110 active:scale-95 transition-all">
                          <X size={20} />
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>

        <div className="flex flex-col md:flex-row justify-end gap-8 pt-16 border-t border-white/10">
          <button type="button" onClick={() => navigate('/')} className="px-20 py-8 font-black uppercase tracking-[0.4em] text-slate-500 text-xs hover:text-rose-500 transition-colors order-2 md:order-1" disabled={loading}>Discard Record</button>
          <button type="submit" disabled={loading} className="bg-indigo-600 text-white px-32 py-8 rounded-[3rem] font-black uppercase tracking-[0.4em] shadow-[0_32px_64px_-16px_rgba(79,70,229,0.5)] hover:bg-indigo-500 active:scale-95 transition-all text-sm order-1 md:order-2 flex items-center justify-center gap-4 disabled:opacity-50">
            {loading ? <Loader2 className="animate-spin" /> : <Save size={24} />}
            {loading ? 'Saving...' : (isEdit ? 'Update Master' : 'Commit Record')}
          </button>
        </div>
      </form>

      <ConfirmUploadModal
        isOpen={confirmModal.isOpen}
        imagePreview={confirmModal.preview}
        type={confirmModal.type}
        onClose={() => setConfirmModal(prev => ({ ...prev, isOpen: false }))}
        onConfirm={handleConfirmUpload}
      />
    </div>
  );
};

const AssetUpload = ({ label, icon, onUpload, disabled }: any) => (
  <label className={`block cursor-pointer group ${disabled ? 'opacity-50 pointer-events-none' : ''}`}>
    <div className="border-4 border-dashed border-slate-200 dark:border-slate-800 rounded-[2.5rem] px-8 py-10 text-center hover:border-indigo-500 hover:bg-indigo-50/20 dark:hover:bg-indigo-950/20 transition-all flex flex-col items-center justify-center gap-3">
      {icon}
      <p className="text-[10px] font-black uppercase tracking-[0.3em] text-slate-400 group-hover:text-indigo-600">Provision {label}</p>
    </div>
    <input type="file" className="hidden" accept="image/*" onChange={onUpload} disabled={disabled} />
  </label>
);

export default ProjectForm;
