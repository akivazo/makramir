import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shopping_cart.dart';
import 'package:shopping/items_storage.dart';
import 'package:shopping/shop.dart';

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
                    children: [Align(child: Logo(), alignment: Alignment(-0.25, 0),), Padding(
                      padding: const EdgeInsets.all(20),
                      child: Introduction(),
                    ), ItemsView(), SizedBox(height: 100,)],
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
    return cart.getShoppingCartView(context);
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
    '''Thanks to this SO answer for providing all the details! The below workflow has been tested on a Windows machine.
                                      Enable Developer Options on the Android phone. Toggle USB debugging option.
                                  Connect your Android phone with a USB cable and accept whatever pop up appears.
                                  You should now see your phone listed. Running flutter devices should also list the device.''',
    style: TextStyle(color: Colors.black, fontSize: 30),
        );
  }
}


