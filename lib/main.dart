
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
            color: Color.fromRGBO(191,173,173,1),
          ),
          child: SingleChildScrollView(
                      child: Column(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraint) {
                              return Row(

                                children: [
                                  Image(image: AssetImage("assets/images/logo.jpg"), width: constraint.maxWidth / 2,),
                                  Flexible(
                                    child: Text('''Thanks to this SO answer for providing all the details! The below workflow has been tested on a Windows machine.
                                  Enable Developer Options on the Android phone. Toggle USB debugging option.
                              Connect your Android phone with a USB cable and accept whatever pop up appears.
                              You should now see your phone listed. Running flutter devices should also list the device.''', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: 30),),
                                  )
                                ],
                                mainAxisSize: MainAxisSize.max,
                              );
                            }
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ItemsShopView(items: itemsStorage.getItems()),
                          ),


                    SafeArea(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: cart.getCartIcon(scaffoldKey),
                        ),
                      ),
                    ),
                  ]
          ),
        ),
      ),
    ));
  }
}









