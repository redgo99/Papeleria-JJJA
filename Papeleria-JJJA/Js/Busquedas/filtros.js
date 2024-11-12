function filtraCategoria() {
    const select = document.getElementById("category");
    const categoriaSeleccionada = select.value;
  
  
    const div = document.getElementById("ocultarProductos");
    const div2 = document.getElementById("ocultarBusquedas");
    const bus = document.getElementById("search").value='';
  
  
    var mensaje;
    if (categoriaSeleccionada === "all") {
      div.style.display = "block";
      div2.style.display = "none";
    } else {
    //   mensaje = "Mostrando productos de la categoría: " + categoriaSeleccionada; 
      div.style.display = "none";
      div2.style.display = "block";
        

      const niieda = "PHP/FuncionesBusquedas/obtenerPCategoria.php";
    //   window.location.href =niieda;

      fetch(niieda, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'categoria=' + encodeURIComponent(categoriaSeleccionada)
        //body: '?categoria=' + categoriaSeleccionada// Enviar el valor de la categoría
      })
      .then(response => response.text()) // Obtener la respuesta del servidor
      .then(data => {
        document.getElementById('cargar_busquedas').innerHTML = data
      })
      .catch(error => {
        console.error('Error:', error);
      });
    }
  
    // document.getElementById("cargar_busquedas").innerText = mensaje;
  }
  
  function buscarProductos() {
    var busqueda = document.getElementById("search").value;

  
    const div = document.getElementById("ocultarProductos");
    const div2 = document.getElementById("ocultarBusquedas");
    
      
  
    var mensaje;
    if (busqueda === "") {
      div.style.display = "block";
      div2.style.display = "none";
    } else {
    //   mensaje = "Mostrando productos de la categoría: " + categoriaSeleccionada; 
  
      div.style.display = "none";
      div2.style.display = "block";
        

      const niieda = "PHP/FuncionesBusquedas/obtenerPBusqueda.php";
    //   window.location.href =niieda;

      fetch(niieda, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'nombre=' + encodeURIComponent(busqueda)
        //body: '?categoria=' + categoriaSeleccionada// Enviar el valor de la categoría
      })
      .then(response => response.text()) // Obtener la respuesta del servidor
      .then(data => {
        document.getElementById('cargar_busquedas').innerHTML = data
      })
      .catch(error => {
        console.error('Error:', error);
      });
    }
  
  }
  