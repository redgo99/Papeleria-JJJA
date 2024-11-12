<?php
$metodo = $_SERVER['REQUEST_METHOD'];
//echo ($metodo);

$datos = json_decode(file_get_contents("php://input"), true);

//crear producto
if ($metodo == "POST") {
    $tabla = $datos['table'];
    if ($tabla == "producto") {
        include('conexion.php');
        $codb = $datos['codigo_barras'];
        $name = $datos['nombre'];
        $imagen = $datos['img'];
        $stock = $datos['stock'];
        $descp = $datos['descipcion'];
        $prec = $datos['precio'];
        $tip = $datos['tipo'];
        $promo = $datos['promocion'];

        // Ejecuta la llamada al procedimiento almacenado
        $query = "CALL crearProducto('$codb', '$name', '$img', '$stock', '$descp', '$prec', '$tip', '$promo', @error)";
        $conn->query($query);

        // Consulta para obtener el valor de @error
        $result = $conn->query("SELECT @error AS error");
        $row = $result->fetch_assoc();
        $pp = $row['error'];

        if ($pp == 0) {
            $respuesta = "inserto";
        } else {
            $respuesta = "Error: " . $conn->error;
        }
    }
    $conn->close();
    header('Content-Type: application/json');
    echo json_encode($respuesta);
}

//Eliminar producto
if ($metodo == "DELETE") {
    include('conexion.php');
    $tabla = $datos['table'];

    if ($tabla == "producto") {
        $id = $datos['codBarr'];

        // Llama al procedimiento almacenado que establece @error
        $query = "CALL borrarProducto('$id', @error)";
        $conn->query($query);

        // Consulta para obtener el valor de @error y almacenarlo en $pp
        $result = $conn->query("SELECT @error AS error");
        $row = $result->fetch_assoc();
        $pp = $row['error'];

        // Verifica el valor de $pp
        if ($pp == 0) {
            $respuesta = "Producto eliminado";
        } else {
            $respuesta = "Error: " . $pp;
        }
    }
    $conn->close();
    header('Content-Type: application/json');
    echo $respuesta;
}
//Actualizar productos
if ($metodo == "PUT") {
    $tabla = $datos['table'];
    if ($tabla == "producto") {
        include('conexion.php');
        $codb = $datos['codigo_barras'];
        $name = $datos['nombre'];
        $imagen = $datos['img'];
        $stock = $datos['stock'];
        $descp = $datos['descipcion'];
        $prec = $datos['precio'];
        $tip = $datos['tipo'];
        $promo = $datos['promocion'];

        $query = "call actualizarProducto('$codb', '$name', '$stock', '$descp', '$prec', '$tip', '$promo', @error)";
        $conn->query($query);

        // Consulta para obtener el valor de @error y almacenarlo en $pp
        $result = $conn->query("SELECT @error AS error");
        $row = $result->fetch_assoc();
        $pp = $row['error'];

        if ($pp == 0) {
            $respuesta = "Actualizo";
        } else {
            $respuesta = "Error: " . $conn->error;
        }
    }
    $conn->close();
    header('Content-Type: application/json');
    echo $respuesta;
}

if ($metodo == "GET") {
    include('conexion.php');
    $query = "select * from producto";
    $resultado = $conn->query($query);
    $datos = array();
    while ($fila = $resultado->fetch_assoc()) {
        $datosi[] = $fila;
    }
    $respuesta = json_encode($datosi);
    header('Content-Type: application/json');
    echo $respuesta;
    $conn->close();
}

?>