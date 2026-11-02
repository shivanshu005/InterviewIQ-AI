import { defineConfig } from 'vitest/config';
import { loadEnv } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'node:path';
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), 'VITE_');
  return { plugins: [react()], resolve: { alias: { '@': path.resolve(__dirname, './src') } }, server: { proxy: { '/api': { target: env.VITE_DEV_API_PROXY_TARGET || 'http://localhost:8080', changeOrigin: true } } }, test: { environment: 'jsdom', setupFiles: './src/test/setup.ts', globals: true } };
});
