function cerrarSesion(){

  const mensajeEmergente = document.getElementById("mensajeEmergente");
  mensajeEmergente.style.display = "block";
  mensajeEmergente.innerText = "Ha cerrado sesión con éxito";

  setTimeout(() => {
    mensajeEmergente.style.display = "none";
    window.location.href = "PHP/logout.php";
  }, 2000);

}