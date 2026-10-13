-- =============================================================================
-- CardVoz - dados iniciais (4 baralhos de exemplo com 4 fichas cada)
--
-- Só insere se ainda não houver nenhum baralho, então rodar de novo não duplica.
-- =============================================================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM "Decks") THEN
    RETURN;
  END IF;

  INSERT INTO "Decks" ("Slug", "Title", "Category", "Description", "CreatedAt")
  VALUES
      ('biologia-celular', 'Biologia Celular', 'Ciências Biológicas', 'Estruturas celulares, organelas, respiração celular, fotossíntese e funções da membrana plasmática.', now()),
      ('ingles-verbos-irregulares', 'Inglês - Verbos Irregulares', 'Idiomas', 'Formas infinitivo, passado simples (Past Simple) e particípio passado (Past Participle) dos verbos mais usados.', now()),
      ('historia-do-brasil', 'História do Brasil - República Velha', 'Humanidades', 'Movimentos sociais, política do café com leite, revoltas populares e a transição para a Era Vargas.', now()),
      ('acessibilidade-web', 'Acessibilidade na Web & WCAG', 'Tecnologia', 'Critérios de conformidade WCAG 2.1 níveis A, AA e AAA, navegação por teclado e semântica WAI-ARIA.', now());

  INSERT INTO "Cards" ("DeckId", "DisplayOrder", "Question", "Answer", "VoiceNotes", "CreatedAt")
  SELECT d."Id", c.display_order, c.question, c.answer, c.voice_notes, now()
  FROM (
    VALUES
        ('biologia-celular', 1, 'Qual organela celular é responsável pela produção de energia (ATP) por meio da respiração celular?', 'A mitocôndria.', 'Dica: mitocôndria, respiração celular, ATP'),
        ('biologia-celular', 2, 'Qual estrutura delimita a célula e controla a entrada e saída de substâncias?', 'A membrana plasmática (ou plasmalema).', 'Dica: membrana plasmática ou plasmalema'),
        ('biologia-celular', 3, 'Qual organela é responsável pela síntese de proteínas nas células?', 'Os ribossomos.', 'Dica: ribossomos ou síntese proteica'),
        ('biologia-celular', 4, 'Qual organela realiza a fotossíntese nas células vegetais e algas?', 'Os cloroplastos.', 'Dica: cloroplasto ou fotossíntese'),
        ('ingles-verbos-irregulares', 1, 'Qual é o passado simples (Past Simple) e particípio de ''to go''?', 'Went (passado simples) e Gone (particípio).', 'Pronúncia: went, gone'),
        ('ingles-verbos-irregulares', 2, 'Qual é o passado simples e particípio de ''to write''?', 'Wrote (passado simples) e Written (particípio).', 'Pronúncia: wrote, written'),
        ('ingles-verbos-irregulares', 3, 'Qual é o passado simples e particípio de ''to see''?', 'Saw (passado simples) e Seen (particípio).', 'Pronúncia: saw, seen'),
        ('ingles-verbos-irregulares', 4, 'Qual é o passado simples e particípio de ''to take''?', 'Took (passado simples) e Taken (particípio).', 'Pronúncia: took, taken'),
        ('historia-do-brasil', 1, 'O que caracterizou a chamada ''Política do Café com Leite'' na República Velha?', 'A alternância na presidência da República entre as oligarquias de São Paulo (produtores de café) e Minas Gerais (produtores de leite).', 'Dica: alternância entre oligarquias paulista e mineira'),
        ('historia-do-brasil', 2, 'Qual movimento popular messiânico ocorreu no sertão da Bahia entre 1896 e 1897?', 'A Guerra de Canudos, liderada por Antônio Conselheiro.', 'Dica: Canudos ou Antônio Conselheiro'),
        ('historia-do-brasil', 3, 'O que motivou a Revolta da Vacina em 1904 no Rio de Janeiro?', 'A obrigatoriedade da vacinação contra a varíola imposta pelo governo de Rodrigues Alves e liderada sanitariamente por Oswaldo Cruz.', 'Dica: vacina obrigatória contra varíola, Oswaldo Cruz'),
        ('historia-do-brasil', 4, 'Qual movimento dos jovens oficiais militares na década de 1920 contestou as oligarquias da Primeira República?', 'O Tenentismo (com episódios como os 18 do Forte e a Coluna Prestes).', 'Dica: Tenentismo ou movimento tenentista'),
        ('acessibilidade-web', 1, 'Quais são os quatro princípios fundamentais das Diretrizes de Acessibilidade para Conteúdo Web (WCAG)?', 'Perceptível, Operável, Compreensível e Robusto (POUR: Perceivable, Operable, Understandable, Robust).', 'Dica: Princípios POUR: Perceptível, Operável, Compreensível, Robusto'),
        ('acessibilidade-web', 2, 'Qual é a taxa mínima de contraste de cores recomendada pela WCAG 2.1 no nível AA para texto normal?', 'Uma proporção de contraste de pelo menos 4.5:1 (ou 3:1 para texto em escala grande).', 'Dica: proporção de 4,5 para 1'),
        ('acessibilidade-web', 3, 'Qual atributo HTML/ARIA deve ser utilizado para identificar o papel semântico de um elemento personalizado para tecnologias assistivas?', 'O atributo ''role'' (por exemplo, role=''button'', role=''dialog'').', 'Dica: atributo role'),
        ('acessibilidade-web', 4, 'Qual mecanismo de acessibilidade permite que usuários navegando via teclado pulem diretamente para o conteúdo principal da página?', 'O Skip Link (ou link de atalho de navegação).', 'Dica: Skip Link ou link de atalho')
  ) AS c (slug, display_order, question, answer, voice_notes)
  JOIN "Decks" AS d ON d."Slug" = c.slug;
END
$$;
