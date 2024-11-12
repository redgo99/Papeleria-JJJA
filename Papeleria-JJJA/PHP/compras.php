<?php
$metodo = $_SERVER['REQUEST_METHOD'];
$datos = json_decode(file_get_contents("php://input"), true);

if ($metodo == "POST") {
   
        include('conexion.php');

        // Definir parámetros de entrada para la llamada al procedimiento almacenado
        $fecha = date('Y-m-d');
        $correo = $datos['correo'];
        $metodoPago = $datos['pago'];
        $costo = $datos['costo'];
        $impuesto = $datos['impuesto'];
        $descuento = $datos['descuento'];
        $costoTotal = $datos['costo_total'];
        $cedula = $datos['id'];
        $codigoBarras = $datos['codigo_barras'];
        $cantidad = $datos['cant'];
        $estado = $datos['estado'];

        // Ejecuta la llamada al procedimiento almacenado
        $query = "CALL verificar_y_comprar(
            '$fecha', '$correo', '$metodoPago', $costo, $impuesto, $descuento, $costoTotal, 
            '$cedula', '$codigoBarras', $cantidad, '$estado', @error, @error_message
        )";
        $conn->query($query);

        // Consultar los valores de salida @error y @error_message
        $result = $conn->query("SELECT @error AS error, @error_message AS error_message");
        $row = $result->fetch_assoc();
        $pp = $row['error'];
        $error_message = $row['error_message'];

        // Verificar si hubo un error o si la transacción fue exitosa
        if ($pp == 0) {
            $respuesta = "La compra fue realizada con éxito.";
        } else {
            $respuesta = "Error: " . $error_message;
        }

        $conn->close();
        header('Content-Type: application/json');
        echo json_encode($respuesta);
}
?>
