import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

export function useSpeechSynthesis() {
  const supported = useMemo(() => typeof window !== 'undefined' && 'speechSynthesis' in window && 'SpeechSynthesisUtterance' in window, []);
  const [speaking, setSpeaking] = useState(false); const utterance = useRef<SpeechSynthesisUtterance | null>(null);
  const cancel = useCallback(() => { if (supported) window.speechSynthesis.cancel(); utterance.current = null; setSpeaking(false); }, [supported]);
  const speak = useCallback((text: string) => { if (!supported || !text.trim()) return false; cancel(); const next = new SpeechSynthesisUtterance(text); next.rate = 0.95; next.onend = () => setSpeaking(false); next.onerror = () => setSpeaking(false); utterance.current = next; setSpeaking(true); window.speechSynthesis.speak(next); return true; }, [cancel, supported]);
  useEffect(() => cancel, [cancel]);
  return { supported, speaking, speak, cancel };
}
