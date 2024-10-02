// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/cart_screen.dart';
import 'package:shopping_cart/db_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<String> productName = ['Mango', 'Orange', 'Grapes', 'Banana', 'Chery'];
  List<String> productUnit = ['KG', 'KG', 'Dozen', 'KG', 'KG'];
  List<int> productPrice = [10, 20, 30, 40, 50];
  List<String> productImage = [
    'https://img.freepik.com/free-psd/mango-isolated-fruits-transparent-background_191095-14916.jpg?w=740&t=st=1723127717~exp=1723128317~hmac=c9e3540ad25303e30cb1df90fdd5680a9da55b1a80ee9f726391547ce88af50c',
    'https://img.freepik.com/free-photo/orange-white-white_144627-16571.jpg?t=st=1723127762~exp=1723131362~hmac=8cd2a672a8187151b8312368f4cd5e1eedec31ac714b8c5f082b8975943aad28&w=740',
    'https://img.freepik.com/free-psd/grapes-isolated-transparent-background_191095-39883.jpg?t=st=1723127895~exp=1723131495~hmac=0313fed1ddeae5174677994170b6ab5e5afe895f5eb59da763ea6f749f8b3656&w=740',
    'https://img.freepik.com/free-psd/banana-isolated-transparent-background_191095-14410.jpg?t=st=1723127963~exp=1723131563~hmac=ed80994887f682978cc0690dfb8d986cc9f11701593d3f5387c5b5910785d40d&w=740',
    'https://img.freepik.com/free-psd/black-pepper-isolated-transparent-background_191095-12643.jpg?t=st=1723127993~exp=1723131593~hmac=53b8216731049f32441d09327dbd78972573fdf51fbd9913eb144272dc06332b&w=740'
  ];

// database initilize
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
// provider ko access kar rahe hai hum yaha pr
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      // '0',
                      value.getCounter().toString(),
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),

          // Icon(Icons.shopping_bag_outlined),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: productName.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image(
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                                image: NetworkImage(
                                    productImage[index].toString())),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              // expanded ka use kr rhe hai add to cart button ko shift krne ke liye
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productName[index].toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${productUnit[index]}  \$${productPrice[index]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // add to cart ki button bna rhe hai ab hum
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        dbHelper!
                                            .insert(Cart(
                                                id: index,
                                                productId: index.toString(),
                                                productName: productName[index]
                                                    .toString(),
                                                initialPrice:
                                                    productPrice[index],
                                                productPrice:
                                                    productPrice[index],
                                                quantity: 1,
                                                unitTag: productUnit[index]
                                                    .toString(),
                                                image: productImage[index]
                                                    .toString()))
                                            .then((value) {
                                          cart.addTotalPrice(double.parse(
                                              productPrice[index].toString()));
                                          cart.addCounter();

                                          print("product is added to the cart");
                                        }).onError((error, stackTrace) {
                                          print(error.toString());
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration:
                                            BoxDecoration(color: Colors.green),
                                        child: Center(
                                            child: Text(
                                          'Add To Cart',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ]),
                ),
              );
            },
          )),
// yha paas reusable widedet ko use krenge
        ],
      ),
    );
  }
}
