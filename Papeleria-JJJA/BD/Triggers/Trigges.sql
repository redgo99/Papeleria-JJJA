-- Cambiar delimitador para poder usar los triggers
DELIMITER $$

-- Trigger de Insertar Usuario
CREATE TRIGGER log_insert_usuario
AFTER INSERT ON usuario
FOR EACH ROW
BEGIN
    INSERT INTO log_papeleria (
        tabla_afectada,
        operacion,
        id_registro,
        valor_nuevo,
        usuario
    )
    VALUES (
        'usuario',
        'INSERT',
        NEW.cedula,
        CONCAT('Nombre: ', NEW.nombre, ', Correo: ', NEW.correo, ', Rol: ', NEW.rol),
        USER()
    );
END $$

-- Trigger de Insertar Factura Pedido
CREATE TRIGGER log_insert_factura_pedido
AFTER INSERT ON factura_pedido
FOR EACH ROW
BEGIN
    INSERT INTO log_papeleria (
        tabla_afectada,
        operacion,
        id_registro,
        valor_nuevo,
        usuario
    )
    VALUES (
        'factura_pedido',
        'INSERT',
        NEW.ID_factura_pedido,
        CONCAT('Costo: ', NEW.costo, ', Impuesto: ', NEW.impuesto, ', Total: ', NEW.costo_total),
        USER()
    );
END $$

-- Trigger de Insertar Pedidos Producto
CREATE TRIGGER log_insert_pedidos_producto
AFTER INSERT ON pedidos_producto
FOR EACH ROW
BEGIN
    INSERT INTO log_papeleria (
        tabla_afectada,
        operacion,
        id_registro,
        valor_nuevo,
        usuario
    )
    VALUES (
        'pedidos_producto',
        'INSERT',
        NEW.ID_pedidos_producto,
        CONCAT('Cantidad: ', NEW.cantidad, ', Estado: ', NEW.estado),
        USER()
    );
END $$

-- Trigger de Insertar Producto
CREATE TRIGGER log_insert_producto
AFTER INSERT ON producto
FOR EACH ROW
BEGIN
    INSERT INTO log_papeleria (
        tabla_afectada,
        operacion,
        id_registro,
        valor_nuevo,
        usuario
    )
    VALUES (
        'producto',
        'INSERT',
        NEW.codigo_barras,
        CONCAT('Nombre: ', NEW.nombre, ', Precio: ', NEW.precio),
        USER()
    );
END $$

-- Trigger de Borrar Usuario
CREATE TRIGGER log_delete_usuario
AFTER DELETE ON usuario
FOR EACH ROW
BEGIN
    INSERT INTO log_papeleria (
        tabla_afectada,
        operacion,
        id_registro,
        valor_anterior,
        usuario
    )
    VALUES (
        'usuario',
        'DELETE',
        OLD.cedula,
        CONCAT('Nombre: ', OLD.nombre, ', Correo: ', OLD.correo, ', Rol: ', OLD.rol),
        USER()
    );
END $$

-- Trigger de Borrar Factura Pedido
CREATE TRIGGER log_delete_factura_pedido
AFTER DELETE ON factura_pedido
FOR EACH ROW
BEGIN
    INSERT INTO log_papeleria (
        tabla_afectada,
        operacion,
        id_registro,
        valor_anterior,
        usuario
    )
    VALUES (
        'factura_pedido',
        'DELETE',
        OLD.ID_factura_pedido,
        CONCAT('Costo: ', OLD.costo, ', Impuesto: ', OLD.impuesto, ', Total: ', OLD.costo_total),
        USER()
    );
END $$

-- Trigger de Borrar Pedidos Producto
CREATE TRIGGER log_delete_pedidos_producto
AFTER DELETE ON pedidos_producto
FOR EACH ROW
BEGIN
    INSERT INTO log_papeleria (
        tabla_afectada,
        operacion,
        id_registro,
        valor_anterior,
        usuario
    )
    VALUES (
        'pedidos_producto',
        'DELETE',
        OLD.ID_pedidos_producto,
        CONCAT('Cantidad: ', OLD.cantidad, ', Estado: ', OLD.estado),
        USER()
    );
END $$

-- Trigger de Borrar Producto
CREATE TRIGGER log_delete_producto
AFTER DELETE ON producto
FOR EACH ROW
BEGIN
    INSERT INTO log_papeleria (
        tabla_afectada,
        operacion,
        id_registro,
        valor_anterior,
        usuario
    )
    VALUES (
        'producto',
        'DELETE',
        OLD.codigo_barras,
        CONCAT('Nombre: ', OLD.nombre, ', Precio: ', OLD.precio),
        USER()
    );
END $$

-- Trigger de Actualizar Usuario
CREATE TRIGGER log_update_usuario
AFTER UPDATE ON usuario
FOR EACH ROW
BEGIN
    INSERT INTO log_papeleria (
        tabla_afectada,
        operacion,
        id_registro,
        valor_anterior,
        valor_nuevo,
        usuario
    )
    VALUES (
        'usuario',
        'UPDATE',
        OLD.cedula,
        CONCAT('Nombre: ', OLD.nombre, ', Correo: ', OLD.correo, ', Rol: ', OLD.rol),
        CONCAT('Nombre: ', NEW.nombre, ', Correo: ', NEW.correo, ', Rol: ', NEW.rol),
        USER()
    );
END $$

-- Trigger de Actualizar Factura Pedido
CREATE TRIGGER log_update_factura_pedido
AFTER UPDATE ON factura_pedido
FOR EACH ROW
BEGIN
    INSERT INTO log_papeleria (
        tabla_afectada,
        operacion,
        id_registro,
        valor_anterior,
        valor_nuevo,
        usuario
    )
    VALUES (
        'factura_pedido',
        'UPDATE',
        OLD.ID_factura_pedido,
        CONCAT('Costo: ', OLD.costo, ', Impuesto: ', OLD.impuesto, ', Total: ', OLD.costo_total),
        CONCAT('Costo: ', NEW.costo, ', Impuesto: ', NEW.impuesto, ', Total: ', NEW.costo_total),
        USER()
    );
END $$

-- Trigger de Actualizar Pedidos Producto
CREATE TRIGGER log_update_pedidos_producto
AFTER UPDATE ON pedidos_producto
FOR EACH ROW
BEGIN
    INSERT INTO log_papeleria (
        tabla_afectada,
        operacion,
        id_registro,
        valor_anterior,
        valor_nuevo,
        usuario
    )
    VALUES (
        'pedidos_producto',
        'UPDATE',
        OLD.ID_pedidos_producto,
        CONCAT('Cantidad: ', OLD.cantidad, ', Estado: ', OLD.estado),
        CONCAT('Cantidad: ', NEW.cantidad, ', Estado: ', NEW.estado),
        USER()
    );
END $$

-- Trigger de Actualizar Producto
CREATE TRIGGER log_update_producto
AFTER UPDATE ON producto
FOR EACH ROW
BEGIN
    INSERT INTO log_papeleria (
        tabla_afectada,
        operacion,
        id_registro,
        valor_anterior,
        valor_nuevo,
        usuario
    )
    VALUES (
        'producto',
        'UPDATE',
        OLD.codigo_barras,
        CONCAT('Nombre: ', OLD.nombre, ', Precio: ', OLD.precio),
        CONCAT('Nombre: ', NEW.nombre, ', Precio: ', NEW.precio),
        USER()
    );
END $$

-- Restaurar delimitador a `;`
DELIMITER ;
