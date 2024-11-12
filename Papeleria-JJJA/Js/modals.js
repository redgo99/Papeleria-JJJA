/* MODAL CRUDS */

function openProfileModal() {
  document.getElementById("profileModal").style.display = "block";
}

// Función para cerrar el modal
function closeProfileModal() {
  document.getElementById("profileModal").style.display = "none";
}

// Función para redirigir al primer CRUD
function openCrud1() {
  window.location.href = "PHP/productos.php"; // Ruta correcta si está en el mismo directorio
}

// Función para redirigir al segundo CRUD
function openCrud2() {
  window.location.href = "PHP/usuarios.php"; // Reemplaza con la ruta real
}

// Función para redirigir al tercer CRUD
function openCrud3() {
  window.location.href = "PHP/registros.php"; // Reemplaza con la ruta real
}
/* FIN MODAL CRUDS */

/* MODAL PERFIL */
function openPerfilModal() {
  document.getElementById("perfilModal").style.display = "block";
}

function closePerfilModal() {
  document.getElementById("perfilModal").style.display = "none";
}

// Cerrar el modal al hacer clic fuera de él
window.onclick = function (event) {
  const modal = document.getElementById("perfilModal");
  if (event.target === modal) {
    modal.style.display = "none";
  }
};
/* FIN MODAL PERFIL */

/* MODAL AGREGAR PRODUCTO A CARRITO */

function openAggCarritoModal(productName) {
  const modal = document.getElementById("aggCarritoModal");
  modal.style.display = "block";

  const texto = document.getElementById("modalTextAgg");
  texto.innerHTML = "Producto agregado al carrito: " + productName;

  setTimeout(() => {
    modal.style.display = "none";
  }, 400);
}

/* FIN MODAL AGREGAR PRODUCTO A CARRITO */

/* CERRAR CARRITO DANDO CLICK AFUERA */
// Cerrar el modal al hacer clic fuera de él
window.onclick = function(event) {
  const modal = document.getElementById("ocultar_pagos");
  
  // Verifica si el clic fue fuera del modal
  if (event.target === modal) {
    modal.style.display = "none";
  }
};

/* FIN CERRAR CARRITO DANDO CLICK AFUERA */

// Funcion para mostar/ocultar

function abrirMetodosPago() {
  const met = document.getElementById("ocultar_pagos");

  if (met.style.display === "block") {
    met.style.display = "none";
    
  } else {
    met.style.display = "block";
    
  }
}
