-- Agrononova database schema for Supabase
-- Run this in Supabase Dashboard > SQL Editor.
-- Important: enable Row Level Security and review policies before real public launch.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  role text not null default 'farmer' check (role in ('farmer','buyer','admin')),
  village text,
  phone text,
  created_at timestamptz not null default now()
);

create table if not exists public.crop_listings (
  id uuid primary key default gen_random_uuid(),
  seller_id uuid references auth.users(id) on delete set null,
  crop_name text not null,
  category text not null default 'Other',
  price_per_quintal numeric(12,2) not null check (price_per_quintal > 0),
  quantity_quintals numeric(12,2) not null check (quantity_quintals > 0),
  state text not null,
  district text,
  village text,
  description text,
  contact_phone text,
  image_url text,
  status text not null default 'available' check (status in ('available','reserved','sold','removed')),
  created_at timestamptz not null default now()
);

create table if not exists public.soil_test_bookings (
  id uuid primary key default gen_random_uuid(),
  farmer_id uuid references auth.users(id) on delete set null,
  farmer_name text not null,
  contact_phone text not null,
  village_or_district text not null,
  crop_or_soil_need text not null,
  preferred_date date not null,
  preferred_slot text not null,
  status text not null default 'requested' check (status in ('requested','confirmed','completed','cancelled')),
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists public.chat_messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  session_id text,
  sender text not null check (sender in ('user','assistant')),
  message text not null,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.crop_listings enable row level security;
alter table public.soil_test_bookings enable row level security;
alter table public.chat_messages enable row level security;

-- Public can read available listings; authenticated users can manage their own listings.
create policy "Anyone can read available crop listings"
on public.crop_listings for select
using (status = 'available' or seller_id = auth.uid());

create policy "Signed-in users can add their own listings"
on public.crop_listings for insert to authenticated
with check (seller_id = auth.uid());

create policy "Sellers can update their own listings"
on public.crop_listings for update to authenticated
using (seller_id = auth.uid())
with check (seller_id = auth.uid());

create policy "Sellers can delete their own listings"
on public.crop_listings for delete to authenticated
using (seller_id = auth.uid());

create policy "Users can read their own profile"
on public.profiles for select to authenticated
using (id = auth.uid());

create policy "Users can create their own profile"
on public.profiles for insert to authenticated
with check (id = auth.uid());

create policy "Users can update their own profile"
on public.profiles for update to authenticated
using (id = auth.uid())
with check (id = auth.uid());

-- Booking policy: signed-in users can create and view their own bookings.
create policy "Farmers can create their own soil bookings"
on public.soil_test_bookings for insert to authenticated
with check (farmer_id = auth.uid());

create policy "Farmers can view their own soil bookings"
on public.soil_test_bookings for select to authenticated
using (farmer_id = auth.uid());

create policy "Farmers can cancel their own soil bookings"
on public.soil_test_bookings for update to authenticated
using (farmer_id = auth.uid())
with check (farmer_id = auth.uid());

create policy "Users can read their own chat messages"
on public.chat_messages for select to authenticated
using (user_id = auth.uid());

create policy "Users can add their own chat messages"
on public.chat_messages for insert to authenticated
with check (user_id = auth.uid());

-- A production AI chat should call a server-side Edge Function.
-- Never put an OpenAI secret/API key in index.html or any public frontend file.
