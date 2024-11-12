-- CRUD productos

-- 1:Insertar

/* Insertar producto */
DELIMITER $$
DROP PROCEDURE IF EXISTS crearProducto $$ 
CREATE PROCEDURE crearProducto(
    IN Pbarras VARCHAR(20),
    IN Pnombre VARCHAR(20),
    IN Pimagen TEXT,
    IN Pstock INT,
    IN Pdescripcion TEXT,
    IN Pprecio DECIMAL(10,2),
    IN Ptipo VARCHAR(50),
    IN Ppromocion INT,
    OUT error INT
) 
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET error = 1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
        INSERT INTO producto (
                codigo_barras,
                nombre,
                imagen,
                stock,
                descripcion,
                precio,
                tipo,
                promocion
            )
        VALUES (
                Pbarras,
                Pnombre,
                Pimagen,
                Pstock,
                Pdescripcion,
                Pprecio,
                Ptipo,
                Ppromocion
            );
    SET error = 0;
    COMMIT;
END 
$$ 
DELIMITER ;

-- 2:Borrar

DELIMITER $$
DROP PROCEDURE IF EXISTS borrarProducto $$ 
CREATE PROCEDURE borrarProducto(
    IN Pbarras VARCHAR(20),
    OUT error INT
) 
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET error = 1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
        DELETE FROM producto
        WHERE codigo_barras = Pbarras;
    SET error = 0;
    COMMIT;
END 
$$ 
DELIMITER ;

-- 3:Actualizar

/* Actualizar producto con imagen */
DELIMITER $$
DROP PROCEDURE IF EXISTS actualizarProductoConImagen $$ 
CREATE PROCEDURE actualizarProductoConImagen(
    IN Pbarras VARCHAR(20),
    IN Pnombre VARCHAR(20),
    IN Pimagen TEXT,
    IN Pstock INT,
    IN Pdescripcion TEXT,
    IN Pprecio DECIMAL(10,2),
    IN Ptipo VARCHAR(50),
    IN Ppromocion INT,
    OUT error INT
) 
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET error = 1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
        UPDATE producto
        SET codigo_barras = Pbarras,
                nombre = Pnombre,
                imagen = Pimagen,
                stock =  Pstock,
                descripcion =  Pdescripcion,
                precio =   Pprecio,
                tipo =   Ptipo,
                promocion = Ppromocion
        WHERE  codigo_barras = Pbarras;
    SET error = 0; 
    COMMIT;
END 
$$ 
DELIMITER ;

/* Actualizar producto sin imagen */

DELIMITER $$
DROP PROCEDURE IF EXISTS actualizarProductoSinImagen $$ 
CREATE PROCEDURE actualizarProductoSinImagen(
    IN Pbarras VARCHAR(20),
    IN Pnombre VARCHAR(20),
    IN Pstock INT,
    IN Pdescripcion TEXT,
    IN Pprecio DECIMAL(10,2),
    IN Ptipo VARCHAR(50),
    IN Ppromocion INT,
    OUT error INT
) 
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET error = 1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
        UPDATE producto
        SET codigo_barras = Pbarras,
                nombre = Pnombre,
                stock =  Pstock,
                descripcion =  Pdescripcion,
                precio =   Pprecio,
                tipo =   Ptipo,
                promocion = Ppromocion
        WHERE  codigo_barras = Pbarras;
    SET error = 0; 
    COMMIT;
END 
$$ 
DELIMITER ;
