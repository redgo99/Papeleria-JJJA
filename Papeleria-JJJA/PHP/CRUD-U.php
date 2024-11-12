<?php
$metodo = $_SERVER['REQUEST_METHOD'];
$datos = json_decode(file_get_contents("php://input"), true);

// Incluye la conexión y valida si hay un error en la conexión
include('conexion.php');
if ($conn->connect_error) {
    header('Content-Type: application/json');
    echo json_encode(['respuesta' => 'Error de conexión: ' . $conn->connect_error]);
    exit;
}

// CRUD Usuarios
if ($metodo == "GET") {
    if (isset($datos['id'])) {
        $query = "SELECT * FROM usuario WHERE id =  '$datos[id]'";
    } else {
        $query = "SELECT * FROM usuario";
    }

    $resultado = $conn->query($query);
    $datosi = [];

    if ($resultado) {
        while ($fila = $resultado->fetch_assoc()) {
            $datosi[] = $fila;
        }
        $respuesta = json_encode($datosi);
    } else {
        $respuesta = json_encode(['respuesta' => 'Error: ' . $conn->error]);
    }

    header('Content-Type: application/json');
    echo $respuesta;
    $conn->close();
    exit;
}

// Crear Usuario
if ($metodo == "POST") {
    $tabla = $datos['table'] ?? null;
    if ($tabla === "usuario") {
        $ced = $datos['cedula'] ?? '';
        $name = $datos['nombre'] ?? '';
        $email = $datos['correo'] ?? '';
        $contr = $datos['contraseña'] ?? '';
        $cel = $datos['celular'] ?? '';
        $dir = $datos['direccion'] ?? '';
        $rol = $datos['rol'] ?? '';

        if (empty($ced) || empty($name) || empty($email) || empty($contr) || empty($rol)) {
            $respuesta = "Error: Campos requeridos faltantes";
        } else {
            $query = "CALL crearUsuario('$ced', '$name', '$email', '$contr', '$cel', '$dir', '$rol', @error)";
            if ($conn->query($query)) {
                $result = $conn->query("SELECT @error AS error");
                $row = $result->fetch_assoc();
                $pp = $row['error'] ?? 1;

                $respuesta = ($pp == 0) ? "Usuario insertado correctamente" : "Error: " . $pp;
            } else {
                $respuesta = "Error en la consulta: " . $conn->error;
            }
        }
    } else {
        $respuesta = "Error: Tabla no especificada o no válida";
    }

    $conn->close();
    header('Content-Type: application/json');
    echo json_encode(['respuesta' => $respuesta]);
    exit;
}

// Borrar Usuario
if ($metodo == "DELETE") {
    $tabla = $datos['table'] ?? null;
    if ($tabla === "usuario") {
        $id = $datos['id'] ?? '';

        if (empty($id)) {
            $respuesta = "Error: ID no especificado";
        } else {
            $query = "CALL borrarUsuario('$id', @error)";
            if ($conn->query($query)) {
                $result = $conn->query("SELECT @error AS error");
                $row = $result->fetch_assoc();
                $pp = $row['error'] ?? 1;

                $respuesta = ($pp == 0) ? "Usuario eliminado" : "Error: " . $pp;
            } else {
                $respuesta = "Error en la consulta: " . $conn->error;
            }
        }
    } else {
        $respuesta = "Error: Tabla no especificada o no válida";
    }

    $conn->close();
    header('Content-Type: application/json');
    echo json_encode(['respuesta' => $respuesta]);
    exit;
}

// Actualizar Usuario
if ($metodo == "PUT") {
    $tabla = $datos['table'] ?? null;
    if ($tabla === "usuario") {
        $ced = $datos['cedula'] ?? '';
        $name = $datos['nombre'] ?? '';
        $email = $datos['correo'] ?? '';
        $contr = $datos['contraseña'] ?? '';
        $cel = $datos['celular'] ?? '';
        $dir = $datos['direccion'] ?? '';
        $rol = $datos['rol'] ?? '';

        if (empty($ced) || empty($name) || empty($email) || empty($contr) || empty($rol)) {
            $respuesta = "Error: Campos requeridos faltantes";
        } else {
            $query = "CALL actualizarUsuario('$ced', '$name', '$email', '$contr', '$cel', '$dir', '$rol', @error)";
            if ($conn->query($query)) {
                $result = $conn->query("SELECT @error AS error");
                $row = $result->fetch_assoc();
                $pp = $row['error'] ?? 1;

                $respuesta = ($pp == 0) ? "Usuario actualizado correctamente" : "Error: " . $pp;
            } else {
                $respuesta = "Error en la consulta: " . $conn->error;
            }
        }
    } else {
        $respuesta = "Error: Tabla no especificada o no válida";
    }

    $conn->close();
    header('Content-Type: application/json');
    echo json_encode(['respuesta' => $respuesta]);
    exit;
}

header('Content-Type: application/json');
echo json_encode(['respuesta' => 'Método no soportado']);
?>
