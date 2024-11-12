/* Obtener todos los productos */
DELIMITER $$
DROP PROCEDURE IF EXISTS allProductos $$ 
CREATE PROCEDURE allProductos(
    OUT error INT
) 
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET error = 1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
       SELECT * FROM producto WHERE stock > 0;
    SET error = 0; 
    COMMIT;
END 
$$ 
DELIMITER ;


/* Obtener usuario por correo */
DELIMITER $$
DROP PROCEDURE IF EXISTS listarUsuarioPorCorreo $$ 
CREATE PROCEDURE listarUsuarioPorCorreo(
    IN email VARCHAR(255),
    OUT error INT
) 
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET error = 1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
        SELECT * FROM usuario WHERE correo = email;
    SET error = 0; 
    COMMIT;
END 
$$ 
DELIMITER ;


/* Obtener todos los productos con promoción mayor a uno */
DELIMITER $$
DROP PROCEDURE IF EXISTS productosPromocionMayorUno $$ 
CREATE PROCEDURE productosPromocionMayorUno(
    OUT error INT
) 
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET error = 1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
       SELECT * FROM producto WHERE promocion > 0;
    SET error = 0; 
    COMMIT;
END 
$$ 
DELIMITER ;
