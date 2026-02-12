<?php
header("Content-Type: application/json");
$conn = new mysqli("localhost", "root", "", "ta_game");

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Koneksi gagal"]);
    exit;
}

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['username']) || !isset($data['password']) || !isset($data['role'])) {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
    exit;
}

$username = $conn->real_escape_string($data['username']);
$password = password_hash($data['password'], PASSWORD_DEFAULT);
$role = $conn->real_escape_string($data['role']);

// Cek username sudah ada
$check = $conn->query("SELECT id FROM users WHERE username='$username'");
if ($check->num_rows > 0) {
    echo json_encode(["status" => "exists"]);
    exit;
}

// Insert user baru
$sql = "INSERT INTO users (username, password, role) VALUES ('$username', '$password', '$role')";

if ($conn->query($sql)) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}

$conn->close();
?>
