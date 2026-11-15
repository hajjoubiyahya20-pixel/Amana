-- AMANA: public review visibility + authenticated review submission.
-- Run once in Supabase > SQL Editor > New query.
-- This adds named policies without removing the existing owner-management policies.

grant select on public.reviews to anon, authenticated;
grant insert on public.reviews to authenticated;

drop policy if exists "amana_reviews_public_read" on public.reviews;
create policy "amana_reviews_public_read"
on public.reviews
for select
to anon, authenticated
using (true);

drop policy if exists "amana_reviews_authenticated_insert" on public.reviews;
create policy "amana_reviews_authenticated_insert"
on public.reviews
for insert
to authenticated
with check (
  reviewer_id = auth.uid()
  and exists (
    select 1
    from public.services s
    where s.id = reviews.service_id
      and s.owner_id <> auth.uid()
  )
);
