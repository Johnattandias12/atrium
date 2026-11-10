-- Atrium: personal_tasks fora da publicacao do Realtime (detectado em 10/11/2026).
-- Sintoma: o canal 'atrium-rt' recebe "Unable to subscribe to changes ... table: personal_tasks".
-- Efeito: o Painel Pessoal nao atualiza em tempo real entre abas/aparelhos. Nao causa o "piscar".
-- Idempotente. NAO aplicado; rodar no SQL Editor do projeto twvnbqvpknacobmkedth.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'personal_tasks'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.personal_tasks;
  END IF;
END $$;
