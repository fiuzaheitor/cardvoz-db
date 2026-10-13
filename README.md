# CardVoz — Banco de Dados (Supabase)

Esquema e dados iniciais do banco PostgreSQL do CardVoz, versionados como migrations do [Supabase CLI](https://supabase.com/docs/guides/cli).

Este repositório é a **fonte da verdade do banco**: a [`cardvoz-api`](../cardvoz-api) só se conecta e não cria tabelas. Toda mudança de esquema entra aqui como uma nova migration.

## Estrutura

```
supabase/
├── config.toml                                  # Configuração do Supabase CLI
├── migrations/
│   └── 20261012000000_schema_inicial.sql        # Tabelas, índices e segurança (RLS)
└── seed.sql                                     # 4 baralhos de exemplo com 4 fichas cada
```

### Tabelas

| Tabela | Conteúdo |
|---|---|
| `"Decks"` | Baralhos (título, categoria, descrição, slug único) |
| `"Cards"` | Fichas de cada baralho (pergunta, resposta, ordem) |
| `"StudySessions"` | Sessões de estudo (acertos, erros, início e fim) |
| `"StudyReviews"` | Cada resposta dada numa sessão |

Os nomes seguem o padrão do Entity Framework da API (PascalCase), então no SQL Editor do Supabase precisam de aspas: `SELECT * FROM "Decks";`

## Segurança

O Supabase publica automaticamente o esquema `public` numa API REST acessível pela chave pública `anon`. Para que os dados só sejam acessados pela `cardvoz-api`:

- **RLS ativo** em todas as tabelas, sem nenhuma política;
- **permissões revogadas** dos papéis `anon` e `authenticated`.

A `cardvoz-api` conecta com o usuário `postgres`, dono das tabelas, e por isso não é afetada pelo RLS.

## Como aplicar no Supabase

Pré-requisito: [Node.js](https://nodejs.org) (o CLI roda via `npx`, sem instalar nada).

```bash
# 1. Entrar na sua conta do Supabase (abre o navegador)
npx supabase login

# 2. Ligar este repositório ao seu projeto
#    (o "Reference ID" fica em Project Settings → General)
npx supabase link --project-ref <reference-id>

# 3. Primeira vez: cria as tabelas e insere os baralhos de exemplo
npx supabase db push --include-seed
```

Depois disso, a cada nova migration basta rodar `npx supabase db push`. O seed é seguro para rodar de novo: ele só insere dados se ainda não houver nenhum baralho.

## Conectar a API

No painel do Supabase, clique em **Connect → Session pooler** e copie a URI (porta 5432). Na `cardvoz-api`, coloque-a na variável `ConnectionStrings__DefaultConnection`, trocando `[YOUR-PASSWORD]` pela senha do banco.

- Use o **pooler**, não a conexão direta: a conexão direta do plano gratuito só funciona por IPv6, que hospedagens como o Render não suportam.
- Prefira uma senha só com letras e números: caracteres como `@`, `#` e `/` quebram a URI (ou precisam ser codificados, ex.: `@` → `%40`).

## Criar uma nova migration

```bash
npx supabase migration new nome_da_mudanca
```

Edite o arquivo criado em `supabase/migrations/` e aplique com `npx supabase db push`.

As tabelas precisam continuar batendo com o modelo do Entity Framework da `cardvoz-api`. Para ver o SQL que o modelo atual espera, rode na pasta da API:

```bash
dotnet tool install --global dotnet-ef
ConnectionStrings__DefaultConnection="Host=localhost" dotnet ef dbcontext script
```
