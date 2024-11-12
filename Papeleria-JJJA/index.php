<?php
session_start();

if (isset($_SESSION["email"])) {


} else {
}


?>

<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Papelería Virtual</title>
  <!-- LINK TIPO DE LETRA  "Pacifico", cursive -->
  <link
    href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400..700&family=Fascinate+Inline&family=Pacifico&display=swap"
    rel="stylesheet" />
  <!--  -->

  <link rel="stylesheet" href="Css/estilos.css" />
  <link rel="stylesheet" href="Css/normalize.css" />
  <!--  -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
  <!-- Icono boostrap carrito -->

  <!-- JS -->

  <script src="Js/jquery.js"></script>

  <!-- Cargar Programas -->

  <!-- <script src="Js/Busquedas/allOfertas.js"></script> -->
  <script src="Js/Busquedas/filtros.js"></script>
  <script src="Js/Busquedas/allproductos.js"></script>
  <script src="Js/carrusel.js"></script>
  <script src="JS/carrito.js"></script>

  <script src="JS/login.js"></script>
  <script
    src="https://sandbox.paypal.com/sdk/js?client-id=ARycnZz_TxwRbhcTSO4kuA1HUdj7uaujYx6KpD5EmGKDm47cei1RpDt8HUQBoM2Y5z6d7laDrd7N9DZC"></script>


</head>

<body>
  <div id="mensajeEmergente" class="sesion"></div>
  <header class="menu">
    <a href="#inicio" style="text-decoration: none; color: inherit">
      <div class="logo">
        <img src="img/Logo.png" alt="No carga wey">
        <p>Papelería</p>
      </div>
    </a>
    <nav>
      <ul id="men">
        <li><a href="#inicio">Inicio</a> |</li>
        <li><a href="#productos">Productos</a> |</li>
        <li><a href="#ofertas">Ofertas</a> |</li>
        <li><a href="#contacto">Contacto</a></li>
      </ul>
    </nav>

    <nav>
      <ul>
        <li>
          <a id="car" href="javascript:void(0)" onclick="openCart()"><i class="bi bi-cart4" id="carr"></i></a> |
        </li>
        <!-- Carrito -->
        <?php if (isset($_SESSION['email'])): ?>
          <?php if ($_SESSION['rol'] === 'admin' || $_SESSION['rol'] === 'Administrador'): ?> <!-- poner Administrador -->
            <li>
              <a href="javascript:void(0);" class="menu-icon" onclick="openProfileModal()">
                <i id="conf" class="bi bi-gear-fill"></i></a>
            </li>
            <li> | </li>
          <?php endif; ?>
          <li>
            <a href="javascript:void(0);" onclick="openPerfilModal()">
              <i id="ins" class="bi bi-person-circle"></i>
            </a>
          </li>
          <li> | </li>
          <li>
            <a id="ses" href="PHP/logout.php" class="logout-btn" onclick="cerrarSesion()">Cerrar Sesión
            </a>
          </li>
        <?php else: ?>
          <li>
            <a id="ses" class="open-modal-btn" onclick="openModal()">Iniciar Sesión</a>
          </li>
        <?php endif; ?>
      </ul>
    </nav>
  </header>

  <div class="cont">

    <!-- Inicio -->

    <section class="inicio" id="inicio">

        <div id="carrusel">
        </div>

    </section>

    <!-- Ofertas -->

    <section class="ofertas" id="ofertas">
      <h1>Ofertas</h1>


      <div id="cargar_ofertas">

      </div>
    </section>

    <!-- Productos -->

    <section class="productos" id="productos">
      <span id="ord">
            <h1>Productos</h1>
      <!--  filtro-->
      <div class="filter-container">
        <input type="text" id="search" placeholder="Buscar por nombre"
          oninput="buscarProductos()" /><!-- FILTRO POR DESCRIPCION -->
        <!-- <i id="sr" class="bi bi-search"></i> -->
        <select id="category" onchange="filtraCategoria()">
          <!-- HACER SCRIPT DE FILTRO DE PRODUCTOS POR CATEGORIA -->
          <option value="all">Todas las Categorías</option>
          <!-- Aca se agregan  las categorias -->
          <option value="Utiles escolares">Utiles escolares</option>
          <option value="Papelería">Papelería</option>
          <option value="Tecnología">Tecnología</option>
          <option value="Confitería">Confitería</option>
        </select>
      </div>
      </span>
  

      <!--filtro  -->


      <span id="ocultarBusquedas">
        <div id="cargar_busquedas">
        </div>
      </span>

      <span id="ocultarProductos">
        <div id="cargar_productos">
        </div>
      </span>


    </section>
    <!-- Contactos -->
    <footer class="contactos" id="contacto">
      <h1>Contáctanos</h1>
      <p>Universidad Católica de Pereira</p>
      <p>Carrera 21 No. 49-95 Av. de las Américas Pereira, Colombia</p>
      <br />
      <a id="xx" href="https://wa.me/573122007849" target="_blank"><i class="bi bi-whatsapp"></i></a>
      <a id="xx" href="https://www.instagram.com/papeleriaucp/" target="_blank"><i class="bi bi-instagram"></i></a>
    </footer>
  </div>


  <script src="Js/sesion.js"></script>

  <!-- modal AggCarritoModal -->
  <div class="aggCarritoModal" id="aggCarritoModal">
    <div class="modal-contentAgg">
      <span class="close" onclick="closeAggCarritoModal()">&times;</span>
      <p class="modalTextAgg" id="modalTextAgg"></p>
      </span>
    </div>
  </div>

  <!-- loginModal se usa en  el archivo sesion.js -->
  <div id="loginModal" class="modal">
    <div class="modal-content">
      <span class="close-modal-btn" onclick="closeModal()">&times;</span>
      <h2>Iniciar Sesión</h2>
      <div id="error">

      </div>
      <br>
      <form id="loginForm" action="PHP/login.php" method="POST">
        <div class="form-group">
          <label for="email">Correo Electrónico:</label>
          <input type="email" id="email" name="email" required />
        </div>
        <div class="form-group">
          <label for="password">Contraseña:</label>
          <input type="password" id="password" name="password" required />
        </div>
        <button type="submit" class="submit-btn">Entrar</button>
      </form>
      <br>

      <div class="create-account">
        <a href="registrar.php"><button type="submit" class="submit-btn">Crear Usuario</button></a>
      </div>

    </div>
  </div>
  </div>


  <!-- modal carrito compra -->
  <span id="carrito_ocultar" class="carrito_">
    <div id="carritoModal">

      <span class="close-modal-btn" onclick="closeCart()">&times;</span>


      <h2>Carrito de Compras</h2>

      <span id="cont_car_todo">
        <div id="cartItems">
          <!-- ACA VAN LOS PRODUCTOS QUE SE AGREGEN A CARRITO -->

        </div>
        <div id="cont_pagos">
          <p>Total: <span id="cartTotal">0</span></p> <!-- MONTO TOTAL -->
          <button id="btnPagos" onclick="abrirMetodosPago()">Métodos de pago</button>
        </div>
      </span>

      <!-- <div class="compraExi" id="compraExi">
          <div class="modal-compraExi">
          </div>
        </div> -->
    </div>

    <div id="lado_iz_pagos">
      <div id="ocultar_pagos">
        <div id="paypal-button-container"></div>
        <script>
          // Actualiza el código de PayPal para que tome el valor correcto del carrito
          <div id="paypal-button-container"></div>
<script src="https://www.paypal.com/sdk/js?client-id=YOUR_CLIENT_ID"></script>
        <script>
        paypal.Buttons({
  createOrder: function(data, actions) {
    const totalAmount = parseFloat(document.getElementById("cartTotal").textContent.replace('$', '').trim());
    return actions.order.create({
      purchase_units: [{
        amount: {
          value: totalAmount.toFixed(2)
        }
      }]
    });
  },
  onApprove: function(data, actions) {
    const totalAmount = parseFloat(document.getElementById("cartTotal").textContent.replace('$', '').trim());
    return actions.order.capture().then(function(details) {
      alert('Transacción completada por ' + details.payer.name.given_name);

      // Enviar los datos al servidor (PHP) después de la compra
      
      // Limpiar el carrito después del pago
      cart = [];
      localStorage.removeItem("cart"); // Elimina el carrito de localStorage
      updateCart(); // Actualiza la interfaz del carrito
      closeCart(); // Cierra el modal del carrito

      // Mostrar modal de éxito (opcional)
      const modal = document.getElementById("compraExi");
      modal.style.display = "flex";
      setTimeout(() => {
        modal.style.display = "none";
      }, 2000);
    });
  } 
}).render('#paypal-button-container');


        </script>


        </script>
        <button onclick="checkout()" class="submit-btn">Pagar con Nequi</button>
      </div>
    </div>

  </span>

  <!-- Modal crud -->

  <script src="Js/modals.js"></script>
  <div id="profileModal" class="modal-profile">
    <div class="modal-content">
      <span class="close" onclick="closeProfileModal()">&times;</span>
      <h2>Bienvenido, <?php echo $_SESSION['nombre']; ?></h2> <!-- Muestra el email del usuario -->
      <button onclick="openCrud1()">Configuración Productos </button>
      <button onclick="openCrud2()">Configuración Usuarios</button>
      <button onclick="openCrud3()">Registros de auditoria</button>
    </div>
  </div>


  <!-- Modal de Perfil -->
  <div id="perfilModal" class="modal-perfil">
    <div class="modal-content">
      <span class="close-modal-btn" onclick="closePerfilModal()">&times;</span>
      <h2>Perfil de Usuario</h2>
      <p><strong>Nombre:</strong> <?php echo $_SESSION['nombre'] ?? 'Nombre no disponible'; ?></p>
      <p><strong>Correo:</strong> <?php echo $_SESSION['email'] ?? 'Correo no disponible'; ?></p>
      <p><strong>Rol:</strong> <?php echo $_SESSION['rol'] ?? 'Rol no disponible'; ?></p>

      <p></p>
      <a
        href="PHP/funcionesUsuario/formularioUsuarios.php?id=<?php echo $_SESSION['user_id'] ?? 'ID no disponible'; ?>">
        <br>
        <button class="actualizarUsuarioBoton">Actualizar información.</button>


      </a>
      <a
        href="PHP\VerHistorialCompras\historialCompras.php?id=<?php echo $_SESSION['user_id'] ?? 'ID no disponible'; ?>">
        <button class="verCompras">Ver historial de compras.</button>
      </a>
    </div>
  </div>
</body>

</html>