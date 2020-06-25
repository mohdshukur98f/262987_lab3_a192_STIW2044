<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$username = $_GET['username'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$orderid = $_GET['orderid'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Transaction Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
 
$signed= hash_hmac('sha256', $signing, 'S-ZqIo5cX8ebBRIh4l67DUNg');
if ($signed === $data['x_signature']) {

    if ($paidstatus == "Success"){ //payment success
        
        $sqlcart = "SELECT PRODUCTID,CARTQUANTITY FROM CART WHERE USERNAME = '$username'";
        $cartresult = $conn->query($sqlcart);
        if ($cartresult->num_rows > 0)
        {
        while ($row = $cartresult->fetch_assoc())
        {
            $prodid = $row["PRODUCTID"];
            $cq = $row["CARTQUANTITY"]; //cart qty
            $sqlinsertcarthistory = "INSERT INTO CARTHISTORY (USERNAME,EMAIL,ORDERID,BILLID,PRODUCTID,CARTQUANTITY) VALUES ('$username','$userid','$orderid','$receiptid','$prodid','$cq')";
            $conn->query($sqlinsertcarthistory);
            
            $selectproduct = "SELECT * FROM PRODUCT WHERE PRODUCTID = '$prodid'";
            $productresult = $conn->query($selectproduct);
             if ($productresult->num_rows > 0){
                  while ($rowp = $productresult->fetch_assoc()){
                    $prquantity = $rowp["QUANTITY"];
                    $prevsold = $rowp["SOLD"];
                    $newquantity = $prquantity - $cq; //quantity in store - quantity ordered by user
                    $newsold = $prevsold + $cq;
                    $sqlupdatequantity = "UPDATE PRODUCT SET QUANTITY = '$newquantity', SOLD = '$newsold' WHERE PRODUCTID = '$prodid'";
                    $conn->query($sqlupdatequantity);
                  }
             }
        }
        
       $sqldeletecart = "DELETE FROM CART WHERE USERNAME = '$username'";
       $sqlinsert = "INSERT INTO PAYMENT(USERNAME,ORDERID,BILLID,USERID,TOTAL,STATUS) VALUES ('$username','$orderid','$receiptid','$userid','$amount','$paidstatus')";
       
       $conn->query($sqldeletecart);
       $conn->query($sqlinsert);
    }
        echo '<br><br><body><div><h2><br><br><center>Receipt</center></h1><table border=1 width=80% align=center><tr><td>Order id</td><td>'.$orderid.'</td></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table><br><p><center>Press back button to return to My eStock Application</center></p></div></body>';
        //echo $sqlinsertcarthistory;
    } 
        else 
    {
        echo '<br><br><body><div><h2><br><br><center>Receipt</center></h1><table border=1 width=80% align=center><tr><td>Order id</td><td>'.$orderid.'</td></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table><br><p><center>Press back button to return to My eStock Application</center></p></div></body>';
    }
}

?>