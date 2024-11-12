-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:33065
-- Tiempo de generación: 12-11-2024 a las 04:50:52
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `proyecto_mp4_db2`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarProductoConImagen` (IN `Pbarras` VARCHAR(20), IN `Pnombre` VARCHAR(20), IN `Pimagen` TEXT, IN `Pstock` INT, IN `Pdescripcion` TEXT, IN `Pprecio` DECIMAL(10,2), IN `Ptipo` VARCHAR(50), IN `Ppromocion` INT, OUT `error` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarProductoSinImagen` (IN `Pbarras` VARCHAR(20), IN `Pnombre` VARCHAR(20), IN `Pstock` INT, IN `Pdescripcion` TEXT, IN `Pprecio` DECIMAL(10,2), IN `Ptipo` VARCHAR(50), IN `Ppromocion` INT, OUT `error` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarUsuario` (IN `Ucedula` VARCHAR(20), IN `Unombre` VARCHAR(100), IN `Ucorreo` VARCHAR(50), IN `Ucontraseña` VARCHAR(8), IN `Ucelular` VARCHAR(10), IN `Udireccion` VARCHAR(20), IN `Urol` VARCHAR(15), OUT `error` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET error = 1;
        ROLLBACK;
    END;
    START TRANSACTION;
        UPDATE usuario
        SET nombre = Unombre,
            correo = Ucorreo,
            contraseña = Ucontraseña,
            celular = Ucelular,
            direccion = Udireccion,
            rol = Urol
        WHERE cedula = Ucedula;
        SET error = 0;
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allProductos` (OUT `error` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET error = 1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
       SELECT * FROM producto WHERE stock > 0;
    SET error = 0; 
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `borrarProducto` (IN `Pbarras` VARCHAR(20), OUT `error` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET error = 1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
        DELETE FROM producto
        WHERE codigo_barras = Pbarras;
    SET error = 0;
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `borrarUsuario` (IN `Ucedula` VARCHAR(20), OUT `error` INT)   BEGIN 
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET error = 1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
        DELETE FROM usuario
        WHERE cedula = Ucedula;
        SET error = 0;
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `buscarProductosPorCategoria` (IN `tipo_producto` VARCHAR(50), OUT `error` INT)   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `buscarProductosPorNombre` (IN `nombre_producto` VARCHAR(50), OUT `error` INT)   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `crearProducto` (IN `Pbarras` VARCHAR(20), IN `Pnombre` VARCHAR(20), IN `Pimagen` TEXT, IN `Pstock` INT, IN `Pdescripcion` TEXT, IN `Pprecio` DECIMAL(10,2), IN `Ptipo` VARCHAR(50), IN `Ppromocion` INT, OUT `error` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crearUsuario` (IN `Ucedula` VARCHAR(20), IN `Unombre` VARCHAR(100), IN `Ucorreo` VARCHAR(50), IN `Ucontraseña` VARCHAR(8), IN `Ucelular` VARCHAR(10), IN `Udireccion` VARCHAR(20), IN `Urol` VARCHAR(15), OUT `error` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET error = 1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
        INSERT INTO usuario (
                cedula,
                nombre,
                correo,
                contraseña,
                celular,
                direccion,
                rol
            )
        VALUES (
                Ucedula,
                Unombre,
                Ucorreo,
                Ucontraseña,
                Ucelular,
                Udireccion,
                Urol
            );
    SET error = 0;
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarUsuarioPorCorreo` (IN `email` VARCHAR(255), OUT `error` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET error = 1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
        SELECT * FROM usuario WHERE correo = email;
    SET error = 0; 
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_compras_por_usuario` (IN `p_cedula` VARCHAR(20), OUT `error` INT, OUT `error_message` VARCHAR(255))   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_log_papeleria` ()   BEGIN
    SELECT * FROM log_papeleria
    ORDER BY id_auditoria DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `productosPromocionMayorUno` (OUT `error` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET error = 1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
       SELECT * FROM producto WHERE promocion > 0;
    SET error = 0; 
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `verificar_y_comprar` (IN `p_fecha_pedido` DATE, IN `p_correo` VARCHAR(100), IN `p_metodo_pago` VARCHAR(50), IN `p_costo` DECIMAL(10,2), IN `p_impuesto` DECIMAL(10,2), IN `p_descuento` DECIMAL(10,2), IN `p_costo_total` DECIMAL(10,2), IN `p_cedula` VARCHAR(20), IN `p_codigo_barras` VARCHAR(20), IN `p_cantidad` INT, IN `p_estado` VARCHAR(50), OUT `error` INT, OUT `error_message` VARCHAR(255))   BEGIN
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
        SET error_message = 'Cantidad Insuficiente.';
        ROLLBACK;
    END IF;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura_pedido`
--

CREATE TABLE `factura_pedido` (
  `ID_factura_pedido` int(11) NOT NULL,
  `fecha_pedido` date DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `metodo_pago` varchar(50) DEFAULT NULL,
  `costo` decimal(10,2) DEFAULT NULL,
  `impuesto` decimal(10,2) DEFAULT NULL,
  `descuento` decimal(10,2) DEFAULT NULL,
  `costo_total` decimal(10,2) DEFAULT NULL,
  `cedula` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `factura_pedido`
--

INSERT INTO `factura_pedido` (`ID_factura_pedido`, `fecha_pedido`, `correo`, `metodo_pago`, `costo`, `impuesto`, `descuento`, `costo_total`, `cedula`) VALUES
(1, '2024-11-12', '1112618505', 'tarjeta', 100.00, 16.00, 10.00, 106.00, '1112618505'),
(2, '2024-11-12', '1112618505', 'tarjeta', 100.00, 16.00, 10.00, 106.00, '123');

--
-- Disparadores `factura_pedido`
--
DELIMITER $$
CREATE TRIGGER `log_delete_factura_pedido` AFTER DELETE ON `factura_pedido` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_insert_factura_pedido` AFTER INSERT ON `factura_pedido` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_update_factura_pedido` AFTER UPDATE ON `factura_pedido` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log_papeleria`
--

CREATE TABLE `log_papeleria` (
  `id_auditoria` int(11) NOT NULL,
  `tabla_afectada` varchar(100) DEFAULT NULL,
  `operacion` varchar(10) DEFAULT NULL,
  `id_registro` int(11) DEFAULT NULL,
  `valor_anterior` text DEFAULT NULL,
  `valor_nuevo` text DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `log_papeleria`
--

INSERT INTO `log_papeleria` (`id_auditoria`, `tabla_afectada`, `operacion`, `id_registro`, `valor_anterior`, `valor_nuevo`, `usuario`, `fecha`) VALUES
(1, 'usuario', 'INSERT', 123456789, NULL, 'Nombre: Juan Pérez, Correo: juan.perez@example.com, Rol: administrador', 'root@localhost', '2024-11-11 23:21:55'),
(2, 'usuario', 'INSERT', 123, NULL, 'Nombre: Jullian, Correo: julian@nose, Rol: Administrador', 'root@localhost', '2024-11-11 23:22:02'),
(3, 'usuario', 'DELETE', 123456789, 'Nombre: Juan Pérez, Correo: juan.perez@example.com, Rol: administrador', NULL, 'root@localhost', '2024-11-11 23:22:54'),
(4, 'producto', 'INSERT', 12321, NULL, 'Nombre: sadqads, Precio: 21333.00', 'root@localhost', '2024-11-12 00:53:20'),
(5, 'producto', 'UPDATE', 12321, 'Nombre: sadqads, Precio: 21333.00', 'Nombre: sadqads, Precio: 21333.00', 'root@localhost', '2024-11-12 01:05:12'),
(6, 'producto', 'UPDATE', 12321, 'Nombre: sadqads, Precio: 21333.00', 'Nombre: sadqads, Precio: 21333.00', 'root@localhost', '2024-11-12 01:05:27'),
(7, 'producto', 'UPDATE', 12321, 'Nombre: sadqads, Precio: 21333.00', 'Nombre: sadqads, Precio: 21333.00', 'root@localhost', '2024-11-12 01:13:28'),
(8, 'usuario', 'INSERT', 1004776193, NULL, 'Nombre: Alejo, Correo: alejo@ucp.edu.co, Rol: Administrador', 'root@localhost', '2024-11-12 01:26:30'),
(9, 'producto', 'INSERT', 123456789, NULL, 'Nombre: Papel Carbón, Precio: 10000.00', 'root@localhost', '2024-11-12 01:32:27'),
(10, 'producto', 'INSERT', 987654321, NULL, 'Nombre: cuaderno, Precio: 30000.00', 'root@localhost', '2024-11-12 01:33:30'),
(11, 'producto', 'INSERT', 465987123, NULL, 'Nombre: Palos, Precio: 1000.00', 'root@localhost', '2024-11-12 01:37:06'),
(12, 'producto', 'UPDATE', 465987123, 'Nombre: Palos, Precio: 1000.00', 'Nombre: Balsos, Precio: 1000.00', 'root@localhost', '2024-11-12 01:39:27'),
(13, 'producto', 'INSERT', 159542789, NULL, 'Nombre: Resma de papel, Precio: 40000.00', 'root@localhost', '2024-11-12 01:40:53'),
(14, 'producto', 'UPDATE', 465987123, 'Nombre: Balsos, Precio: 1000.00', 'Nombre: Balsos, Precio: 1000.00', 'root@localhost', '2024-11-12 01:41:49'),
(15, 'usuario', 'INSERT', 1089378916, NULL, 'Nombre: Juan, Correo: juan@nose.com, Rol: Administrador', 'root@localhost', '2024-11-12 01:43:27'),
(16, 'producto', 'INSERT', 654735180, NULL, 'Nombre: mouse alámbrico para, Precio: 20000.00', 'root@localhost', '2024-11-12 01:44:25'),
(17, 'producto', 'UPDATE', 654735180, 'Nombre: mouse alámbrico para, Precio: 20000.00', 'Nombre: mouse alámbrico para, Precio: 20000.00', 'root@localhost', '2024-11-12 01:44:38'),
(18, 'producto', 'INSERT', 453195789, NULL, 'Nombre: Cautín tipo lápiz de, Precio: 45000.00', 'root@localhost', '2024-11-12 01:47:01'),
(19, 'producto', 'UPDATE', 987654321, 'Nombre: cuaderno, Precio: 30000.00', 'Nombre: cuaderno, Precio: 30000.00', 'root@localhost', '2024-11-12 01:47:42'),
(20, 'producto', 'INSERT', 453489678, NULL, 'Nombre: Boligrafo tinta negr, Precio: 5000.00', 'root@localhost', '2024-11-12 01:48:41'),
(21, 'producto', 'INSERT', 53178952, NULL, 'Nombre: Paquete Menta Chao, Precio: 15000.00', 'root@localhost', '2024-11-12 01:52:01'),
(22, 'producto', 'INSERT', 1765682, NULL, 'Nombre: Paquete de galletas, Precio: 12000.00', 'root@localhost', '2024-11-12 01:53:11'),
(23, 'producto', 'INSERT', 21654751, NULL, 'Nombre: Caramelo Revolcón, Precio: 20000.00', 'root@localhost', '2024-11-12 01:54:53'),
(24, 'producto', 'INSERT', 852649125, NULL, 'Nombre: Paquete de Crispetas, Precio: 10000.00', 'root@localhost', '2024-11-12 01:57:21'),
(25, 'producto', 'INSERT', 417825951, NULL, 'Nombre: Teclado USB TJ-818,, Precio: 20000.00', 'root@localhost', '2024-11-12 01:59:44'),
(26, 'usuario', 'INSERT', 1112618505, NULL, 'Nombre: Juan Miguel, Correo: jumilasi@gmail.com, Rol: Administrador', 'root@localhost', '2024-11-12 02:00:17'),
(27, 'producto', 'INSERT', 452789231, NULL, 'Nombre: Audifonos Bluetooth, Precio: 25000.00', 'root@localhost', '2024-11-12 02:02:38'),
(28, 'producto', 'DELETE', 12321, 'Nombre: sadqads, Precio: 21333.00', NULL, 'root@localhost', '2024-11-12 02:03:50'),
(29, 'producto', 'INSERT', 259845531, NULL, 'Nombre: Carpeta plástica, Precio: 35000.00', 'root@localhost', '2024-11-12 02:05:41'),
(30, 'producto', 'INSERT', 1, NULL, 'Nombre: Rollo de cinta, Precio: 10000.00', 'root@localhost', '2024-11-12 02:07:12'),
(31, 'producto', 'UPDATE', 1, 'Nombre: Rollo de cinta, Precio: 10000.00', 'Nombre: Rollo de cinta, Precio: 10000.00', 'root@localhost', '2024-11-12 02:09:29'),
(32, 'factura_pedido', 'INSERT', 1, NULL, 'Costo: 100.00, Impuesto: 16.00, Total: 106.00', 'root@localhost', '2024-11-12 02:09:29'),
(33, 'pedidos_producto', 'INSERT', 1, NULL, 'Cantidad: 2, Estado: pendiente', 'root@localhost', '2024-11-12 02:09:29'),
(34, 'producto', 'INSERT', 25842951, NULL, 'Nombre: Encendedor automatic, Precio: 2500.00', 'root@localhost', '2024-11-12 02:09:39'),
(35, 'producto', 'UPDATE', 1, 'Nombre: Rollo de cinta, Precio: 10000.00', 'Nombre: Rollo de cinta, Precio: 10000.00', 'root@localhost', '2024-11-12 02:30:07'),
(36, 'factura_pedido', 'INSERT', 2, NULL, 'Costo: 100.00, Impuesto: 16.00, Total: 106.00', 'root@localhost', '2024-11-12 02:30:07'),
(37, 'pedidos_producto', 'INSERT', 2, NULL, 'Cantidad: 2, Estado: pendiente', 'root@localhost', '2024-11-12 02:30:07'),
(38, 'usuario', 'INSERT', 2147483647, NULL, 'Nombre: juan, Correo: jj99renterias@gmail., Rol: Administrador', 'root@localhost', '2024-11-12 02:32:05'),
(39, 'usuario', 'DELETE', 2147483647, 'Nombre: juan, Correo: jj99renterias@gmail., Rol: Administrador', NULL, 'root@localhost', '2024-11-12 02:33:17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos_producto`
--

CREATE TABLE `pedidos_producto` (
  `ID_pedidos_producto` int(11) NOT NULL,
  `ID_factura_pedido` int(11) DEFAULT NULL,
  `codigo_barras` varchar(20) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pedidos_producto`
--

INSERT INTO `pedidos_producto` (`ID_pedidos_producto`, `ID_factura_pedido`, `codigo_barras`, `cantidad`, `estado`) VALUES
(1, 1, '00000001', 2, 'pendiente'),
(2, 2, '00000001', 2, 'pendiente');

--
-- Disparadores `pedidos_producto`
--
DELIMITER $$
CREATE TRIGGER `log_delete_pedidos_producto` AFTER DELETE ON `pedidos_producto` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_insert_pedidos_producto` AFTER INSERT ON `pedidos_producto` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_update_pedidos_producto` AFTER UPDATE ON `pedidos_producto` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `codigo_barras` varchar(20) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `imagen` text DEFAULT NULL,
  `stock` int(11) NOT NULL,
  `descripcion` text NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `promocion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`codigo_barras`, `nombre`, `imagen`, `stock`, `descripcion`, `precio`, `tipo`, `promocion`) VALUES
('00000001', 'Rollo de cinta', 'img/Productos/D_NQ_NP_906876-MLA50109678873_052022-O.webp', 16, 'Rollo de cinta transparente, ideal para pegar, sellar y reparar documentos o paquetes. De fácil aplicación, con adhesivo de alta calidad que garantiza una sujeción firme sin dejar residuos. Perfecta para uso doméstico y de oficina.', 10000.00, 'Útiles Escolares', '0'),
('021654751', 'Caramelo Revolcón', 'img/Productos/D_NQ_NP_2X_863194-MCO48137816061_112021-T.webp', 15, 'Revolcón, caramelo ácido con un sabor intenso y refrescante. Su capa exterior de polvo ácido envuelve un delicioso interior, ofreciendo una experiencia de sabor única y sorprendente. Perfecto para los amantes de los dulces intensos.', 20000.00, 'Confitería', '0'),
('025842951', 'Encendedor automatic', 'img/Productos/1010350.jpg', 10, 'Encendedor compacto y confiable, diseñado para ofrecer una llama rápida y precisa. Ideal para encender cigarrillos, velas o cualquier objeto que requiera una chispa. Con estructura resistente y fácil de usar.', 2500.00, 'Papelería', '0'),
('0259845531', 'Carpeta plástica', 'img/Productos/carpeta-plastica-legajadora-oficio-azul-1.webp', 20, 'Carpeta resistente, ideal para organizar y almacenar documentos de forma ordenada. Fabricada en materiales duraderos, con capacidad para contener múltiples hojas, perfecta para uso en oficina, escuela o hogar.', 35000.00, 'Útiles Escolares', '0'),
('123456789', 'Papel Carbón', 'img/Productos/papel_carbon.webp', 20, 'Papel carbón de 50cmx50cm', 10000.00, 'Papelería', '0'),
('159542789', 'Resma de papel', 'img/Productos/resma_papel.webp', 50, 'Resma de 500 hojas de papel de 75 g/m², ideal para impresión y copias. Compatible con impresoras láser e inkjet, de alta calidad y resistencia. Disponible en tamaños carta y oficio.', 40000.00, 'Papelería', '10'),
('1765682', 'Paquete de galletas', 'img/Productos/galletas-oreo-vainilla-bolsa-12-und-2.webp', 10, 'Galletas Oreo, con dos capas de galleta crujiente y un delicioso relleno de crema suave. Perfectas para disfrutar solas o acompañadas de leche, ofreciendo un sabor único y tentador.', 12000.00, 'Confitería', '0'),
('417825951', 'Teclado USB TJ-818,', 'img/Productos/39188_700x933.jpg', 15, 'Teclado USB TJ-818, de diseño compacto y ergonómico, con teclas de respuesta rápida y silenciosa. Conexión USB plug-and-play, compatible con sistemas Windows y macOS. Ideal para uso en oficina o hogar.', 20000.00, 'Tecnología', '0'),
('452789231', 'Audifonos Bluetooth', 'img/Productos/audifonos-auriculares-bluetooth-inalambricos-p9.webp', 16, 'Audífonos Bluetooth, con tecnología inalámbrica de alta calidad, ofrecen sonido claro y potente. Con diseño cómodo y ajustable, cuentan con controles integrados para fácil manejo. Ideal para escuchar música, realizar llamadas y disfrutar de libertad de movimiento.', 25000.00, 'Tecnología', '0'),
('453195789', 'Cautín tipo lápiz de', 'img/Productos/cautin-tipo-lapiz-de-30-watts.jpg', 10, 'Cautín tipo lápiz de 30W, con punta fina para soldaduras precisas. Calentamiento rápido y diseño ergonómico, ideal para trabajos electrónicos y reparaciones detalladas.', 45000.00, 'Tecnología', '0'),
('453489678', 'Boligrafo tinta negr', 'img/Productos/2866.jpg', 40, 'Bolígrafo con tinta negra de secado rápido, diseño ergonómico y clip para fácil sujeción. Ideal para escribir de manera fluida y cómoda.', 5000.00, 'Papelería', '0'),
('465987123', 'Balsos', 'img/Productos/palos_madera.webp', 50, 'Balsos de madera para almacenamiento de documentos, resistentes y duraderos, ideales para organizar carpetas y papeles en oficinas.', 1000.00, 'Papelería', '0'),
('53178952', 'Paquete Menta Chao', 'img/Productos/CHAO-MENTA-X100.webp', 10, 'Mentas Chao, caramelos refrescantes con sabor a menta, ideales para proporcionar una sensación de frescura y aliento agradable. Su presentación en envase práctico los hace perfectos para llevar en cualquier momento del día.', 15000.00, 'Confitería', '0'),
('654735180', 'mouse alámbrico para', 'img/Productos/MOUSE-TRUST-ALAMBRICO-BASIC-2.png', 20, 'Mouse óptico con conexión USB, diseño ergonómico y sensores de alta precisión para un control fluido. Compatible con Windows y macOS, ideal para uso en oficina y hogar.', 20000.00, 'Tecnología', '20'),
('852649125', 'Paquete de Crispetas', 'img/Productos/76150601336.jpg', 15, 'Paquete de crispetas para microondas, fácil y rápido de preparar. Contiene maíz premium que se expande perfectamente, ofreciendo un snack crujiente y delicioso en minutos. Ideal para disfrutar en cualquier ocasión.', 10000.00, 'Confitería', '30'),
('987654321', 'cuaderno', 'img/Productos/Cuaderno-argollado-Azul-1-3410.webp', 15, 'Cuaderno argollado con 100 hojas de papel de 70 g/m², de fácil apertura y cierre. Ideal para tomar notas, disponible en diversos tamaños y colores.', 30000.00, 'Útiles Escolares', '20');

--
-- Disparadores `producto`
--
DELIMITER $$
CREATE TRIGGER `log_delete_producto` AFTER DELETE ON `producto` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_insert_producto` AFTER INSERT ON `producto` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_update_producto` AFTER UPDATE ON `producto` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `cedula` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(50) NOT NULL,
  `contraseña` varchar(8) NOT NULL,
  `celular` varchar(10) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `rol` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`cedula`, `nombre`, `correo`, `contraseña`, `celular`, `direccion`, `rol`) VALUES
('1004776193', 'Alejo', 'alejo@ucp.edu.co', '12345', '3116340023', 'Cra 18 #10-125', 'Administrador'),
('1089378916', 'Juan', 'juan@nose.com', '1090', '3043476433', 'cra', 'Administrador'),
('1112618505', 'Juan Miguel', 'jumilasi@gmail.com', 'jmls2004', '3178657832', 'Jardines apto 254', 'Administrador'),
('123', 'Jullian', 'julian@nose', '12345', '123', 'a', 'Administrador');

--
-- Disparadores `usuario`
--
DELIMITER $$
CREATE TRIGGER `log_delete_usuario` AFTER DELETE ON `usuario` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_insert_usuario` AFTER INSERT ON `usuario` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_update_usuario` AFTER UPDATE ON `usuario` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `factura_pedido`
--
ALTER TABLE `factura_pedido`
  ADD PRIMARY KEY (`ID_factura_pedido`),
  ADD KEY `cedula` (`cedula`);

--
-- Indices de la tabla `log_papeleria`
--
ALTER TABLE `log_papeleria`
  ADD PRIMARY KEY (`id_auditoria`);

--
-- Indices de la tabla `pedidos_producto`
--
ALTER TABLE `pedidos_producto`
  ADD PRIMARY KEY (`ID_pedidos_producto`),
  ADD KEY `ID_factura_pedido` (`ID_factura_pedido`),
  ADD KEY `codigo_barras` (`codigo_barras`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`codigo_barras`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`cedula`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `factura_pedido`
--
ALTER TABLE `factura_pedido`
  MODIFY `ID_factura_pedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `log_papeleria`
--
ALTER TABLE `log_papeleria`
  MODIFY `id_auditoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT de la tabla `pedidos_producto`
--
ALTER TABLE `pedidos_producto`
  MODIFY `ID_pedidos_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `factura_pedido`
--
ALTER TABLE `factura_pedido`
  ADD CONSTRAINT `factura_pedido_ibfk_1` FOREIGN KEY (`cedula`) REFERENCES `usuario` (`cedula`);

--
-- Filtros para la tabla `pedidos_producto`
--
ALTER TABLE `pedidos_producto`
  ADD CONSTRAINT `pedidos_producto_ibfk_1` FOREIGN KEY (`ID_factura_pedido`) REFERENCES `factura_pedido` (`ID_factura_pedido`),
  ADD CONSTRAINT `pedidos_producto_ibfk_2` FOREIGN KEY (`codigo_barras`) REFERENCES `producto` (`codigo_barras`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
