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