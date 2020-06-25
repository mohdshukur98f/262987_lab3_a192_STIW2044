<?php
error_reporting(0);
include_once("dbconnect.php");

$username = $_POST['username'];
$productid = $_POST['productid'];
$quantity = $_POST['quantity'];

$sqlupdate = "UPDATE CART SET CARTQUANTITY = '$quantity' WHERE USERNAME = '$username' AND PRODUCTID = '$productid'";

if ($conn->query($sqlupdate) === true)
{
    echo "success";
}
else
{
    echo "failed";
}
    
$conn->close();
?>