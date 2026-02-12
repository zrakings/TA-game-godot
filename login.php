<?php
file_put_contents("debug.txt", file_get_contents("php://input"));

header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "ta_game");

if ($conn->connect_error) {
    echo json_encode([
        "status" => "error",
        "message" => "Koneksi database gagal"
    ]);
    exit;
}

$raw = file_get_contents("php://input");

if (!$raw) {
    echo json_encode([
        "status" => "error",
        "message" => "Body kosong"
    ]);
    exit;
}

$data = json_decode($raw, true);

if (!$data || !isset($data["username"]) || !isset($data["password"])) {
    echo json_encode([
        "status" => "error",
        "message" => "Data kosong atau format salah"
    ]);
    exit;
}

$username = $data["username"];
$password_input = $data["password"];

// Gunakan prepared statement (lebih aman)
$stmt = $conn->prepare("SELECT id, username, password, role FROM users WHERE username = ?");
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows == 0) {
    echo json_encode([
        "status" => "not_found"
    ]);
    exit;
}

$user = $result->fetch_assoc();

// Gunakan password_verify untuk cek hash
if (password_verify($password_input, $user["password"])) {
    echo json_encode([
        "status" => "success",
        "username" => $user["username"],
        "role" => $user["role"]
    ]);
} else {
    echo json_encode([
        "status" => "wrong_password"
    ]);
}

$conn->close();
?>
