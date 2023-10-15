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

--Função para listar os livros associados a um autor 
DELIMITER //
CREATE FUNCTION listar_livros_por_autor(primeiro_nome VARCHAR(255), ultimo_nome VARCHAR(255)) 
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
    DECLARE listliv VARCHAR(2000) DEFAULT '';
    DECLARE tlivro VARCHAR(255);
    DECLARE fim INT DEFAULT FALSE;

    DECLARE Caminho CURSOR FOR
        SELECT l.titulo
        FROM Livro l
        INNER JOIN Livro_Autor la ON l.id = la.id_livro
        INNER JOIN Autor a ON la.id_autor = a.id
        WHERE a.primeiro_nome = primeiro_nome AND a.ultimo_nome = ultimo_nome;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = TRUE;

    OPEN Caminho;

    read_loop: LOOP
        FETCH Caminho INTO tlivro;
        IF fim THEN
            LEAVE read_loop;
        END IF;

        SET listliv = CONCAT(listliv, tlivro, ', ');
    END LOOP;

    CLOSE Caminho;

    RETURN listliv;
END //

SELECT listar_livros_por_autor('Pedro', 'Alvares');



-- Função para atualizar os resumos dos livros
DELIMITER //
CREATE FUNCTION atualizar_resumos() 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE fim INT DEFAULT FALSE;
    DECLARE idliv INT;
    DECLARE resumoat VARCHAR(1000);
    DECLARE Caminho CURSOR FOR SELECT id, resumo FROM Livro;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = TRUE;

    OPEN Caminho;

    update_loop: LOOP
        FETCH Caminho INTO idliv, resumoat;

        IF fim THEN
            LEAVE update_loop;
        END IF;

        UPDATE Livro
        SET resumo = CONCAT(resumoat, ' Este é um excelente livro!')
        WHERE id = idliv;
       
    END LOOP;

    CLOSE Caminho;

    RETURN 1;
END //

SELECT atualizar_resumos();

-- Consulta para ver se a função atualizou os resumos
SELECT id, resumo FROM Livro;

-- Função para calcular a média de livros por editora
DELIMITER //
CREATE FUNCTION media_livros_por_editora() 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE media DECIMAL(10, 2);
    DECLARE totalliv INT;
    DECLARE totaledit INT;
    DECLARE numedit INT;
    DECLARE idedit INT;
    DECLARE fim INT DEFAULT FALSE;
    DECLARE Caminho_editora CURSOR FOR SELECT id FROM Editora;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = TRUE;

    SET totalliv = 0;
    SET numedit = 0;

    OPEN Caminho_editora;

    read_loop: LOOP
        FETCH Caminho_editora INTO idedit;
        IF fim THEN
            LEAVE read_loop;
        END IF;

        SELECT COUNT(*) INTO totaledit FROM Livro WHERE id_editora = idedit;

        SET totalliv = totalliv + totaledit;
        SET numedit = numedit + 1;
    END LOOP;

    CLOSE Caminho_editora;

    IF numedit = 0 THEN
        SET media = 0;
    ELSE
        SET media = totalliv / numedit;
    END IF;

    RETURN media;
END //

SELECT media_livros_por_editora();


-- Função para listar os autores sem livros
DELIMITER //
CREATE FUNCTION autores_sem_livros()
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE listautor TEXT DEFAULT '';
    DECLARE autorid INT;
    DECLARE autornome VARCHAR(255);
    DECLARE fim INT DEFAULT FALSE;

    DECLARE Caminhoautor CURSOR FOR
        SELECT id, CONCAT(primeiro_nome, ' ', ultimo_nome) AS nome
        FROM Autor;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = TRUE;

    OPEN Caminhoautor;

    read_loop: LOOP
        FETCH Caminhoautor INTO autorid, autornome;
        IF fim THEN
            LEAVE read_loop;
        END IF;

        IF NOT EXISTS (
            SELECT 1
            FROM Livro_Autor
            WHERE id_autor = autorid
        ) THEN
            SET listautor = CONCAT(listautor, ', ', autornome);
        END IF;
    END LOOP;

    CLOSE Caminhoautor;

    RETURN listautor;
END //
DELIMITER ;

SELECT autores_sem_livros();

