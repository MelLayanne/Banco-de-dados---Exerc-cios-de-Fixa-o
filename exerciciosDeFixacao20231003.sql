-- Função para contar o número de livros por gênero
DELIMITER //
CREATE FUNCTION total_livros_por_genero(genero_nome VARCHAR(255)) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE fim INT DEFAULT FALSE;
    DECLARE totalliv INT;
    DECLARE id_genero INT;
    DECLARE Caminho CURSOR FOR SELECT id FROM Genero WHERE nome_genero = genero_nome;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = TRUE;

    SET totalliv = 0;

    OPEN Caminho;

    read_loop: LOOP
        FETCH Caminho INTO id_genero;

        IF fim THEN
            LEAVE read_loop;
        END IF;

        SELECT COUNT(*) INTO totalliv FROM Livro WHERE Livro.id_genero = id_genero;
         END LOOP;

    CLOSE Caminho;
    RETURN totalliv;
    
END //

SELECT total_livros_por_genero('História');
