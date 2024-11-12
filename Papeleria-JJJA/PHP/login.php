
<?php
session_start();

$servername = "localhost";
$username = "root";
$contra = "";
$dbname = "proyecto_mp4_db2";
$port = "33065";

$response = [];

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST['email'];
    $password = $_POST['password'];

    $conn = new mysqli($servername, $username, $contra, $dbname, $port);

    if ($conn->connect_error) {
        $response['error'] = "Error de conexión: " . $conn->connect_error;
        echo json_encode($response);
        exit();
    }

    $sql = "CALL listarUsuarioPorCorreo('$email', @error)";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        if ($password === $row['contraseña']) {
            $_SESSION['nombre'] = $row['nombre'];
            $_SESSION['user_id'] = $row['cedula'];
            $_SESSION['email'] = $row['correo'];
            $_SESSION['login_message'] = "Inicio de sesión exitoso " . $_SESSION['user_id'];
            $_SESSION['rol'] = $row['rol'];

            $response['success'] = "Inicio de sesión exitoso";
            echo json_encode($response);
            exit();
        } else {
            $response['error'] = "Contraseña incorrecta";
            echo json_encode($response);
            exit();
        }
    } else {
        $response['error'] = "No existe una cuenta con este correo";
        echo json_encode($response);
        exit();
    }
}
?>
