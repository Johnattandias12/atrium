-- Atrium: Painel Pessoal por area da vida, lista de compras com valor e status kanban (10/11/2026).
-- Aditiva e idempotente: so adiciona colunas e checks, nao apaga nada. Pode rodar mais de uma vez.
-- Projeto Supabase twvnbqvpknacobmkedth.

alter table public.personal_tasks add column if not exists area   text not null default 'pessoal';
alter table public.personal_tasks add column if not exists amount numeric(10,2);
alter table public.personal_tasks add column if not exists status text not null default 'todo';

do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'personal_tasks_area_check') then
    alter table public.personal_tasks add constraint personal_tasks_area_check
      check (area in ('ufrn','trabalho','pessoal','saude','compras'));
  end if;
  if not exists (select 1 from pg_constraint where conname = 'personal_tasks_status_check') then
    alter table public.personal_tasks add constraint personal_tasks_status_check
      check (status in ('todo','doing','done'));
  end if;
end $$;

-- done continua valendo; status acompanha (o app mantem os dois sincronizados).
update public.personal_tasks set status = 'done' where done = true and status <> 'done';

-- Realtime: o app assina cards, profiles, comments e personal_tasks no canal 'atrium-rt',
-- mas a publicacao supabase_realtime estava vazia ("Unable to subscribe to changes").
-- Inclui a correcao de fix-schema 2026-11-10.sql (personal_tasks) e as demais tabelas assinadas.
do $$
declare t text;
begin
  foreach t in array array['personal_tasks','cards','profiles','comments'] loop
    if to_regclass('public.' || t) is not null and not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t
    ) then
      execute format('alter publication supabase_realtime add table public.%I', t);
    end if;
  end loop;
end $$;
