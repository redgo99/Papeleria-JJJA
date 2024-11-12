<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Productos</title>
    <link rel="stylesheet" type="text/css" href="../css/usua.css">
    <link
        href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400..700&family=Fascinate+Inline&family=Pacifico&display=swap"
        rel="stylesheet" />
</head>

<body>

    <h2>Lista de Productos</h2>
    <a id="volver" href="../index.php">Volver a Inicio</a>
    <a id="agg" href="funcionesProductos/formulario.php">Agregar Producto</a>
    <br><br>



    <?php
    include 'conexion.php';

    $sql = "SELECT * FROM producto";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        echo "<table border='1'>";
        echo "<tr><th>Código de Barras</th><th>Nombre</th><th>Descripción</th><th>Categoría</th><th>Imagen</th><th>Stock</th><th>Precio</th><th>Promoción</th><th>Acciones</th></tr>";

        while ($row = $result->fetch_assoc()) {
            if ($row['imagen'] == NULL) {
                $ruta = "<img id='img_prod' src='..\img/noimgproducto.png'>";
            } else {
                $ayuda = '../' . $row['imagen'];
                //$ayuda = "..\img\Productos\cala.webp";
                $ruta = "<img id='img_prod' src='$ayuda'>";
            }

            echo "<tr>";
            echo "<td>" . $row['codigo_barras'] . "</td>";
            echo "<td>" . $row['nombre'] . "</td>";
            echo "<td>" . $row['descripcion'] . "</td>";
            echo "<td>" . $row['tipo'] . "</td>";
            echo "<td> $ruta </td>";
            echo "<td>" . $row['stock'] . "</td>";
            echo "<td>" . $row['precio'] . "</td>";
            echo "<td>" . '- ' . $row['promocion'] . '%' . "</td>";
            echo "<td>
                    <a id='bt' class='acep' href='funcionesProductos/formulario.php?id=" . $row['codigo_barras'] . "'>Editar</a> | 
                    <a id='bt' class='del' href='funcionesProductos/eliminar_producto.php?id=" . $row['codigo_barras'] . "' onclick='return confirm(\"¿Estás seguro?\")'>Eliminar</a>
                  </td>";
            echo "</tr>";
        }

        echo "</table>";
    } else {
        echo "No hay productos disponibles.";
    }

    $conn->close();
    ?>
</body>

</html>