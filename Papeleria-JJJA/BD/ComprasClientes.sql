DELIMITER $$

DROP PROCEDURE IF EXISTS obtener_compras_por_usuario$$
CREATE PROCEDURE obtener_compras_por_usuario(
    IN p_cedula VARCHAR(20),
    OUT error INT,
    OUT error_message VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET error = 1;
        SET error_message = 'Error al obtener las compras del usuario.';
        ROLLBACK;
    END;

    -- Inicializar variables de salida
    SET error = 0;
    SET error_message = NULL;
    
    -- Iniciar una transacción en caso de que sea necesario hacer más cambios en el futuro
    START TRANSACTION;

    -- Seleccionar las compras del usuario
    SELECT 
        fp.ID_factura_pedido,
        fp.fecha_pedido,
        fp.metodo_pago,
        fp.costo,
        fp.impuesto,
        fp.descuento,
        fp.costo_total,
        pp.codigo_barras,
        pp.cantidad,
        pp.estado
    FROM 
        factura_pedido AS fp
    JOIN 
        pedidos_producto AS pp ON fp.ID_factura_pedido = pp.ID_factura_pedido
    WHERE 
        fp.cedula = p_cedula;

    -- Confirmar transacción
    COMMIT;
END $$

DELIMITER ;