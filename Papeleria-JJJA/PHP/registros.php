<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registros de Auditoria</title>
    <link rel="stylesheet" type="text/css" href="../css/usua.css">
    <link
        href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400..700&family=Fascinate+Inline&family=Pacifico&display=swap"
        rel="stylesheet" />
</head>

<body>

    <h2>Registros de Auditoria</h2>
    <a id="volver" href="../index.php">Volver a Inicio</a>
    <br><br>

    <?php
    include 'conexion.php';

    $sql = "CALL obtener_log_papeleria()";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        echo "<table border='1'>";
        echo "<tr><th>ID Auditoria</th><th>Tabla Afectada</th><th>Operación</th><th>ID Registro</th><th>Valor Anterior</th><th>Valor Nuevo</th><th>Usuario</th><th>Fecha</th></tr>";

        while ($row = $result->fetch_assoc()) {
            echo "<tr>";
            echo "<td>" . $row['id_auditoria'] . "</td>";
            echo "<td>" . $row['tabla_afectada'] . "</td>";
            echo "<td>" . $row['operacion'] . "</td>";
            echo "<td>" . $row['id_registro'] . "</td>";
            echo "<td>" . $row['valor_anterior'] . "</td>";
            echo "<td>" . $row['valor_nuevo'] . "</td>";
            echo "<td>" . $row['usuario'] . "</td>";
            echo "<td>" . $row['fecha'] . "</td>";
            echo "</tr>";
        }

        echo "</table>";
    } else {
        echo "No hay registros disponibles.";
    }

    $conn->close();
    ?>
</body>

</html>