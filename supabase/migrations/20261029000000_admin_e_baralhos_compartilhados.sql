-- =============================================================================
-- CardVoz - painel de administração e baralhos compartilhados
--
-- - "IsAdmin": quem pode entrar no painel (cardvoz-admin). Ninguém nasce admin;
--   o primeiro é definido pelo SQL Editor (veja o README) e os demais pelo painel.
-- - "Decks"."UserId" passa a aceitar nulo: baralho sem dono é um baralho
--   compartilhado, criado pelo painel. Como toda consulta da API filtra pelo
--   dono, ele não aparece na lista de ninguém; cada pessoa adiciona uma cópia.
--
-- Não apaga dados. Espelha o modelo do Entity Framework da cardvoz-api.
-- =============================================================================

ALTER TABLE "Users" ADD COLUMN "IsAdmin" boolean NOT NULL DEFAULT false;

ALTER TABLE "Decks" ALTER COLUMN "UserId" DROP NOT NULL;
