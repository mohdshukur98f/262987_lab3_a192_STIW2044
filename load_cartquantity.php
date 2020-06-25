<?php
error_reporting(0);
include_once ("dbconnect.php");
$username = $_POST['username'];

$sql = "SELECT * FROM CART WHERE USERNAME = '$username'";    
$quan = 0;

 
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    while ($row = $result->fetch_assoc())
    {
      $quan = $quan + $row["CARTQUANTITY"];
    }
    echo  $quan;
}
else
{
    echo "nodata";
}
?>