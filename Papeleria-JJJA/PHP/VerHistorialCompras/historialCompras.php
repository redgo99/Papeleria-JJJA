<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Compras</title>
    <link rel="stylesheet" type="text/css" href="../../Css/usua.css">
    <link
        href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400..700&family=Fascinate+Inline&family=Pacifico&display=swap"
        rel="stylesheet" />
</head>

<body>

    <h2>Historial de Compras</h2>
    <a id="volver" href="../../index.php">Volver a Inicio</a>
    <br><br>
    <?php

    $cedula = "";
    if (isset($_GET["id"])) {
        $cedula = $_GET["id"];
    } else {
        $cedula = "Sin Registro";
    }

    include '..\conexion.php';

    $sql = "CALL obtener_compras_por_usuario($cedula, @error1, @error2)";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        echo "<table border='1'>";
        echo "<tr><th>ID Factura</th><th>Fecha</th><th>Método de pago</th><th>Costo</th><th>Impuesto</th><th>Descuento</th><th>Costo Total</th><th>Codigo de Barras</th><th>Cantidad</th><th>Estado</th></tr>";
        echo "<tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<td>" . $row['ID_factura_pedido'] . "</td>";
            echo "<td>" . $row['fecha_pedido'] . "</td>";
            echo "<td>" . $row['metodo_pago'] . "</td>";
            echo "<td>" . $row['costo'] . "</td>";
            echo "<td>" . $row['impuesto'] . "</td>";
            echo "<td>" . $row['descuento'] . "</td>";
            echo "<td>" . $row['costo_total'] . "</td>";
            echo "<td>" . $row['codigo_barras'] . "</td>";
            echo "<td>" . $row['cantidad'] . "</td>";
            echo "<td>" . $row['estado'] . "</td>";
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "No hay historial de compra disponibles.";
    }

    $conn->close();
    ?>
</body>

</html>