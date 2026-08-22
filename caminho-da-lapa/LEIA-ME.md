# Caminho da Lapa — colocando no ar (Vercel + Supabase)

Esta pasta tem 4 arquivos:
- `index.html` — o app (front-end)
- `api/chat.js` — backend do chat com IA (roda no servidor, esconde a chave da Anthropic)
- `supabase-setup.sql` — script para criar o banco de dados compartilhado (perfis e posts da comunidade)
- `vercel.json` — configuração do deploy

## Passo 1 — Criar o banco no Supabase (5 min)

1. Crie uma conta grátis em https://supabase.com e clique em **New project**.
2. Escolha um nome, uma senha de banco (guarde ela, mas não vai precisar usar direto) e a região mais perto do Brasil.
3. Depois que o projeto for criado, vá em **SQL Editor** (menu lateral) > **New query**.
4. Cole todo o conteúdo do arquivo `supabase-setup.sql` e clique em **Run**.
5. Vá em **Project Settings** (ícone de engrenagem) > **API**. Copie dois valores:
   - **Project URL**
   - **anon public key**

## Passo 2 — Colar as chaves do Supabase no app

1. Abra `index.html`.
2. Procure por `COLE_AQUI_A_URL_DO_SEU_PROJETO_SUPABASE` e troque pela **Project URL**.
3. Procure por `COLE_AQUI_A_ANON_KEY_DO_SEU_PROJETO_SUPABASE` e troque pela **anon public key**.
4. Salve o arquivo.

> A anon key é feita para ser pública (fica visível no navegador de qualquer visitante) — a proteção real vem das regras que criamos no banco (`supabase-setup.sql`). Isso é normal e seguro para esse tipo de app.

## Passo 3 — Pegar uma chave da Anthropic (para o chat com IA)

1. Crie uma conta em https://console.anthropic.com
2. Vá em **API Keys** > **Create Key**.
3. Copie a chave (começa com `sk-ant-...`). Guarde-a — você vai colar no Vercel, nunca no `index.html`.

*(Se preferir lançar o app sem o chat de IA por enquanto, pode pular este passo — o app já tem um fallback que responde com informações locais quando a IA não está disponível.)*

## Passo 4 — Deploy no Vercel (5 min)

1. Crie uma conta grátis em https://vercel.com (pode entrar com GitHub).
2. **Forma mais simples (sem usar GitHub):**
   - Instale a CLI: no seu computador, rode `npm i -g vercel`
   - Dentro desta pasta, rode `vercel` e siga as perguntas (aceite as opções padrão).
   - Ao final, rode `vercel --prod` para publicar em definitivo.
3. **Forma recomendada (com GitHub, permite atualizar depois só dando push):**
   - Suba esta pasta para um repositório novo no GitHub.
   - No Vercel, clique em **Add New > Project**, escolha o repositório.
   - Clique em **Deploy** (não precisa mudar nenhuma configuração de build).

## Passo 5 — Configurar a chave da Anthropic no Vercel

1. No painel do projeto no Vercel, vá em **Settings > Environment Variables**.
2. Adicione:
   - Nome: `ANTHROPIC_API_KEY`
   - Valor: a chave `sk-ant-...` que você copiou no Passo 3
3. Vá em **Deployments**, clique nos "..." do último deploy e escolha **Redeploy** (para a variável entrar em vigor).

## Passo 6 — Testar

1. Abra a URL que o Vercel te deu (algo como `caminho-da-lapa.vercel.app`).
2. Teste: criar um perfil na Comunidade, publicar uma foto, e conversar no chat.
3. Abra a mesma URL em outro celular/navegador e confirme que os posts da comunidade aparecem para os dois (prova de que já não é mais só localStorage).

## Passo 7 (opcional) — Domínio próprio

Em **Settings > Domains** no Vercel, dá pra apontar um domínio próprio (ex: `caminhodalapa.com.br`) seguindo as instruções de DNS que eles mostram.

---

### Limitações que valem saber
- O "login" da comunidade continua sendo simples (nome + senha guardados em texto no banco) — bom o bastante para um app informal, mas não é autenticação de verdade.
- Fotos são guardadas como imagem em base64 dentro do banco. Funciona bem para uso moderado; se o app crescer muito, o ideal futuramente é migrar para o Supabase Storage (upload de arquivo de verdade).
- Os dados da comunidade são recarregados a cada 15 segundos (não é "tempo real" instantâneo, mas é suficiente para esse tipo de uso).
