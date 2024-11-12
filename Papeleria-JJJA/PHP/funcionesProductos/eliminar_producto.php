<?php
include '../conexion.php';

if (isset($_GET['id'])) {
    $codigo_barras = $_GET['id'];
    $error = 0;

    $sql = "CALL borrarProducto(?, @error)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $codigo_barras);
    
    if ($stmt->execute()) {
        // Obtener el valor de error
        $result = $conn->query("SELECT @error AS error");
        $row = $result->fetch_assoc();
        if ($row['error'] == 1) {
            echo "Error al eliminar el producto.";
        } else {
            header("Location: ../productos.php");
        }
    } else {
        echo "Error: " . $stmt->error;
    }
    $stmt->close();
}

$conn->close();
?>
