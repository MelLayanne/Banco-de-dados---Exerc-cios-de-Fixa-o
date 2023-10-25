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

