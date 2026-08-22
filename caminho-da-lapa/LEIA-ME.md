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

## Área do administrador

O app agora tem um botão discreto no topo (ícone de escudo, ao lado do "A+") que abre o login do administrador.

- **E-mail:** `redteb3@gmail.com`
- **Senha:** `fatinha123`

Esse login e senha ficam fixos dentro do `index.html` (constantes `ADMIN_EMAIL` e `ADMIN_PASSWORD`, perto do topo do arquivo). Se quiser trocar depois, é só editar essas duas linhas e publicar de novo.

Depois de logado (fica salvo neste navegador/celular até você clicar em "Sair"), o administrador pode:

- Ir até a aba **Comunidade** e apagar ou editar (legenda e local) **qualquer** foto publicada por qualquer romeiro, e apagar qualquer comentário — mesmo sem criar um perfil de romeiro.
- Abrir o painel do administrador (mesmo botão de escudo) e **adicionar novos itens** direto na aba **Explorar** (Turismo, Restaurantes, Hospedagem, Eventos ou Serviços), com nome e descrição. Esses itens ficam salvos no mesmo banco do Supabase e aparecem para todo mundo. Também é possível removê-los ali mesmo.

> Assim como o restante do app, essa "senha de administrador" é uma proteção simples (mostrada no botão, guardada no navegador) — boa o bastante para controlar quem edita o conteúdo dentro do grupo de romeiros, mas não é uma autenticação de nível bancário. Ela não aparece em nenhuma tela pública, só quando alguém clica no botão do escudo e digita o e-mail/senha corretos.

### Novidades desta versão

- **Clima em tempo real:** a faixa de clima no topo do app e a previsão de cada dia do roteiro agora vêm da API pública Open-Meteo (não precisa de chave/cadastro), atualizando a cada 15 minutos. Se a internet falhar, o app volta a mostrar uma estimativa padrão para não quebrar a experiência.
- **Itens do Explorar com foto e localização:** no painel do administrador, ao adicionar um item (Turismo, Restaurantes, Hospedagem, Eventos ou Serviços), agora dá pra preencher também **Localização** e enviar uma **Foto** do próprio computador/celular, além do nome e da descrição.
- **Foto de perfil de verdade:** em "Editar foto" (Comunidade), qualquer romeiro agora pode enviar uma foto do próprio aparelho como avatar, além das opções antigas de cor + emoji (que continuam disponíveis como alternativa).
- **Editar itens já existentes no Explorar:** o administrador agora vê um ícone de lápis em cada item das abas Turismo, Restaurantes, Hospedagem, Eventos e Serviços — inclusive os que já vinham prontos no app (Santuário, Gruta, hotéis, restaurantes etc). Ao clicar, dá pra alterar nome, localização, descrição e foto, e depois "Restaurar original" a qualquer momento caso queira desfazer.

### Limitações que valem saber
- O "login" da comunidade continua sendo simples (nome + senha guardados em texto no banco) — bom o bastante para um app informal, mas não é autenticação de verdade.
- Fotos são guardadas como imagem em base64 dentro do banco (perfis, publicações e itens do Explorar — limite de 4MB por foto). Funciona bem para uso moderado; se o app crescer muito, o ideal futuramente é migrar para o Supabase Storage (upload de arquivo de verdade).
- Os dados da comunidade são recarregados a cada 15 segundos (não é "tempo real" instantâneo, mas é suficiente para esse tipo de uso).
