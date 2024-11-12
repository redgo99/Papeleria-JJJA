document.addEventListener("DOMContentLoaded", function () {

  document.getElementById("ini").addEventListener("click", function () {
    window.location.href = "index.php";
  });

  document.getElementById("enviar").addEventListener("click", function () {
    // Recoger datos del formulario
    const cedula = document.getElementById("cedula").value.trim();
    const nombre = document.getElementById("nombre").value.trim();
    const correo = document.getElementById("email").value.trim();
    const contraseña = document.getElementById("contraseña").value.trim();
    const celular = document.getElementById("celular").value.trim();
    const direccion = document.getElementById("direccion").value.trim();
    const rolElement = document.querySelector('input[name="rol"]:checked');

    // Validar que el rol está seleccionado
    if (!rolElement) {
      alert("Por favor, selecciona un rol.");
      return;
    }
 
    const rol = rolElement.value;

    // Crear objeto de datos
    const datos = {
      table: "usuario",
      cedula,
      nombre,
      correo,
      contraseña,
      celular,
      direccion,
      rol,
    };

    // Enviar solicitud POST
    fetch("PHP/CRUD-U.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(datos),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        return response.json();
      })
      .then((data) => {
        const mensajeEmergente = document.getElementById("mensajeEmergente");
        // Verificar si se recibió una respuesta válida
        if (data && data.respuesta) {
          if (data.respuesta === "Error: 1") {
            mensajeEmergente.innerText = "Error al crear usuario, tipo:\n" + data.respuesta;
            mensajeEmergente.style.backgroundColor = "var(--rojo)";
          } else {
            mensajeEmergente.innerText = "" + data.respuesta;
            mensajeEmergente.style.backgroundColor = "var(--verde)";
            setTimeout(() => {
              window.location.href = "index.php"; // Cambia "index.html" a la URL de tu página de inicio
            }, 2000);
          }
        } else {
          mensajeEmergente.innerText = "Respuesta no válida del servidor.";
          mensajeEmergente.style.backgroundColor = "var(--rojo)";
        }

        mensajeEmergente.style.display = "block";

        setTimeout(() => {
          mensajeEmergente.style.display = "none";
        }, 3000);
      })
      .catch((error) => {
        console.error("Error al realizar la solicitud:", error.data);
        alert("Ocurrió un error al realizar la solicitud. Revisa la consola para más detalles.");
      });
  });
});
