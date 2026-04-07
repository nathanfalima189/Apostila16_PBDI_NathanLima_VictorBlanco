-- 1.1 Escreva um cursor que exiba as variáveis rank e youtuber de toda tupla que tiver video_count pelo menos igual a 1000 e cuja category seja igual a Sports ou Music.

-- Resposta com cursor vinculado
DO $$
DECLARE
    cur_channels CURSOR FOR
        SELECT rank, youtuber
        FROM  tb_top_youtubers
        WHERE video_count >= 1000
          AND category IN ('Sports', 'Music');
    
    v_rank INT;
    v_youtuber TEXT;
BEGIN
    OPEN cur_channels;

    LOOP
        FETCH cur_channels INTO v_rank, v_youtuber;
        EXIT WHEN NOT FOUND;

        RAISE NOTICE 'Rank: %, Youtuber: %', v_rank, v_youtuber;
    END LOOP;

    CLOSE cur_channels;
END $$;

-- resposta com cursor naovinculado
DO $$
DECLARE
    ref refcursor;
    v_rank INT;
    v_youtuber TEXT;
BEGIN
    OPEN ref FOR
        SELECT rank, youtuber
        FROM  tb_top_youtubers
        WHERE video_count >= 1000
          AND category IN ('Sports', 'Music');

    LOOP
        FETCH ref INTO v_rank, v_youtuber;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Rank: %, Youtuber: %', v_rank, v_youtuber;
    END LOOP;

    CLOSE ref;
END $$;


-- 1.2 Escreva um cursor que exibe todos os nomes dos youtubers em ordem reversa

-- resposta com cursor vinculado
DO $$
DECLARE
    cur_reverse CURSOR FOR
        SELECT youtuber
        FROM  tb_top_youtubers
        ORDER BY youtuber ASC;
    
    v_youtuber TEXT;
BEGIN
    OPEN cur_reverse;

    FETCH LAST FROM cur_reverse INTO v_youtuber;

    WHILE FOUND LOOP
        RAISE NOTICE 'Youtuber: %', v_youtuber;

        FETCH PRIOR FROM cur_reverse INTO v_youtuber;
    END LOOP;

    CLOSE cur_reverse;
END $$;

-- resposta com cursor nao vinculado
DO $$
DECLARE
    ref refcursor;
    v_youtuber TEXT;
BEGIN
    OPEN ref SCROLL FOR
        SELECT youtuber
        FROM  tb_top_youtubers
        ORDER BY youtuber ASC;

    FETCH LAST FROM ref INTO v_youtuber;

    WHILE FOUND LOOP
        RAISE NOTICE 'Youtuber: %', v_youtuber;
        FETCH PRIOR FROM ref INTO v_youtuber;
    END LOOP;

    CLOSE ref;
END $$;


-- 1.3 Faça uma pesquisa sobre o anti-pattern chamado RBAR - Row By Agonizing Row. Explique com suas palavras do que se trata.

-- RBAR (Row-By-Agonizing-Row) é um anti-padrão em bancos de dados que ocorre quando você processa os dados linha por linha, geralmente com cursores ou loops, ao invés de usar comandos que manipulam conjuntos de dados.

-- Problemas principais:

-- Mais lento e ineficiente
-- Usa mais memória e CPU
-- Não aproveita a otimização do SQL

-- Exemplo de RBAR (em PL/pgSQL):
DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN SELECT id FROM users LOOP
        UPDATE users SET active = TRUE WHERE id = rec.id;
    END LOOP;
END $$;

-- Forma ideal:
UPDATE users SET active = TRUE;