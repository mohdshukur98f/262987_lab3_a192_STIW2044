<?php
$servername = "localhost";
$username   = "seriousl_myestock";
$password   = "Myestock2020";
$dbname     = "seriousl_myestock";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>