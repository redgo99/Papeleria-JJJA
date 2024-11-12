<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Productos</title>
    <!-- LINK TIPO DE LETRA  "Pacifico", cursive -->
    <link
        href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400..700&family=Fascinate+Inline&family=Pacifico&display=swap"
        rel="stylesheet" />
    <!--  -->
    <link rel="stylesheet" href="../../css/estilosEditar.css">
</head>

<body>
    <script>
        function previewImage(event) {
            const file = event.target.files[0];
            const reader = new FileReader();

            reader.onload = function (e) {
                // Muestra la imagen en el contenedor
                const imgPreview = document.getElementById('imgPreview');
                const cont = document.getElementById('ccc');
                imgPreview.src = e.target.result;  // Asigna la imagen cargada a la vista previa
                cont.style.display = 'block';  // Hace visible la imagen
            }

            // Si se ha seleccionado un archivo, lee el contenido y lo muestra
            if (file) {
                reader.readAsDataURL(file);
            }
        }
    </script>

    <h2><?php echo isset($_GET['id']) ? "Editar Producto" : "Agregar Producto"; ?></h2>

    <?php
    include '../conexion.php';

    $id = "";
    $codigo_barras = "";
    $nombre = "";
    $stock = "";
    $descripcion = "";
    $precio = "";
    $tipo = "";
    $promocion = "";

    if (isset($_GET['id'])) {
        $id = intval($_GET['id']);
        $sql = "SELECT * FROM producto WHERE codigo_barras = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $resultado = $stmt->get_result();
        $producto = $resultado->fetch_assoc();

        $codigo_barras = $producto['codigo_barras'];
        $nombre = $producto['nombre'];
        $stock = $producto['stock'];
        $descripcion = $producto['descripcion'];
        $precio = $producto['precio'];
        $tipo = $producto['tipo'];
        $promocion = $producto['promocion'];
    }
    ?>

    <form action="procesar_producto.php" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="<?php echo $id; ?>">

        <label for="codigo_barras">Código de Barras:</label><br>
        <input type="number" id="codigo_barras" name="codigo_barras" value="<?php echo $codigo_barras; ?>"
            required><br><br>

        <label for="nombre">Nombre:</label><br>
        <input type="text" id="nombre" name="nombre" value="<?php echo $nombre; ?>" required><br><br>

        <label for="imagen">Imagen:</label>
        <!-- Contenedor para mostrar la vista previa de la imagen -->
        <div id="ccc">
            <div id="con_img">
                <img id="imgPreview" src="" alt="Vista previa de la imagen">
            </div>
        </div>

        <br>
        <input type="file" id="imagen" name="imagen" onchange="previewImage(event)">



        <label for="stock">Stock:</label><br>
        <input type="number" id="stock" name="stock" value="<?php echo $stock; ?>" required><br><br>

        <label for="descripcion">Descripción:</label><br>
        <textarea id="descripcion" name="descripcion" rows="4" cols="50"><?php echo $descripcion; ?></textarea><br><br>

        <label for="precio">Precio:</label><br>
        <input type="number" id="precio" name="precio" step="0.01" value="<?php echo $precio; ?>" required><br><br>

        <label for="tipo">Tipo:</label><br>
        <select id="tipo" name="tipo" required>
            <option value="">Selecciona un tipo</option> <!-- Opción predeterminada -->
            <option value="Útiles Escolares" <?php echo $tipo == 'Útiles Escolares' ? 'selected' : ''; ?>>Útiles Escolares</option>
            <option value="Papelería" <?php echo $tipo == 'Papelería' ? 'selected' : ''; ?>>Papelería</option>
            <option value="Tecnología" <?php echo $tipo == 'Tecnología' ? 'selected' : ''; ?>>Tecnología</option>
            <option value="Confitería" <?php echo $tipo == 'Confitería' ? 'selected' : ''; ?>>Confitería</option>
        </select><br><br>

        <label for="promocion">Promoción:</label><br>
        <input type="number" min="0" max="100" id="promocion" name="promocion"
            value="<?php echo $promocion; ?>"><br><br>

        <input type="submit" value="<?php echo isset($_GET['id']) ? 'Actualizar Producto' : 'Agregar Producto'; ?>">
    </form>

    <a href="../productos.php">Volver al listado de Productos</a>
</body>

</html>