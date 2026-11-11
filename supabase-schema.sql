-- NEON: schema per account personale con sincronizzazione cloud.
-- Esegui tutto questo script in Supabase > SQL Editor > New query.

create table if not exists public.transactions (
  user_id uuid not null references auth.users(id) on delete cascade,
  id text not null,
  amount numeric(12,2) not null check (amount > 0),
  category text not null default 'altro',
  date date not null,
  note text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

create table if not exists public.categories (
  user_id uuid not null references auth.users(id) on delete cascade,
  id text not null,
  name text not null,
  emoji text not null default '✳️',
  color text not null default '#a4b4c8',
  created_at timestamptz not null default now(),
  primary key (user_id, id)
);

create table if not exists public.settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  budget numeric(12,2) not null default 0 check (budget >= 0),
  updated_at timestamptz not null default now()
);

alter table public.transactions enable row level security;
alter table public.categories enable row level security;
alter table public.settings enable row level security;

-- Ogni account può leggere e modificare esclusivamente le proprie righe.
drop policy if exists "Users manage own transactions" on public.transactions;
create policy "Users manage own transactions" on public.transactions
  for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "Users manage own categories" on public.categories;
create policy "Users manage own categories" on public.categories
  for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "Users manage own settings" on public.settings;
create policy "Users manage own settings" on public.settings
  for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Abilita gli aggiornamenti realtime per la sincronizzazione tra dispositivi.
do $$ begin
  alter publication supabase_realtime add table public.transactions;
exception when duplicate_object then null;
when undefined_object then null;
end $$;
do $$ begin
  alter publication supabase_realtime add table public.categories;
exception when duplicate_object then null;
when undefined_object then null;
end $$;
do $$ begin
  alter publication supabase_realtime add table public.settings;
exception when duplicate_object then null;
when undefined_object then null;
end $$;
