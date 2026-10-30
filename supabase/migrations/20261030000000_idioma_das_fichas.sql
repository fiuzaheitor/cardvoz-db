-- =============================================================================
-- CardVoz - idioma das fichas
--
-- Num baralho de inglês ou espanhol, o site marca as perguntas e as respostas
-- com o atributo lang, e o leitor de tela (TalkBack, NVDA) troca a voz para
-- pronunciar corretamente.
--
-- - "QuestionLanguage" e "AnswerLanguage": código do idioma (ex.: 'en', 'es',
--   'pt-BR'). Nulo = português, o idioma padrão.
-- - A checagem aceita só códigos de idioma: o valor vai para um atributo HTML.
--
-- Não apaga dados: os baralhos que já existem ficam com os dois campos nulos.
-- Espelha o modelo do Entity Framework da cardvoz-api
-- (tarefa em cardvoz-api/docs/tarefas/idioma-das-fichas.md).
-- =============================================================================

ALTER TABLE "Decks" ADD COLUMN "QuestionLanguage" character varying(10);

ALTER TABLE "Decks" ADD COLUMN "AnswerLanguage" character varying(10);

ALTER TABLE "Decks" ADD CONSTRAINT "CK_Decks_QuestionLanguage"
  CHECK ("QuestionLanguage" IS NULL OR "QuestionLanguage" ~ '^[a-z]{2,3}(-[A-Z]{2})?$');

ALTER TABLE "Decks" ADD CONSTRAINT "CK_Decks_AnswerLanguage"
  CHECK ("AnswerLanguage" IS NULL OR "AnswerLanguage" ~ '^[a-z]{2,3}(-[A-Z]{2})?$');
