// Arreglo para almacenar los productos en el carrito
let cart = [];

// Función para agregar un producto al carrito
function addToCart(productName, price, discountPrice) {
  // Usa el precio con descuento si está disponible; de lo contrario, el precio regular

  const finalPrice =
    discountPrice !== null
      ? parseFloat(discountPrice, 10)
      : parseFloat(price, 10);
  const existingProductIndex = cart.findIndex(
    (item) => item.product === productName
  );

  if (existingProductIndex !== -1) {
    cart[existingProductIndex].quantity++;
    openAggCarritoModal(productName);
  } else {
    cart.push({ product: productName, price: finalPrice, quantity: 1 });
    openAggCarritoModal(productName);
  }

  updateCart(); // Actualiza la visualización del carrito
}

// Función para eliminar un producto del carrito
function removeFromCart(productName) {
  const productIndex = cart.findIndex((item) => item.product === productName);

  if (productIndex !== -1) {
    cart[productIndex].quantity--;
    if (cart[productIndex].quantity === 0) {
      cart.splice(productIndex, 1);
    }
  }

  updateCart();
}

// Función para actualizar el carrito
function updateCart() {
  const cartItemsContainer = document.getElementById("cartItems");
  const cartTotal = document.getElementById("cartTotal");

  cartItemsContainer.innerHTML = "";
  let total = 0;
  let itemCount = 0;

  cart.forEach((item) => {
    const itemElement = document.createElement("div");
    itemElement.classList.add("prod");

    itemElement.innerHTML = `
       
            <span>${item.product} - $${item.price} x ${item.quantity}</span>
            <button id="btnEliminar" onclick="removeFromCart('${item.product}')">Eliminar</button>
          
        `;

    cartItemsContainer.appendChild(itemElement);

    total += item.price * item.quantity;
    itemCount += item.quantity;
  });

  cartTotal.textContent = " $" + total.toFixed(2); // Actualiza el total con dos decimales

  // Guarda el carrito en localStorage
  localStorage.setItem("cart", JSON.stringify(cart));
}

// Función para abrir y cerrar el modal del carrito
function openCart() {
  document.getElementById("carrito_ocultar").style.display = "block";
}

function closeCart() {
  document.getElementById("carrito_ocultar").style.display = "none";
  document.getElementById("ocultar_pagos").style.display = "none";
}

// Función para realizar el pago (simulación de la API de Nequi)
function checkout() {
  const totalAmount = document.getElementById("cartTotal").textContent;

  if (totalAmount > 0) {
    alert("Pago exitoso con Nequi. Monto: $" + totalAmount);
    cart = [];
    localStorage.removeItem("cart"); // Elimina el carrito de localStorage
    updateCart();
    closeCart();
  } else {
    alert("El carrito está vacío.");
  }
}
