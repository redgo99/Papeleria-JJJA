<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Usuarios</title>
    <link rel="stylesheet" type="text/css" href="../css/usua.css">
    <link
        href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400..700&family=Fascinate+Inline&family=Pacifico&display=swap"
        rel="stylesheet" />
</head>

<body>
    <h2>Lista de Usuarios</h2>
    <a id="volver" href="../index.php">Volver a Inicio</a>
    <br><br>

    <?php
    include 'conexion.php';

    $sql = "SELECT * FROM usuario";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        echo "<table border='1'>";
        echo "<tr><th>Cédula</th><th>Nombre</th><th>Correo</th><th>Contraseña</th><th>Celular</th><th>Dirección</th><th>Rol</th><th>Acciones</th></tr>";

        while ($row = $result->fetch_assoc()) {
            echo "<tr>";
            echo "<td>" . $row['cedula'] . "</td>";
            echo "<td>" . $row['nombre'] . "</td>";
            echo "<td>" . $row['correo'] . "</td>";
            echo "<td>" . str_repeat('*', strlen($row['contraseña'])) . "</td>";
            echo "<td>" . $row['celular'] . "</td>";
            echo "<td>" . $row['direccion'] . "</td>";
            echo "<td>" . $row['rol'] . "</td>";
            echo "<td>
                    <a id='bt' class='acep' href='funcionesUsuario/formularioUsuarios.php?id=" . $row['cedula'] . "' onclick='alert(\"Vas a editar el usuario con cédula " . $row['cedula'] . "\")'>Editar</a> |
                    <a id='bt' class='del' href='funcionesUsuario/eliminar_usuario.php?id=" . $row['cedula'] . "' onclick='return confirm(\"¿Estás seguro?\") && alert(\"Eliminando usuario con cédula " . $row['cedula'] . "\")'>Eliminar</a>
                  </td>";
            echo "</tr>";
        }

        echo "</table>";
    } else {
        echo "No hay Usuarios disponibles.";
    }

    $conn->close();
    ?>
</body>

</html>