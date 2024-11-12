async function cargarProductos() {
  try {
    const response = await fetch("PHP/obtenerprod.php");
    const html = await response.text();
    const div = document.getElementById("ocultarProductos");
    div.style.display = "block";

    const div2 = document.getElementById("ocultarBusquedas");
    div2.style.display = "none";

    document.getElementById("cargar_productos").innerHTML = html;
  } catch (error) {
    console.error("Error al cargar productos:", error);
    document.getElementById("cargar_productos").innerHTML =
      "Hubo un problema cargando los productos.";
  }

  try {
    const response = await fetch("PHP/obtenerOfertas.php");
    const html = await response.text();
    document.getElementById("cargar_ofertas").innerHTML = html;
  } catch (error) {
    console.error("Error al cargar ofertas:", error);
    document.getElementById("cargar_ofertas").innerHTML =
      "Hubo un problema cargando los productos.";
  }
}

window.onload = cargarProductos;
