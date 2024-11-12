<?php
include '../conexion.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id = $_POST['id'];
    $cedula = $_POST['cedula'];
    $nombre = $_POST['nombre'];
    $correo = $_POST['correo'];
    $contraseña = $_POST['contraseña'];
    $celular = $_POST['celular'];
    $direccion = $_POST['direccion'];
    $rol = $_POST['rol']; 

    if ($id) {
        // Actualizar usuario
        $sql = "CALL actualizarUsuario(?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssssssss", $cedula, $nombre, $correo, $contraseña, $celular, $direccion, $rol, $id);
    } else {
        // Insertar nuevo usuario
        $sql = "CALL crearUsuario(?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("sssssss", $cedula, $nombre, $correo, $contraseña, $celular, $direccion, $rol);
    }

    // Ejecutar la declaración
    if ($stmt->execute()) {
        // Obtener el valor de error
        $result = $conn->query("SELECT @error AS error");
        $row = $result->fetch_assoc();
        if ($row['error'] == 1) {
            echo "Error al crear/actualizar el usuario.";
        } else {
            header("Location: ../usuarios.php");
        }
    } else {
        echo "Error: " . $stmt->error;
    }

    $stmt->close();
}

$conn->close();
