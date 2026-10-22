-- =============================================================================
-- CardVoz - login com Google
--
-- - "GoogleSubject" guarda o identificador da conta Google (claim "sub" do
--   id_token). É ele, e não o e-mail, que identifica a pessoa: o e-mail de uma
--   conta Google pode mudar, o "sub" não.
-- - "PasswordHash" passa a aceitar nulo: quem entra com o Google não tem senha.
--   As contas antigas, criadas com e-mail e senha, continuam funcionando.
--
-- Não apaga dados. Espelha o modelo do Entity Framework da cardvoz-api.
-- =============================================================================

ALTER TABLE "Users" ALTER COLUMN "PasswordHash" DROP NOT NULL;

ALTER TABLE "Users" ADD COLUMN "GoogleSubject" character varying(255);

CREATE UNIQUE INDEX "IX_Users_GoogleSubject" ON "Users" ("GoogleSubject");
