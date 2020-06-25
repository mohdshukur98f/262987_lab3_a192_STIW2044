<?php
error_reporting(0);
include_once ("dbconnect.php");
$username = $_POST['username'];

if (isset($username)){
   $sql = "SELECT * FROM PAYMENT WHERE USERNAME = '$username'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["payment"] = array();
    while ($row = $result->fetch_assoc())
    {
        $paymentlist = array();
        $paymentlist["ORDERID"] = $row["ORDERID"];
        $paymentlist["BILLID"] = $row["BILLID"];
        $paymentlist["TOTAL"] = $row["TOTAL"];
        $paymentlist["DATE"] = $row["DATE"];
        array_push($response["payment"], $paymentlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>