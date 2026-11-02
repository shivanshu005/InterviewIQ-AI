export const cn = (...values:(string|undefined|false)[]) => values.filter(Boolean).join(' ');
export const formatDate = (value?:string|null) => value ? new Intl.DateTimeFormat(undefined,{dateStyle:'medium'}).format(new Date(value)) : '—';
export const friendlyError = (error: unknown) => error instanceof Error ? error.message : 'Something went wrong. Please try again.';
