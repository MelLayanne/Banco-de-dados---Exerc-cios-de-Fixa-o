exerciciosDeFixacao20231024.sql

DELIMITER //
CREATE TRIGGER Mgm_clientes
AFTER INSERT ON Clientes
FOR EACH ROW
BEGIN
    DECLARE mensagem TEXT;
    SET mensagem = 'Cliente adicionado dia: ';
    SET mensagem = CONCAT(mensagem, NOW());
    INSERT INTO Auditoria (mensagem) VALUES (mensagem);
END;
//
DELIMITER ;

INSERT INTO Clientes VALUES (4,'Jonas');
SELECT * FROM Auditoria;

DELIMITER //
CREATE TRIGGER delete_clientes
BEFORE DELETE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Tentou excluir cliente em ', NOW()));
END;
//
DELIMITER ;

DELETE FROM Clientes WHERE id = 4;
SELECT * FROM Auditoria;

DELIMITER //
CREATE TRIGGER atualiza_clientes
AFTER UPDATE ON Clientes
FOR EACH ROW
BEGIN
    IF OLD.nome != NEW.nome THEN
        INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Atualização do cliente de"', OLD.nome, '" para "', NEW.nome, '" em ', NOW()));
    END IF;
END;
//
DELIMITER ;


insert into Clientes values (2,'Joao');
UPDATE Clientes
SET nome = 'Melissa'
WHERE id = 2;
SELECT * FROM Auditoria;
