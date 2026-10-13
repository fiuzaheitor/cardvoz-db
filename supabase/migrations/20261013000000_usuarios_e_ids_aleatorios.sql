-- =============================================================================
-- CardVoz - usuários, login e IDs aleatórios
--
-- - Contas de usuário (senha guardada só como hash) e tokens de renovação de
--   sessão (guardados só como hash SHA-256).
-- - Cada baralho passa a ter dono; fichas e sessões pertencem ao dono do baralho.
-- - Todos os IDs passam a ser UUID v4 aleatórios, em vez de números sequenciais
--   que permitiam adivinhar e varrer registros.
--
-- ATENÇÃO: recria as tabelas do esquema inicial. Os dados antigos (inclusive os
-- baralhos de exemplo, que não tinham dono) são apagados.
--
-- Espelha o modelo do Entity Framework da cardvoz-api (nomes em PascalCase).
-- =============================================================================

DROP TABLE IF EXISTS "StudyReviews", "StudySessions", "Cards", "Decks" CASCADE;

CREATE TABLE "Users" (
    "Id" uuid NOT NULL DEFAULT gen_random_uuid(),
    "Name" character varying(100) NOT NULL,
    "Email" character varying(254) NOT NULL,
    "PasswordHash" text NOT NULL,
    "FailedLoginCount" integer NOT NULL DEFAULT 0,
    "LockoutEnd" timestamp with time zone,
    "CreatedAt" timestamp with time zone NOT NULL,
    "UpdatedAt" timestamp with time zone,
    CONSTRAINT "PK_Users" PRIMARY KEY ("Id"),
    -- A API grava o e-mail em minúsculas; a regra impede burlar a unicidade com maiúsculas
    CONSTRAINT "CK_Users_Email_Minusculo" CHECK ("Email" = lower("Email"))
);

CREATE TABLE "Decks" (
    "Id" uuid NOT NULL DEFAULT gen_random_uuid(),
    "UserId" uuid NOT NULL,
    "Slug" character varying(150) NOT NULL,
    "Title" character varying(200) NOT NULL,
    "Category" character varying(100) NOT NULL,
    "Description" character varying(1000),
    "CreatedAt" timestamp with time zone NOT NULL,
    "UpdatedAt" timestamp with time zone,
    CONSTRAINT "PK_Decks" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Decks_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "RefreshTokens" (
    "Id" uuid NOT NULL DEFAULT gen_random_uuid(),
    "UserId" uuid NOT NULL,
    "TokenHash" character varying(64) NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    "ExpiresAt" timestamp with time zone NOT NULL,
    "RevokedAt" timestamp with time zone,
    "ReplacedByTokenId" uuid,
    CONSTRAINT "PK_RefreshTokens" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_RefreshTokens_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Cards" (
    "Id" uuid NOT NULL DEFAULT gen_random_uuid(),
    "DeckId" uuid NOT NULL,
    "Question" text NOT NULL,
    "Answer" text NOT NULL,
    "VoiceNotes" character varying(500),
    "DisplayOrder" integer NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Cards" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Cards_Decks_DeckId" FOREIGN KEY ("DeckId") REFERENCES "Decks" ("Id") ON DELETE CASCADE
);

CREATE TABLE "StudySessions" (
    "Id" uuid NOT NULL DEFAULT gen_random_uuid(),
    "DeckId" uuid NOT NULL,
    "StartedAt" timestamp with time zone NOT NULL,
    "CompletedAt" timestamp with time zone,
    "TotalCards" integer NOT NULL,
    "CorrectCount" integer NOT NULL,
    "IncorrectCount" integer NOT NULL,
    CONSTRAINT "PK_StudySessions" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_StudySessions_Decks_DeckId" FOREIGN KEY ("DeckId") REFERENCES "Decks" ("Id") ON DELETE CASCADE
);

CREATE TABLE "StudyReviews" (
    "Id" uuid NOT NULL DEFAULT gen_random_uuid(),
    "StudySessionId" uuid NOT NULL,
    "CardId" uuid NOT NULL,
    "WasCorrect" boolean NOT NULL,
    "VoiceUsed" boolean NOT NULL,
    "AnsweredAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_StudyReviews" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_StudyReviews_Cards_CardId" FOREIGN KEY ("CardId") REFERENCES "Cards" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_StudyReviews_StudySessions_StudySessionId" FOREIGN KEY ("StudySessionId") REFERENCES "StudySessions" ("Id") ON DELETE CASCADE
);

CREATE INDEX "IX_Cards_DeckId" ON "Cards" ("DeckId");

CREATE UNIQUE INDEX "IX_Decks_UserId_Slug" ON "Decks" ("UserId", "Slug");

CREATE UNIQUE INDEX "IX_RefreshTokens_TokenHash" ON "RefreshTokens" ("TokenHash");

CREATE INDEX "IX_RefreshTokens_UserId" ON "RefreshTokens" ("UserId");

CREATE INDEX "IX_StudyReviews_CardId" ON "StudyReviews" ("CardId");

CREATE INDEX "IX_StudyReviews_StudySessionId" ON "StudyReviews" ("StudySessionId");

CREATE INDEX "IX_StudySessions_DeckId" ON "StudySessions" ("DeckId");

CREATE UNIQUE INDEX "IX_Users_Email" ON "Users" ("Email");

-- =============================================================================
-- Segurança
--
-- O Supabase expõe o esquema public pela API REST automática (papéis anon e
-- authenticated). Os dados — principalmente os hashes de senha em "Users" — só
-- devem ser acessados pela cardvoz-api, que conecta como dona das tabelas e por
-- isso não é afetada pelo RLS. Com RLS ativo, sem políticas, e sem permissões
-- para esses papéis, a API REST automática não lê nem altera nada.
-- =============================================================================

ALTER TABLE "Users" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "RefreshTokens" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Decks" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Cards" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "StudySessions" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "StudyReviews" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "Users", "RefreshTokens", "Decks", "Cards", "StudySessions", "StudyReviews" FROM anon, authenticated;
