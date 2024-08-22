
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ShoppingCart.dart';
import 'package:shopping/ItemsStorage.dart';
import 'package:shopping/Shop.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

void main() {
  runApp(
      ChangeNotifierProvider(
          create: (context) => ShoppingCart(),
          child: MainApp()
      ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var itemsStorage = ItemsStorage();
    var cart = context.watch<ShoppingCart>();
    return MaterialApp(
      home: Scaffold(

        key: scaffoldKey,
        drawer: cart.getShoppingCartView(context),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/logo.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
                  children: [
                     SafeArea(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: cart.getCartIcon(scaffoldKey),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ItemsShopView(items: itemsStorage.getItems(), cart: cart,),
                    )
                  ]
          ),
        ),
      ),
    );
  }
}









