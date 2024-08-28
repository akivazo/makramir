import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shopping_cart.dart';
import 'items_storage.dart';
import 'shop.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('he'), // Hebrew
      ],
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
      AppLocalizations.of(context)!.introduction,
      style: GoogleFonts.caveat(
          textStyle: TextStyle(color: Colors.deepPurple, fontSize: 40)),
      textAlign: TextAlign.center,
    );
  }
}
