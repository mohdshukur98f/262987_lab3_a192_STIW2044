// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoder/geocoder.dart';

import 'dart:convert';
import 'package:estocksystem/navigationpage.dart';
import 'package:estocksystem/paymentpage.dart';
import 'package:flutter/material.dart';
import 'package:estocksystem/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class CartPage extends StatefulWidget {
  final User user;

  const CartPage({Key key, this.user}) : super(key: key);
  @override
  _CartPage createState() => _CartPage();
}

class _CartPage extends State<CartPage> {
  //IMPORTANT
  List cartData;
  double screenHeight, screenWidth;
  String server = "https://seriouslaa.com/myestock";
  String titlecenter = "Loading your cart";

  //CUSTOM
  double _weight = 0.0, _totalprice = 0.0;
  double deliverycharge;
  double amountpayable;
  // bool _selfPickup = true;
  // // bool _storeCredit = false;
  // bool _homeDelivery = false;

  @override
  void initState() {
    super.initState();
    //_getCurrentLocation();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text('SHOPPING CART'), actions: <Widget>[
        IconButton(
          icon: Icon(MdiIcons.deleteAlert),
          onPressed: () {
            _deleteAll();
          },
        ),
      ]),
      body: Container(
        child: Column(
          children: <Widget>[
            cartData == null
                ? Flexible(
                    child: Container(
                        child: Center(
                            child: Text(
                    titlecenter,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ))))
                : Expanded(
                    child: ListView.builder(
                        itemCount: cartData == null ? 1 : cartData.length,
                        itemBuilder: (context, index) {
                          index -= 0;
                          return Card(
                              elevation: 10,
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: screenHeight / 8,
                                          width: screenWidth / 5,
                                          child: ClipOval(
                                              child: CachedNetworkImage(
                                            fit: BoxFit.scaleDown,
                                            imageUrl: server +
                                                "/productimage/${cartData[index]['PRODUCTID']}.jpg",
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          )),
                                        ),
                                        Text(
                                          "RM " + cartData[index]['PRICE'],
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "/unit",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 1, 10, 1),
                                        child: SizedBox(
                                            width: 2,
                                            child: Container(
                                              height: screenWidth / 3.5,
                                              color: Colors.grey,
                                            ))),
                                    Container(
                                        width: screenWidth / 1.45,
                                        //color: Colors.blue,
                                        child: Row(
                                          //crossAxisAlignment: CrossAxisAlignment.center,
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    cartData[index]['NAME'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    "Available " +
                                                        cartData[index]
                                                            ['QUANTITY'] +
                                                        " unit",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Your Quantity " +
                                                        cartData[index]
                                                            ['CARTQUANTITY'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                      height: 20,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          FlatButton(
                                                            onPressed: () => {
                                                              _updateCart(
                                                                  index, "add")
                                                            },
                                                            child: Icon(
                                                                MdiIcons.plus,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            cartData[index][
                                                                'CARTQUANTITY'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () => {
                                                              _updateCart(index,
                                                                  "remove")
                                                            },
                                                            child: Icon(
                                                                MdiIcons.minus,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      )),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                          "Total Price: RM " +
                                                              cartData[index]
                                                                  ['YOURPRICE'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black)),
                                                      FlatButton(
                                                        onPressed: () => {
                                                          _deleteCart(index)
                                                        },
                                                        child: Icon(
                                                            MdiIcons.delete,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ])));
                        })),
            Container(
                //height: screenHeight / 3,
                child: Card(
              elevation: 5,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text("Payment",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                      //color: Colors.red,
                      child: Table(
                          defaultColumnWidth: FlexColumnWidth(1.0),
                          columnWidths: {
                            0: FlexColumnWidth(7),
                            1: FlexColumnWidth(3),
                          },
                          //border: TableBorder.all(color: Colors.white),
                          children: [
                            TableRow(children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 20,
                                    child: Text("Total Item Price ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))),
                              ),
                              TableCell(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 20,
                                  child: Text(
                                      "RM" + _totalprice.toStringAsFixed(2) ??
                                          "0.0",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black)),
                                ),
                              ),
                            ]),
                            TableRow(children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 20,
                                    child: Text("Total Amount ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))),
                              ),
                              TableCell(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 20,
                                  child: Text(
                                      "RM" + amountpayable.toStringAsFixed(2) ??
                                          "0.0",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                              ),
                            ]),
                          ])),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minWidth: 200,
                    height: 40,
                    child: Text('Make Payment'),
                    color: Colors.red,
                    textColor: Colors.white,
                    elevation: 10,
                    onPressed: makePayment,
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _loadCart() {
    _weight = 0.0;
    _totalprice = 0.0;
    amountpayable = 0.0;
    deliverycharge = 0.0;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating cart...");
    pr.show();
    String urlLoadJobs = server + "/php/load_cart.php";
    http.post(urlLoadJobs, body: {
      "username": widget.user.username,
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "Cart Empty") {
        //Navigator.of(context).pop(false);
        widget.user.quantity = "0";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => NavigationPage(
                      user: widget.user,
                    )));
      }
      setState(() {
        var extractdata = json.decode(res.body);
        cartData = extractdata["cart"];
        for (int i = 0; i < cartData.length; i++) {
          _weight = double.parse(cartData[i]['WEIGHT']) *
                  int.parse(cartData[i]['CARTQUANTITY']) +
              _weight;
          _totalprice = double.parse(cartData[i]['YOURPRICE']) + _totalprice;
          print("""""_weight""" "");
          print(cartData);
        }
        _weight = _weight / 1000;
        amountpayable = _totalprice;
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    pr.hide();
  }

  _updateCart(int index, String op) {
    int curquantity = int.parse(cartData[index]['QUANTITY']);
    int quantity = int.parse(cartData[index]['CARTQUANTITY']);
    if (op == "add") {
      quantity++;
      if (quantity > (curquantity - 2)) {
        Toast.show("Quantity not available", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }
    String loadCart = server + "/php/update_cart.php";
    http.post(loadCart, body: {
      "username": widget.user.username,
      "productid": cartData[index]['PRODUCTID'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        print(res.body);
        Toast.show("Cart Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadCart();
      } else {
        print(res.body);
        print("print in else ");
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteCart(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Row(
          children: <Widget>[
            Flexible(
              child: Text(
                'Delete ' + cartData[index]['NAME'] + "?",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontSize: 15),
                maxLines: 2,
              ),
            )
          ],
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server + "/php/delete_cart.php", body: {
                  "username": widget.user.username,
                  "productdid": cartData[index]['PRODUCTID'],
                }).then((res) {
                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    );
  }

  _deleteAll() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Row(
          children: <Widget>[
            Text(
              'Delete all item in cart?',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ],
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server + "/php/delete_cart.php", body: {
                  "username": widget.user.username,
                }).then((res) {
                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    );
  }

  Future<void> makePayment() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy');
    String orderid = formatter.format(now) + randomAlphaNumeric(6);
    print(orderid);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentPage(
                  user: widget.user,
                  val: _totalprice.toStringAsFixed(2),
                  orderid: orderid,
                )));
    _loadCart();
  }
}
