class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://mktzujpsqyiemfcyjoaj.supabase.co',
  );
  
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    // Security Note: Never hardcode the anon key here. It must be provided via --dart-define or .env
    // defaultValue: 'YOUR_ANON_KEY',
  );
}
