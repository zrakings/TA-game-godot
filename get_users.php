<?php
file_put_contents("admin_test.txt", file_get_contents("php://input"));
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "ta_game");

if ($conn->connect_error) {
    echo json_encode(["status" => "error"]);
    exit;
}

$result = $conn->query("SELECT id, username, role FROM users");

$users = [];

while ($row = $result->fetch_assoc()) {
    $users[] = $row;
}

echo json_encode($users);
?>
