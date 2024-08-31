import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shopping_cart.dart';
import 'items_storage.dart';
import 'shop.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ShoppingCart(),
        child: MaterialApp(
            title: "Macramir - demo version",
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
            home: HomePage()));
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return Scaffold(
      key: scaffoldKey,
      drawer: ShoppingCartDrawer(
        scaffoldKey: scaffoldKey,
      ),
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
                    DemoDialog(),
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
                child: CartIcon(
                  scaffoldKey: scaffoldKey,
                ),
                alignment: Alignment.topLeft,
              ),
            ],
          )),
    );
  }
}

class DemoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text(
        AppLocalizations.of(context)!.demoTitle,
        textAlign: TextAlign.center,
      )),
      content: Center(
          child: Text(AppLocalizations.of(context)!.demoContent,
              textAlign: TextAlign.center)),
      titleTextStyle:
          TextStyle(color: Colors.red, decoration: TextDecoration.underline),
      contentTextStyle: TextStyle(color: Colors.red),
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
  final GlobalKey<ScaffoldState> scaffoldKey;

  ShoppingCartDrawer({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<ShoppingCart>();
    return cart.getShoppingCartView(scaffoldKey);
  }
}

class CartIcon extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  CartIcon({super.key, required this.scaffoldKey});

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
    var textStyle = Localizations.localeOf(context).languageCode == 'he'
        ? TextStyle(
            color: Colors.deepPurple,
            fontSize: 40,
            fontFamily: "DanaYad",
            fontWeight: FontWeight.bold)
        : TextStyle(
            color: Colors.deepPurple, fontSize: 40, fontFamily: "Caveat");
    return Text(
      AppLocalizations.of(context)!.introduction,
      style: textStyle,
      textAlign: TextAlign.center,
    );
  }
}
