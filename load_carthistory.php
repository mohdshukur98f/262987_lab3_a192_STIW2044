  
<?php
error_reporting(0);
include_once ("dbconnect.php");
$orderid = $_POST['orderid'];

$sql = "SELECT PRODUCT.PRODUCTID, PRODUCT.NAME, PRODUCT.PRICE, PRODUCT.QUANTITY, CARTHISTORY.CARTQUANTITY FROM PRODUCT INNER JOIN CARTHISTORY ON CARTHISTORY.PRODUCTID = PRODUCT.PRODUCTID WHERE  CARTHISTORY.ORDERID = '$orderid'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["carthistory"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["PRODUCTID"] = $row["PRODUCTID"];
        $cartlist["NAME"] = $row["NAME"];
        $cartlist["PRICE"] = $row["PRICE"];
        $cartlist["CARTQUANTITY"] = $row["CARTQUANTITY"];
        array_push($response["carthistory"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>