-- =============================================================================
-- CardVoz - painel de administração e baralhos compartilhados
--
-- - "IsAdmin": quem pode entrar no painel (cardvoz-admin). Ninguém nasce admin;
--   o primeiro é definido pelo SQL Editor (veja o README) e os demais pelo painel.
-- - "Decks"."UserId" passa a aceitar nulo: baralho sem dono é um baralho
--   compartilhado, criado pelo painel. Como toda consulta da API filtra pelo
--   dono, ele não aparece na lista de ninguém; cada pessoa adiciona uma cópia.
-- - "Decks"."SourceDeckId": de qual baralho compartilhado a cópia veio, para o
--   site mostrar "Já está nos seus baralhos". Excluir o compartilhado não
--   exclui as cópias (ON DELETE SET NULL).
--
-- Não apaga dados. Espelha o modelo do Entity Framework da cardvoz-api.
-- =============================================================================

ALTER TABLE "Users" ADD COLUMN "IsAdmin" boolean NOT NULL DEFAULT false;

ALTER TABLE "Decks" ALTER COLUMN "UserId" DROP NOT NULL;

ALTER TABLE "Decks" ADD COLUMN "SourceDeckId" uuid;

ALTER TABLE "Decks" ADD CONSTRAINT "FK_Decks_Decks_SourceDeckId"
    FOREIGN KEY ("SourceDeckId") REFERENCES "Decks" ("Id") ON DELETE SET NULL;

CREATE INDEX "IX_Decks_SourceDeckId" ON "Decks" ("SourceDeckId");
