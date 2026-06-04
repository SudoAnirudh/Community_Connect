class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://mktzujpsqyiemfcyjoaj.supabase.co',
  );
  
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1rdHp1anBzcXlpZW1mY3lqb2FqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA0NjUwNTgsImV4cCI6MjA5NjA0MTA1OH0.G2m3VeEWjHENj4jUiSzG3Mu2_HHeI6UhDhbJf2XwDpc',
  );
}
