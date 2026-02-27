
import React, { useState, useRef, useEffect } from 'react';
import { useAppStore } from '../store';
import { Send } from 'lucide-react';

const ChatRoom: React.FC = () => {
  const { messages, sendMessage, currentUser } = useAppStore();
  const [text, setText] = useState('');
  const scrollRef = useRef<HTMLDivElement>(null);

  const handleSend = (e: React.FormEvent) => {
    e.preventDefault();
    if (!text.trim()) return;
    sendMessage(text);
    setText('');
  };

  useEffect(() => {
    if (scrollRef.current) scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
  }, [messages]);

  return (
    <div className="flex flex-col h-[400px]">
      <div ref={scrollRef} className="flex-1 overflow-y-auto space-y-4 pr-2 custom-scrollbar pb-4">
        {messages.map((m) => {
          const isMine = m.senderId === currentUser?.id;
          return (
            <div key={m.id} className={`flex flex-col ${isMine ? 'items-end' : 'items-start'}`}>
              <div className={`max-w-[80%] p-4 rounded-2xl text-xs font-bold leading-relaxed ${
                isMine ? 'bg-indigo-600 text-white rounded-tr-none' : 'bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 rounded-tl-none'
              }`}>
                {m.text}
              </div>
              <span className="text-[8px] font-black uppercase text-slate-400 mt-1 px-1">
                {m.senderName} • {new Date(m.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
              </span>
            </div>
          );
        })}
        {messages.length === 0 && (
          <div className="h-full flex flex-col items-center justify-center text-slate-400 text-[10px] font-black uppercase text-center italic p-10 opacity-30">
            Secure Channel Open
          </div>
        )}
      </div>

      <form onSubmit={handleSend} className="mt-4 relative">
        <input 
          value={text}
          onChange={e => setText(e.target.value)}
          placeholder="Type message..."
          className="w-full bg-slate-50 dark:bg-slate-950 border border-slate-200 dark:border-slate-800 rounded-2xl py-4 pl-6 pr-14 font-bold outline-none focus:border-indigo-500 transition-all text-sm"
        />
        <button type="submit" className="absolute right-3 top-1/2 -translate-y-1/2 w-10 h-10 bg-indigo-600 text-white rounded-xl flex items-center justify-center hover:bg-indigo-500 transition-all shadow-lg shadow-indigo-600/20">
          <Send size={16} />
        </button>
      </form>
    </div>
  );
};

export default ChatRoom;
