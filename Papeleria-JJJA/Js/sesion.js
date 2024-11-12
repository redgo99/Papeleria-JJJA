function openModal() {
  document.getElementById("loginModal").style.display = "flex";
}

function closeModal() {
  document.getElementById("loginModal").style.display = "none";
}

window.onclick = function (event) {
  const modal = document.getElementById("loginModal");
  if (event.target == modal) {
    closeModal();
  }
};
/*
$(document).ready(function () {
  $("#login-form").on("submit", function (event) {
    event.preventDefault();

    $.ajax({
      url: "PHP/login.php",
      type: "POST",
      data: $(this).serialize(),
      success: function (response) {
        try {
          var data = JSON.parse(response);
          if (data.error) {
            $("#error-message").text(data.error).show();
          } else {
            window.location.href = "/Papeleria-JJJA/index.php";
          } 
        } catch (e) {
          console.error("Error al analizar la respuesta:", e);
        }
      },
      error: function () {
        $("#error-message").text("Hubo un error en la solicitud.").show();
      },
    });
  });
}); */

$(document).ready(function () {
  $("#loginForm").on("submit", function (event) {
    event.preventDefault();
    
    document.getElementById("error").style.display="block";
    $.ajax({
      url: "PHP/login.php",
      type: "POST",
      data: $(this).serialize(),
      success: function (response) {
        try {
          var data = JSON.parse(response);
          if (data.error) {
            $("#error").text(data.error).show();
            document.getElementById("error").style.color="var(--rojo)";
          } else if (data.success) {
            $("#error").text(data.success).show();
            document.getElementById("error").style.color="var(--chillon)";
            setTimeout(function () {
              window.location.href = "/Papeleria-JJJA/index.php";
            }, 2000); // Redirige después de mostrar el mensaje
          }
        } catch (e) {
          console.error("Error al analizar la respuesta:", e);
          $("#error").text("Hubo un error al procesar la respuesta.").show();
          document.getElementById("error").style.color="var(--rojo)";
        }color
      },
      error: function () {
        $("#error").text("Hubo un error en la solicitud.").show();
        document.getElementById("error").style.color="var(--rojo)";
       
      },
    });
  });
});
