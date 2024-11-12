<?php

include '..\conexion.php';

if(isset($_POST["nombre"])){
    $nombre = $_POST["nombre"];
}else{
    $nombre="No listada";
}

$query = "CALL buscarProductosPorNombre('$nombre' ,@error)";
$result = $conn->query($query);

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {

        $nose2 = "<p>Precio: $" . number_format($row['precio'], 2) . "</p>";
        $nose="";

        //|| !file_exists("../" . $row['imagen'])

        if ($row['imagen'] == NULL  ) {
            $ruta = "<img id='img_prod' src='img/noimgproducto.png'>";
        } else {
            $ayuda = $row['imagen'];
            //$ayuda = "img\Productos\cala.webp";
            $ruta = "<img id='img_prod' src='$ayuda'>";
        }


        if ($row['promocion'] == 0) {
            $pro = "<p class='promo' id='promo'></p>";
            $preciott=$row['precio'];
        } else {
            if (number_format($row['promocion'], 2) <= 100 && number_format($row['promocion'], 2) > 0) {
                $preciott = $row['precio'] - ($row['precio'] * ($row['promocion'] / 100));
                $oferta = number_format($preciott, 2);
                $nose = "<p>Precio actual: $$oferta </p>";
                $nose2 = "<p style='text-decoration: line-through;' >Precio: $" . number_format($row['precio'], 2) . "</p>";
            } else {

                $nose = "<p>Fallo en el descuento</p>";
            }
            $pro = "<p class='promo' id='promo'>Promoción: {$row['promocion']}%</p>";
        }

        echo "
            <div class='p_producto'>
                <h3 style='text-transform: uppercase;'>{$row['nombre']}</h3>
                <hr>
                <p>$ruta<p>
                <p>Descripción: {$row['descripcion']}</p>
                <p>Categoría: {$row['tipo']}</p> 
                $nose2
                <hr>
                $pro
                $nose
                <button id='aggCarrito' onclick=\"addToCart('{$row['nombre']}','{$row['precio']}','$preciott')\">Agregar al carrito</button>
                
            </div>
        ";
    }
} else {
    echo "<p  class='alertaBusqueda' >No se encontraron productos con el nombre: $nombre.</p>";
}

$conn->close();
?>