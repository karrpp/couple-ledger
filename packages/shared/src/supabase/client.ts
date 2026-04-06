import { createClient as createSupabaseClient } from '@supabase/supabase-js';

export function createClient(supabaseUrl: string, supabaseAnonKey: string) {
  return createSupabaseClient(supabaseUrl, supabaseAnonKey);
}
