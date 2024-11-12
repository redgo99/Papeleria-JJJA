let imagenes = [];  
let nImagen = 0;  
function cargarImagenes() {
  fetch('PHP/obtenerimgs.php')  
    .then(response => response.json())  
    .then(data => {
      imagenes = data;  
      console.log(imagenes);  
    })
    .catch(error => console.error('Error al cargar las imágenes:', error));
}

function cambiar() {
  if (imagenes.length === 0) return;  
  
  const contenedor = document.getElementById("carrusel");
  contenedor.innerHTML = `<img src="${imagenes[nImagen]}" class="actual">`;  
  nImagen = (nImagen + 1) % imagenes.length;  
}

cargarImagenes();

setInterval(cambiar, 2000);
