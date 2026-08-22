-- Rode este script inteiro no Supabase: Project > SQL Editor > New query > Run

-- Tabela única de "armazenamento chave-valor" compartilhado.
-- Guarda os perfis (lapa_community_users) e as publicações (lapa_community_posts)
-- como um blob JSON cada, no mesmo formato que o app já usava no localStorage.
create table if not exists app_kv (
  key text primary key,
  value jsonb not null,
  updated_at timestamptz default now()
);

-- Ativa Row Level Security (obrigatório no Supabase para liberar acesso via anon key)
alter table app_kv enable row level security;

-- Libera leitura e escrita pública nessa tabela.
-- IMPORTANTE: assim como no app original, o "login" (nome + senha) é só um
-- cadastro simples para identificar quem postou o quê — NÃO é uma autenticação
-- segura. Qualquer pessoa com a anon key consegue ler/escrever esses dados.
-- Isso é aceitável para um guia comunitário informal, mas não deve ser usado
-- para dados sensíveis. Se um dia quiser autenticação de verdade, dá pra migrar
-- para o Supabase Auth.
create policy "leitura publica" on app_kv for select using (true);
create policy "escrita publica" on app_kv for insert with check (true);
create policy "atualizacao publica" on app_kv for update using (true);
