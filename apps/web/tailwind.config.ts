import type { Config } from 'tailwindcss';
export default { content: ['./index.html', './src/**/*.{ts,tsx}'], theme: { extend: { colors: { ink: '#09090b', panel: '#18181b', muted: '#a1a1aa', brand: '#8b5cf6' }, boxShadow: { glow: '0 0 36px rgba(139,92,246,.16)' } } }, plugins: [] } satisfies Config;
