import axios from 'axios';
import type { ApiError } from '@/types/api';
const baseURL = import.meta.env.VITE_API_BASE_URL || '/api/v1';
export const tokenStore = { get:()=>sessionStorage.getItem('interviewiq.accessToken'), set:(token:string)=>sessionStorage.setItem('interviewiq.accessToken',token), clear:()=>sessionStorage.removeItem('interviewiq.accessToken') };
export const api = axios.create({ baseURL, headers:{ 'Content-Type':'application/json' } });
api.interceptors.request.use(config => { const token=tokenStore.get(); if(token) config.headers.Authorization=`Bearer ${token}`; return config; });
api.interceptors.response.use(r=>r, error => { const body=error.response?.data; const detail:ApiError = body?.error ?? body ?? {}; const message=detail.message || (error.response?.status===401 ? 'Your session has expired. Please sign in again.' : error.message || 'Unable to reach the service.'); if(error.response?.status===401) { tokenStore.clear(); window.dispatchEvent(new Event('interviewiq:unauthorized')); } return Promise.reject(Object.assign(new Error(message), { status:error.response?.status, details:detail })); });
