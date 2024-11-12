<?php
include '../conexion.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id = $_POST['id'];
    $codigo_barras = $_POST['codigo_barras'];
    $nombre = $_POST['nombre'];
    $stock = $_POST['stock'];
    $descripcion = $_POST['descripcion'];
    $precio = $_POST['precio'];
    $tipo = $_POST['tipo'];
    $promocion = $_POST['promocion'];

    // Manejo de la imagen
    $imagen = null;

    if (!$imagen) {
        if (isset($_FILES['imagen']) && $_FILES['imagen']['error'] === UPLOAD_ERR_OK) {
            // Directorio destino para la imagen
            $directorio_destino = $_SERVER['DOCUMENT_ROOT'] . "/Papeleria-JJJA/img/Productos/";
            $direc = "img/Productos/";
            // Verificar si la carpeta existe, si no, crearla
            if (!is_dir($directorio_destino)) {
                mkdir($directorio_destino, 0777, true); // Crea la carpeta si no existe
            }
            $imagen = $direc . basename($_FILES['imagen']['name']);
            $img =  $directorio_destino . basename($_FILES['imagen']['name']);
            if (file_exists($_FILES['imagen']['tmp_name'])) {

                if (move_uploaded_file($_FILES['imagen']['tmp_name'], $img)) {
                    echo "Imagen cargada exitosamente.";
                } else {
                    echo "Error al mover la imagen.";
                }
            } else {
                echo "El archivo no existe.";
            }
        } else {
            echo "Error al subir el archivo: " . $_FILES['imagen']['error'];
            $imagen = NULL;
        }
    }

    if ($id) {

        if ($imagen) {
            // Actualizar producto con img
            $sql = "CALL actualizarProductoConImagen(?, ?, ?, ?, ?, ?, ?, ?, @error)";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("sssisdsi", $codigo_barras, $nombre, $imagen, $stock, $descripcion, $precio, $tipo, $promocion);
        } else {
            // Actualizar producto sin img
            $sql = "CALL actualizarProductoSinImagen(?, ?, ?, ?, ?, ?, ?, @error)";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("ssisdsi", $codigo_barras, $nombre, $stock, $descripcion, $precio, $tipo, $promocion);
        }

    } else {
        // Insertar nuevo producto
        $sql = "CALL crearProducto(?, ?, ?, ?, ?, ?, ?, ?, @error)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("sssisdsi", $codigo_barras, $nombre, $imagen, $stock, $descripcion, $precio, $tipo, $promocion);

    }

    // Ejecutar la declaración
    if ($stmt->execute()) {
        // Obtener el valor de error
        $result = $conn->query("SELECT @error AS error");
        $row = $result->fetch_assoc();
        if ($row['error'] == 1) {
            echo "Error al crear/actualizar el producto.";
        } else {
            header("Location: ../productos.php");
        }
    } else {
        echo "Error: " . $stmt->error;
    }

    $stmt->close();
}

$conn->close();
