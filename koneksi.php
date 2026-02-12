<?php
$host = 'localhost';
$user = 'root';
$pass = '';
$db = 'ta_game';

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_errno) {
    die('koneksi gagal :'. $conn->connect_error);
}






?>