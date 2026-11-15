-- AMANA: allow a service owner to remove reviews and reports attached to their own service.
-- Run this once in Supabase > SQL Editor > New query.

 drop policy if exists "service_owners_delete_reviews" on public.reviews;
create policy "service_owners_delete_reviews"
on public.reviews
for delete
to authenticated
using (
  exists (
    select 1 from public.services s
    where s.id = reviews.service_id
      and s.owner_id = auth.uid()
  )
);

drop policy if exists "service_owners_select_reports" on public.reports;
create policy "service_owners_select_reports"
on public.reports
for select
to authenticated
using (
  exists (
    select 1 from public.services s
    where s.id = reports.service_id
      and s.owner_id = auth.uid()
  )
);

drop policy if exists "service_owners_delete_reports" on public.reports;
create policy "service_owners_delete_reports"
on public.reports
for delete
to authenticated
using (
  exists (
    select 1 from public.services s
    where s.id = reports.service_id
      and s.owner_id = auth.uid()
  )
);
