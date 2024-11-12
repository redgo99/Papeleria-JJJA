DROP PROCEDURE IF EXISTS verificar_y_comprar$$
CREATE PROCEDURE verificar_y_comprar(
    IN p_fecha_pedido DATE,
    IN p_correo VARCHAR(100),
    IN p_metodo_pago VARCHAR(50),
    IN p_costo DECIMAL(10, 2),
    IN p_impuesto DECIMAL(10, 2),
    IN p_descuento DECIMAL(10, 2),
    IN p_costo_total DECIMAL(10, 2),
    IN p_cedula VARCHAR(20),
    IN p_codigo_barras VARCHAR(20),
    IN p_cantidad INT,
    IN p_estado VARCHAR(50),
    OUT error INT,
    OUT error_message VARCHAR(255)
)
BEGIN
    DECLARE factid INT;
    DECLARE current_stock INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET error = 1;
        SET error_message = 'Error during transaction.';
        ROLLBACK;
    END;
-- Initialize the error output variable
    SET error = 0;
    SET error_message = NULL;
    START TRANSACTION;

    -- Verify product stock
    SELECT stock INTO current_stock
    FROM producto
    WHERE codigo_barras = p_codigo_barras
    FOR UPDATE;

    IF current_stock >= p_cantidad THEN
        -- Reduce product stock
        UPDATE producto
        SET stock = stock - p_cantidad
        WHERE codigo_barras = p_codigo_barras;

        -- Insert into factura_pedido
        INSERT INTO factura_pedido (
            fecha_pedido, correo, metodo_pago, costo, impuesto, descuento, costo_total, cedula
        ) VALUES (
            p_fecha_pedido, p_correo, p_metodo_pago, p_costo, p_impuesto, p_descuento, p_costo_total, p_cedula
        );

        -- Retrieve the last generated ID_factura_pedido
        SET factid = LAST_INSERT_ID();

        -- Insert into pedidos_producto
        INSERT INTO pedidos_producto (
            ID_factura_pedido, codigo_barras, cantidad, estado
        ) VALUES (
            factid, p_codigo_barras, p_cantidad, p_estado
        );

        SET error = 0;
        SET error_message = NULL;
        COMMIT;
    ELSE
        SET error = 1;
        SET error_message = 'Insufficient stock.';
        ROLLBACK;
    END IF;

END $$

DELIMITER ;