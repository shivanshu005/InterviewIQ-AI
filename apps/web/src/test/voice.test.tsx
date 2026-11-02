import { act, fireEvent, render, renderHook, screen } from '@testing-library/react';
import { useState } from 'react'; import { afterEach, describe, expect, it, vi } from 'vitest';
import { AnswerComposer } from '@/components/shared/AnswerComposer';
import { useSpeechRecognition } from '@/hooks/useSpeechRecognition';

class FakeRecognition {
  static latest: FakeRecognition | null = null; continuous = false; interimResults = false; lang = ''; onresult: ((event: SpeechRecognitionEvent) => void) | null = null; onerror: ((event: SpeechRecognitionErrorEvent) => void) | null = null; onend: (() => void) | null = null; start = vi.fn(); stop = vi.fn(() => this.onend?.()); abort = vi.fn();
  constructor() { FakeRecognition.latest = this; }
  result(text: string, final = true) { this.onresult?.({ resultIndex: 0, results: [{ isFinal: final, 0: { transcript: text }, length: 1 }] as unknown as SpeechRecognitionResultList } as SpeechRecognitionEvent); }
  error(error: string) { this.onerror?.({ error, message: '' } as SpeechRecognitionErrorEvent); this.onend?.(); }
}
afterEach(() => { delete window.SpeechRecognition; delete window.webkitSpeechRecognition; });
describe('voice input', () => {
  it('keeps the typed fallback available when recognition is unsupported', () => {
    render(<AnswerComposer value="" interim="" voiceState="IDLE" voiceSupported={false} voiceError={null} speaking={false} speechSupported={false} autoSpeak={true} onValueChange={vi.fn()} onStart={vi.fn()} onStop={vi.fn()} onClear={vi.fn()} onSpeak={vi.fn()} onCancelSpeech={vi.fn()} onAutoSpeakChange={vi.fn()} />);
    expect(screen.getByLabelText('Your answer or voice transcript')).toBeEnabled();
    expect(screen.getByText(/Voice input is not supported/i)).toBeInTheDocument();
  });
  it('transitions through listening, final transcript, and stop', () => {
    window.SpeechRecognition = FakeRecognition as unknown as SpeechRecognitionConstructor;
    const { result } = renderHook(() => useSpeechRecognition());
    act(() => result.current.start()); expect(result.current.state).toBe('LISTENING');
    act(() => FakeRecognition.latest?.result('A structured answer.')); expect(result.current.transcript).toBe('A structured answer.');
    act(() => result.current.stop()); expect(FakeRecognition.latest?.stop).toHaveBeenCalled(); expect(result.current.state).toBe('READY');
  });
  it('surfaces microphone permission errors without removing typed input', () => {
    window.SpeechRecognition = FakeRecognition as unknown as SpeechRecognitionConstructor;
    const { result } = renderHook(() => useSpeechRecognition()); act(() => result.current.start()); act(() => FakeRecognition.latest?.error('not-allowed'));
    expect(result.current.state).toBe('ERROR'); expect(result.current.error).toMatch(/Microphone access is blocked/i);
  });
  it('lets a reviewed transcript be edited and submitted as text', () => {
    const submit = vi.fn(); const Harness = () => { const [value, setValue] = useState('Voice transcript'); return <><AnswerComposer value={value} interim="" voiceState="READY" voiceSupported onStart={vi.fn()} onStop={vi.fn()} onClear={() => setValue('')} onValueChange={setValue} voiceError={null} speaking={false} speechSupported={false} autoSpeak={false} onSpeak={vi.fn()} onCancelSpeech={vi.fn()} onAutoSpeakChange={vi.fn()} /><button onClick={() => submit(value)}>Submit</button></>; };
    render(<Harness />); fireEvent.change(screen.getByLabelText('Your answer or voice transcript'), { target: { value: 'Edited transcript' } }); fireEvent.click(screen.getByText('Submit')); expect(submit).toHaveBeenCalledWith('Edited transcript');
  });
});
