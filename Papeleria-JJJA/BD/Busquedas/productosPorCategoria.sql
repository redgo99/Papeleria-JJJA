DELIMITER $$
DROP PROCEDURE IF EXISTS buscarProductosPorCategoria$$
CREATE PROCEDURE buscarProductosPorCategoria(
    IN tipo_producto VARCHAR(50),
    OUT error INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE prod_codigo_barras VARCHAR(20);
    DECLARE prod_nombre VARCHAR(20);
    DECLARE prod_imagen TEXT;
    DECLARE prod_stock INT;
    DECLARE prod_descripcion TEXT;
    DECLARE prod_precio DECIMAL(10, 2);
    DECLARE prod_tipo VARCHAR(50);
    DECLARE prod_promocion INT;

    DECLARE cur_producto CURSOR FOR 
        SELECT * FROM producto 
        WHERE tipo = tipo_producto;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET error = 1;
        ROLLBACK;
    END;

    /* Crear una tabla temporal para almacenar los resultados */
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_productos (
        codigo_barras VARCHAR(20),
        nombre VARCHAR(20),
        imagen TEXT,
        stock INT,
        descripcion TEXT,
        precio DECIMAL(10, 2),
        tipo VARCHAR(50),
        promocion INT
    );

    START TRANSACTION;
    
    -- Abrir el cursor
    OPEN cur_producto;

    -- Leer los resultados del cursor
    read_loop: LOOP
        FETCH cur_producto INTO prod_codigo_barras, prod_nombre, prod_imagen, prod_stock, prod_descripcion, prod_precio, prod_tipo, prod_promocion;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Insertar los resultados en la tabla temporal
        INSERT INTO temp_productos (codigo_barras, nombre, imagen, stock, descripcion, precio, tipo, promocion)
        VALUES (prod_codigo_barras, prod_nombre, prod_imagen, prod_stock, prod_descripcion, prod_precio, prod_tipo, prod_promocion);
    END LOOP;

    -- Cerrar el cursor
    CLOSE cur_producto;

    -- Seleccionar los resultados de la tabla temporal
    SELECT * FROM temp_productos;

    -- Limpiar la tabla temporal (opcional)
    DROP TEMPORARY TABLE IF EXISTS temp_productos;

    SET error = 0; 
    COMMIT;
END$$
DELIMITER ;






DELIMITER $$

DROP PROCEDURE IF EXISTS buscarProductosPorNombre$$
CREATE PROCEDURE buscarProductosPorNombre(
    IN nombre_producto VARCHAR(50),
    OUT error INT
)
BEGIN
    DECLARE fin INT DEFAULT 0;
    DECLARE prod_codigo_barras VARCHAR(20);
    DECLARE prod_nombre VARCHAR(20);
    DECLARE prod_imagen TEXT;
    DECLARE prod_stock INT;
    DECLARE prod_descripcion TEXT;
    DECLARE prod_precio DECIMAL(10, 2);
    DECLARE prod_tipo VARCHAR(50);
    DECLARE prod_promocion INT;

    -- Declarar el cursor para seleccionar productos
    DECLARE cur_producto CURSOR FOR 
        SELECT codigo_barras, nombre, imagen, stock, descripcion, precio, tipo, promocion 
        FROM producto 
        WHERE nombre LIKE CONCAT('%', nombre_producto, '%');

    -- Declarar manejador para cuando el cursor no encuentra más resultados
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

    -- Manejador de errores SQL
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET error = 1;
        ROLLBACK;
    END;

    -- Crear tabla temporal para almacenar los resultados
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_productos (
        codigo_barras VARCHAR(20),
        nombre VARCHAR(20),
        imagen TEXT,
        stock INT,
        descripcion TEXT,
        precio DECIMAL(10, 2),
        tipo VARCHAR(50),
        promocion INT
    );

    -- Iniciar transacción
    START TRANSACTION;

    -- Abrir el cursor
    OPEN cur_producto;

    -- Leer filas del cursor
    read_loop: LOOP
        FETCH cur_producto INTO prod_codigo_barras, prod_nombre, prod_imagen, prod_stock, prod_descripcion, prod_precio, prod_tipo, prod_promocion;
        IF fin THEN
            LEAVE read_loop;
        END IF;

        -- Insertar datos en la tabla temporal
        INSERT INTO temp_productos (codigo_barras, nombre, imagen, stock, descripcion, precio, tipo, promocion)
        VALUES (prod_codigo_barras, prod_nombre, prod_imagen, prod_stock, prod_descripcion, prod_precio, prod_tipo, prod_promocion);
    END LOOP;

    -- Cerrar el cursor
    CLOSE cur_producto;

    -- Seleccionar resultados
    SELECT * FROM temp_productos;

    -- Limpiar tabla temporal
    DROP TEMPORARY TABLE IF EXISTS temp_productos;

    -- Establecer error en 0 si no ocurrió ningún problema
    SET error = 0;
    
    -- Confirmar transacción
    COMMIT;
END$$
DELIMITER ;