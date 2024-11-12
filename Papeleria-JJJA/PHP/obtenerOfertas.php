<?php
include 'conexion.php';

$query = "CALL productosPromocionMayorUno(@error)";
$result = $conn->query($query);

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {


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
    

        if($row['imagen'] == NULL  || !file_exists("../" . $row['imagen'])){
            $ruta = "<img id='img_prod' src='img/noimgproducto.png'>";
        }else{
            $ayuda = $row['imagen'];
            //$ayuda = "img\Productos\cala.webp";
            $ruta = "<img id='img_prod' src='$ayuda'>"; 
        }
        echo "
            <div class='p_producto'>
                <h3 style='text-transform: uppercase;' >{$row['nombre']}</h3>
                <hr>
                <p>$ruta<p>
                <p>Descripción: {$row['descripcion']}</p>
                <p>Categoría: {$row['tipo']}</p>
                <p style='text-decoration: line-through;' >Precio: $" . number_format($row['precio'], 2) . "</p>
                <hr>
                <p id='promo'>Promoción: {$row['promocion']}%</p>
                $nose
                <button id='aggCarrito' onclick=\"addToCart('{$row['nombre']}','{$row['precio']}','$preciott')\">Agregar al carrito</button>
                
            </div>
        ";
    }
} else {
    echo "<p class='alertaPO'>Actualmente, no hay productos en oferta. ¡Vuelve pronto para ver nuevas promociones!</p>";
}

$conn->close();
?>