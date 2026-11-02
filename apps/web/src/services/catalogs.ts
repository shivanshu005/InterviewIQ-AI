import { api } from './client'; import type { Company, Difficulty, JobRole } from '@/types/api';
export const catalogApi={ companies:()=>api.get<Company[]>('/companies').then(r=>r.data), roles:()=>api.get<JobRole[]>('/job-roles').then(r=>r.data), difficulties:()=>api.get<Difficulty[]>('/difficulty-levels').then(r=>r.data) };
