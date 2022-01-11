import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child:  Center(
        child: Text(
          "Cart page",
          style: TextStyle(fontSize: 34),
        ),
      ),
    );
  }
}