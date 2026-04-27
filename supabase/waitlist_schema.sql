-- Run this in Supabase → SQL Editor (once), then test the waitlist form.
-- https://supabase.com/dashboard/project/_/sql

create table if not exists public.waitlist_signups (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name text not null,
  email text not null,
  struggle text
);

-- One row per email (optional; remove this index if you allow duplicates)
create unique index if not exists waitlist_signups_email_lower
  on public.waitlist_signups (lower(email));

alter table public.waitlist_signups enable row level security;

drop policy if exists "Allow anonymous waitlist inserts" on public.waitlist_signups;

-- Inserts from the website use the anon (publishable) key
create policy "Allow anonymous waitlist inserts"
  on public.waitlist_signups
  for insert
  to anon
  with check (true);

-- No SELECT policy for anon → the public cannot read the table via the API

-- Adds `struggle` on existing projects (safe to re-run)
alter table public.waitlist_signups add column if not exists struggle text;
