/* DELIMITER $$

DROP PROCEDURE IF EXISTS consultarUsuarios $$

CREATE PROCEDURE consultarUsuarios()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE Ucedula VARCHAR(20);
    DECLARE Unombre VARCHAR(100);
    
    DECLARE user_cursor CURSOR FOR 
        SELECT cedula, nombre FROM usuario;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN user_cursor;

    read_loop: LOOP
        FETCH user_cursor INTO Ucedula, Unombre;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Aquí puedes agregar lógica adicional, como imprimir o almacenar en otra tabla.
        SELECT Ucedula, Unombre;  -- Ejemplo de salida
    END LOOP;

    CLOSE user_cursor;
END $$

DELIMITER ;
 */



DELIMITER $$
DROP PROCEDURE IF EXISTS obtener_log_papeleria$$
CREATE PROCEDURE obtener_log_papeleria()
BEGIN
    SELECT * FROM log_papeleria
    ORDER BY id_auditoria DESC;
END $$

DELIMITER ;