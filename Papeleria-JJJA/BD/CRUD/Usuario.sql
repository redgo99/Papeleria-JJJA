-- CRUD usuarios
-- 1:Insertar
DELIMITER $$
DROP PROCEDURE IF EXISTS crearUsuario $$ 
CREATE PROCEDURE crearUsuario(
    IN Ucedula VARCHAR(20),
    IN Unombre VARCHAR(100),
    IN Ucorreo VARCHAR(50),
    IN Ucontraseña VARCHAR(8),
    IN Ucelular VARCHAR(10),
    IN Udireccion VARCHAR(20),
    IN Urol VARCHAR(15),
    OUT error INT
) 
BEGIN
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
END 
$$ 
DELIMITER ;

-- 2:Borrar

DELIMITER $$
DROP PROCEDURE IF EXISTS borrarUsuario$$ 
CREATE PROCEDURE borrarUsuario(
    IN Ucedula VARCHAR(20),
    OUT error INT
) 
BEGIN 
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
END 
$$ 
DELIMITER ;

-- 3:Actualizar

DELIMITER $$ 
DROP PROCEDURE IF EXISTS actualizarUsuario $$ 
CREATE PROCEDURE actualizarUsuario(
    IN Ucedula VARCHAR(20),
    IN Unombre VARCHAR(100),
    IN Ucorreo VARCHAR(50),
    IN Ucontraseña VARCHAR(8),
    IN Ucelular VARCHAR(10),
    IN Udireccion VARCHAR(20),
    IN Urol VARCHAR(15),
    OUT error INT
) 
BEGIN
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
END 
$$ 
DELIMITER ;