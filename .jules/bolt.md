## 2024-05-18 - Supabase array length fetch optimization
**Learning:** In the Overview Dashboard, counting `pending` reports by fetching the entire array `supabase.from('reports').select('*').eq('status', 'pending')` and reading the `.length` transfers the entire payload. This becomes a bottleneck as the dataset grows.
**Action:** Use `supabase.from('reports').select('*', { count: 'exact', head: true })` and read the `.count` property. This uses an HTTP HEAD request and returns only the integer in the headers, completely avoiding large payload transfers.
