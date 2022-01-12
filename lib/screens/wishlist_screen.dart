import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child:  Scaffold(
        body: Center(
          child: Text(
            "Wishlist page",
            style: TextStyle(fontSize: 34),
          ),
        ),
      ),
    );
  }
}
