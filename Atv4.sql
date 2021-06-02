DELIMITER $$

CREATE TRIGGER tri_vendas_ai

AFTER INSERT ON comivenda

FOR EACH ROW

BEGIN

	DECLARE qtdItem INT DEFAULT 0;
    DECLARE Continuar Tinyint DEFAULT 0;
	DECLARE vtotal_itens FLOAT(10,2) DEFAULT 0; 
    DECLARE vtotal_item FLOAT(10,2);
    DECLARE total_item FLOAT(10,2) DEFAULT 0; 

    DECLARE busca_itens CURSOR FOR

		SELECT n_valoivenda, n_qtdeivenda
			FROM comivenda
				WHERE n_numevenda = NEW.n_numevenda;

    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET Continuar = 1;
    
OPEN busca_itens;

itens : LOOP
	
	IF Continuar = 1 THEN

	LEAVE itens;

	END IF;
	
	FETCH busca_itens INTO total_item, qtdItem;
		SET vtotal_itens = vtotal_itens + (total_item * qtdItem);
		
END LOOP itens;  

CLOSE busca_itens;

UPDATE comvenda 
	SET n_totavenda = vtotal_itens - (NEW.n_valoivenda * NEW.n_qtdeivenda)
		WHERE n_numevenda = NEW.n_numevenda;

END $$

DELIMITER ;