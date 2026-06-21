-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Custom helper function to get auth user ID as text safely (avoiding UUID cast errors for Firebase UIDs)
create or replace function public.auth_uid_text()
returns text
language sql
stable
as $$
  select coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::text;
$$;

-- Families Table
create table if not exists families (
  id text primary key,
  name text not null,
  house_name text not null,
  ward_number text not null,
  admin_uid text not null,
  member_uids text[] not null default '{}',
  verification_status text not null default 'pending',
  created_at timestamptz not null default now()
);

-- Users Table
create table if not exists users (
  uid text primary key,
  phone text not null,
  name text not null,
  family_id text references families(id) on delete set null,
  role text not null default 'member',
  fcm_token text,
  suspended boolean not null default false,
  created_at timestamptz not null default now()
);

-- Join Requests Table
create table if not exists join_requests (
  id text primary key,
  family_id text references families(id) on delete cascade,
  user_id text not null,
  user_name text not null,
  user_phone text not null,
  status text not null default 'pending',
  created_at timestamptz not null default now()
);

-- Notices Table
create table if not exists notices (
  id text primary key,
  title text not null,
  description text not null,
  icon text not null default 'info',
  color_hex text not null default '#000000',
  priority text not null default 'Medium',
  created_at timestamptz not null default now()
);

-- Events Table
create table if not exists events (
  id text primary key,
  title text not null,
  description text not null,
  date timestamptz not null,
  time text not null,
  venue text not null,
  latitude double precision,
  longitude double precision,
  host text not null,
  image_url text,
  attachments text[] not null default '{}',
  created_by text not null,
  status text not null default 'upcoming',
  created_at timestamptz not null default now()
);

-- Invitations Table
create table if not exists invitations (
  id text primary key,
  code text not null unique,
  family_id text references families(id) on delete cascade,
  used boolean not null default false,
  created_at timestamptz not null default now()
);

-- Reports Table
create table if not exists reports (
  id text primary key,
  content_type text not null,
  content_id text not null,
  reason text not null,
  reported_by text not null,
  status text not null default 'pending',
  action_taken text not null default 'none',
  created_at timestamptz not null default now()
);

-- Enable Realtime for all tables safely
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'families') then
    alter publication supabase_realtime add table families;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'join_requests') then
    alter publication supabase_realtime add table join_requests;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'notices') then
    alter publication supabase_realtime add table notices;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'events') then
    alter publication supabase_realtime add table events;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'invitations') then
    alter publication supabase_realtime add table invitations;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'reports') then
    alter publication supabase_realtime add table reports;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'users') then
    alter publication supabase_realtime add table users;
  end if;
end $$;

-- Enable Row Level Security on all tables
alter table families enable row level security;
alter table users enable row level security;
alter table join_requests enable row level security;
alter table notices enable row level security;
alter table events enable row level security;
alter table invitations enable row level security;
alter table reports enable row level security;

-- ==========================================
-- Triggers for Status Protection (IDOR Prevention)
-- ==========================================

create or replace function protect_family_verification_status()
returns trigger
security definer set search_path = public
language plpgsql
as $$
begin
  -- Allow service roles and superusers
  if coalesce(current_setting('role', true), '') in ('service_role', 'postgres') then
    return new;
  end if;

  if old.verification_status is distinct from new.verification_status then
    -- Only allow admin users to change verification_status
    if not exists (select 1 from users where uid = public.auth_uid_text() and role = 'admin') then
      raise exception 'Unauthorized to update verification_status';
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists ensure_family_verification_status on families;
create trigger ensure_family_verification_status
  before update on families
  for each row
  execute function protect_family_verification_status();


create or replace function protect_join_request_status()
returns trigger
security definer set search_path = public
language plpgsql
as $$
begin
  -- Allow service roles and superusers
  if coalesce(current_setting('role', true), '') in ('service_role', 'postgres') then
    return new;
  end if;

  if old.status is distinct from new.status then
    -- Only allow family admin or system admins to change status
    if not exists (
      select 1 from families f where f.id = new.family_id and f.admin_uid = public.auth_uid_text()
    ) and not exists (
      select 1 from users u where u.uid = public.auth_uid_text() and u.role = 'admin'
    ) then
      raise exception 'Unauthorized to update join_request status';
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists ensure_join_request_status on join_requests;
create trigger ensure_join_request_status
  before update on join_requests
  for each row
  execute function protect_join_request_status();

-- ==========================================
-- RLS Policies
-- ==========================================

-- 1. Users Table Policies
drop policy if exists "Users can insert their own profile" on users;
create policy "Users can insert their own profile" on users
  for insert with check (
    uid = public.auth_uid_text() and
    role = 'member' and
    suspended = false
  );

drop policy if exists "Users can read all profiles" on users;
create policy "Users can read all profiles" on users
  for select using (true);

drop policy if exists "Users can update their own profile" on users;
create policy "Users can update their own profile" on users
  for update using (
    uid = public.auth_uid_text() or
    exists (
      select 1 from users u
      where u.uid = public.auth_uid_text() and u.role = 'admin'
    )
  )
  with check (
    (
      uid = public.auth_uid_text() and
      role = (select role from users where uid = public.auth_uid_text()) and
      suspended = (select suspended from users where uid = public.auth_uid_text())
    ) or
    exists (
      select 1 from users u
      where u.uid = public.auth_uid_text() and u.role = 'admin'
    )
  );

-- 2. Families Table Policies
drop policy if exists "Anyone can create a family" on families;
create policy "Anyone can create a family" on families
  for insert with check (
    public.auth_uid_text() is not null and
    admin_uid = public.auth_uid_text() and
    verification_status = 'pending'
  );

drop policy if exists "Anyone can read families" on families;
create policy "Anyone can read families" on families
  for select using (true);

drop policy if exists "Family admin or members can update family" on families;
create policy "Family admin or members can update family" on families
  for update using (
    admin_uid = public.auth_uid_text() or 
    public.auth_uid_text() = any(member_uids) or
    exists (
      select 1 from users u
      where u.uid = public.auth_uid_text() and u.role = 'admin'
    )
  );

-- 3. Join Requests Policies
drop policy if exists "Users can create their own join requests" on join_requests;
create policy "Users can create their own join requests" on join_requests
  for insert with check (
    user_id = public.auth_uid_text() and
    status = 'pending'
  );

drop policy if exists "Users can read join requests they created" on join_requests;
create policy "Users can read join requests they created" on join_requests
  for select using (
    user_id = public.auth_uid_text() or
    exists (
      select 1 from families f
      where f.id = join_requests.family_id and f.admin_uid = public.auth_uid_text()
    )
  );

drop policy if exists "Users and family admins can update join requests" on join_requests;
create policy "Users and family admins can update join requests" on join_requests
  for update using (
    user_id = public.auth_uid_text() or
    exists (
      select 1 from families f
      where f.id = join_requests.family_id and f.admin_uid = public.auth_uid_text()
    )
  );

-- 4. Notices Policies
drop policy if exists "Anyone can read notices" on notices;
create policy "Anyone can read notices" on notices
  for select using (true);

drop policy if exists "Only admin users can modify notices" on notices;
create policy "Only admin users can modify notices" on notices
  for all using (
    exists (
      select 1 from users u
      where u.uid = public.auth_uid_text() and u.role = 'admin'
    )
  );

-- 5. Events Policies
drop policy if exists "Anyone can read events" on events;
create policy "Anyone can read events" on events
  for select using (true);

drop policy if exists "Authenticated users can insert events" on events;
create policy "Authenticated users can insert events" on events
  for insert with check (
    public.auth_uid_text() is not null and
    created_by = public.auth_uid_text() and
    status = 'upcoming'
  );

drop policy if exists "Event creator can update/delete events" on events;
create policy "Event creator can update/delete events" on events
  for all using (created_by = public.auth_uid_text());

-- 6. Invitations Policies
drop policy if exists "Anyone can read invitations" on invitations;
create policy "Anyone can read invitations" on invitations
  for select using (true);

drop policy if exists "Family members/admin can create invitations" on invitations;
create policy "Family members/admin can create invitations" on invitations
  for insert with check (
    exists (
      select 1 from families f
      where f.id = invitations.family_id and (f.admin_uid = public.auth_uid_text() or public.auth_uid_text() = any(f.member_uids))
    )
  );

drop policy if exists "Family admin can delete invitations" on invitations;
create policy "Family admin can delete invitations" on invitations
  for delete using (
    exists (
      select 1 from families f
      where f.id = invitations.family_id and f.admin_uid = public.auth_uid_text()
    )
  );

-- 7. Reports Policies
drop policy if exists "Authenticated users can create reports" on reports;
create policy "Authenticated users can create reports" on reports
  for insert with check (
    reported_by = public.auth_uid_text() and
    status = 'pending' and
    action_taken = 'none'
  );

drop policy if exists "Only admins can read/modify reports" on reports;
create policy "Only admins can read/modify reports" on reports
  for all using (
    exists (
      select 1 from users u
      where u.uid = public.auth_uid_text() and u.role = 'admin'
    )
  );
