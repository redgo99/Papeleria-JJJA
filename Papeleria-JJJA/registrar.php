<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Registrar usuarios</title>
  <link rel="stylesheet" href="Css/registrar-estilos.css" />
  <link rel="stylesheet" href="Css/normalize.css">
  <script type="text/javascript" src="Js/jquery.js"></script>
  <script type="text/javascript" src="Js/admin.js"></script>

</head>

<body>
  <div id="mensajeEmergente" class="emergente"></div> 
  <span id="n">
    <div id="cont">
      <label for="nombre">Nombre Usuario:</label>
      <br> </br>
      <input type="text" id="nombre" maxlength=100 name="nombre" placeholder="Nombre usuario" required />

      <label for="cedula">Cédula:</label>
      <br> </br>
      <input type="number" id="cedula" maxlength=10 name="cedula" placeholder="Cedula" required />

      <label for="celular">Celular:</label>
      <br> </br>
      <input type="number" id="celular" maxlength=10 name="celular" placeholder="Celular" required />

      <label for="email">Correo Electrónico:</label>
      <br> </br>
      <input type="email" id="email" maxlength=20 name="email" placeholder="Correo electronico" required />

      <label for="direccion">Dirección:</label>
      <br> </br>
      <input type="text" id="direccion" name="direccion" placeholder="Direccion" required />

      <label for="contraseña">Contraseña:</label>
      <br> </br>
      <input type="password" id="contraseña" maxlength=15 name="contraseña" placeholder="***********" required />

      <label for="rol">Rol:</label>
      <div class="roles">

        <label for="admin"> <input type="radio" id="admin" name="rol" value="Administrador" required />
          Administrador</label>

        <p style="color: white;">|</p>

        <label for="cliente"><input type="radio" id="cliente" name="rol" value="cliente" checked required />
          Cliente</label>
      </div>

      <br> </br>
      <button type="button" id="enviar">Crear</button>
      <br> </br>
      <button type="button" id="ini">Volver</button>
    </div>
  </span>

</body>

</html>