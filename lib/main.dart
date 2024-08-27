import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shopping_cart.dart';
import 'items_storage.dart';
import 'shop.dart';
import 'package:google_fonts/google_fonts.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ShoppingCart(), child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        drawer: ShoppingCartDrawer(),
        body: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(191, 173, 173, 1),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        child: Logo(),
                        alignment: Alignment(-0.25, 0),

                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Introduction(),
                      ),
                      ItemsView(),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
                Align(
                  child: CartIcon(),
                  alignment: Alignment.topLeft,
                ),
              ],
            )),
      ),
    );
  }
}

class ItemsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemsStorage = ItemsStorage();
    return ItemsShopView(items: itemsStorage.getItems());
  }
}

class ShoppingCartDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = context.watch<ShoppingCart>();
    return cart.getShoppingCartView(scaffoldKey);
  }
}

class CartIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = context.watch<ShoppingCart>();
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: cart.getCartIcon(scaffoldKey),
    );
  }
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage("assets/images/logo.jpg"),
      width: 500,
    );
  }
}

class Introduction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '''Welcome to Miryam’s Macrame Creations! 🌟 Dive into a world of intricate knots and beautiful designs, all handcrafted with love by Miryam herself. Each piece is a testament to her passion for this timeless art form, blending traditional techniques with modern aesthetics. From elegant wall hangings to charming plant holders, Miryam’s creations are perfect for adding a touch of bohemian elegance to any space. Explore our collection and find the perfect piece to bring warmth and creativity into your home. Every item is made with care, ensuring you receive a unique and high-quality product that you’ll cherish for years to come.''',
      style: GoogleFonts.caveat(
        textStyle: TextStyle(color: Colors.deepPurple, fontSize: 40)),
      textAlign: TextAlign.center,
    );
  }
}
