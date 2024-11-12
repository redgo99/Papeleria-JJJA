<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de usuario</title>
    <!-- LINK TIPO DE LETRA  "Pacifico", cursive -->
    <link
        href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400..700&family=Fascinate+Inline&family=Pacifico&display=swap"
        rel="stylesheet" />
    <!--  -->
    <link rel="stylesheet" href="../../css/estilosEditar.css">
</head>

<body>
    <h2><?php echo isset($_GET['id']) ? "Editar usuario" : "Agregar usuario"; ?></h2>

    <?php
    include '../conexion.php';

    $id = "";
    $cedula = "";
    $nombre = "";
    $correo = "";
    $contraseña = "";
    $celular = "";
    $direccion = "";
    $rol = "";

    if (isset($_GET['id'])) {
        $id = intval($_GET['id']);
        $sql = "SELECT * FROM usuario WHERE cedula = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $resultado = $stmt->get_result();
        $usuario = $resultado->fetch_assoc();

        $cedula = $usuario['cedula'];
        $nombre = $usuario['nombre'];
        $correo = $usuario['correo'];
        $contraseña = $usuario['contraseña'];
        $celular = $usuario['celular'];
        $direccion = $usuario['direccion'];
        $rol = $usuario['rol'];
    }
    ?>

    <form action="procesar_usuario.php" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="<?php echo $id; ?>">

        <label for="cedula">Cédula:</label><br>
        <input type="text" id="cedula" name="cedula" readonly value="<?php echo $cedula; ?>" required>
        <br><br>

        <label for="nombre">Nombre:</label><br>
        <input type="text" id="nombre" name="nombre" value="<?php echo $nombre; ?>" required>
        <br><br>

        <label for="correo">correo:</label><br>
        <input type="email" id="correo" name="correo" value="<?php echo $correo; ?>" required>
        <br><br>

        <label for="contraseña">Contraseña:</label><br>
        <input type="password" id="contraseña" name="contraseña" required>
        <br><br>

        <label for="celular">Celular:</label><br>
        <input type="number" id="celular" name="celular" step="0.01" value="<?php echo $celular; ?>" required>
        <br><br>

        <label for="direccion">direccion:</label><br>
        <input type="text" id="direccion" name="direccion" value="<?php echo $direccion; ?>">
        <br><br>

        <label for="rol">Rol:</label>
        <br>
        <input type="text" id="rol" name="rol" value="<?php echo $rol; ?>">
        <br><br>

        <input type="submit" value="<?php echo isset($_GET['id']) ? 'Actualizar usuario' : 'Agregar usuario'; ?>">
    </form>

    <?php

    if (isset($_SERVER['HTTP_REFERER']) && strpos($_SERVER['HTTP_REFERER'], 'index.php') !== false) {
        $pag = "../../index.php";
        $nn = "Volver";
    } else {
        $pag = "../usuarios.php";
        $nn = "Volver al listado de usuarios";
    }
    ?>

    <a href="<?php echo $pag; ?>"><?php echo $nn; ?></a>
</body>

</html>