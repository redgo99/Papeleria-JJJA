<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "proyecto_mp4_db2";
$port = "33065";

$conn = new mysqli($servername, $username, $password, $dbname, $port);

// Verificar si hubo un error de conexión
if ($conn->connect_errno) {
    // Preparar respuesta de error en formato JSON
    $respuesta = $conn->connect_error;
    $respuesta = json_encode(array("mensaje" => $respuesta));
    header('Content-Type: application/json');
    $conn->close();
    die(); // Detener el script en caso de error
} else {
    // Preparar respuesta exitosa en formato JSON
    //No muestra respuesta -  hace el procedimiento o consulta de forma inmediata - segun yo jj

}
?>