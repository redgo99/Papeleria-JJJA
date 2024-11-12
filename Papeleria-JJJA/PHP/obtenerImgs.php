<?php
include 'conexion.php';

$query = "SELECT imagen FROM producto";
$result = $conn->query($query);

$imagenes = array();

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $imagenes[] = $row['imagen'];
    }
    echo json_encode($imagenes);
} else {
    echo json_encode([]);
}
$conn->close();
?>
