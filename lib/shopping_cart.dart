import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'item.dart';
import 'checkout_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemCartView extends StatelessWidget {
  final Item item;

  const ItemCartView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<ShoppingCart>();
    return Card(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Stack(
          children: [
            item.image,
            Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    onPressed: () => cart.removeItem(item),
                    child: Icon(Icons.close)))
          ],
        ),
        Card(elevation: 2, child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text("${item.cost.toString()} \$", style: TextStyle(color: Colors.black),),
        )),
      ]),
    );
  }
}

class ItemsInCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = context.watch<ShoppingCart>();
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              children: cart.getItemsInCart().map((item) {
                return ItemCartView(item: item);
              }).toList())),
        ),
        Card(
          child: Wrap(
            spacing: 10,
            children: [
              CheckoutButton(),
              ClearItemsButton(),
            ],
          ),
        ),
      ],
    );
  }
}

class ClearItemsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = context.watch<ShoppingCart>();

    return ElevatedButton(
      onPressed: () {
        cart.clearItems();
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
      child: Text(AppLocalizations.of(context)!.cartClearItems, style: TextStyle(color: Colors.black)),
    );
  }
}

class CheckoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = context.watch<ShoppingCart>();
    return ElevatedButton(
      onPressed: () {
        var checkoutManager = CheckoutManager(itemsToCheckout: cart.getItemsInCart());
        Navigator.push(context, MaterialPageRoute(builder: (context) => checkoutManager.getCheckoutView(context)));
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
      child: Text(
        AppLocalizations.of(context)!.proceedToCheckout(cart.getTotalAmount()),
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

class EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.noItemsInBag, style: TextStyle(fontSize: 20),),
            Text(
              AppLocalizations.of(context)!.emptyBagTip,
              maxLines: 2, textAlign: TextAlign.center,)
          ],
        ));
  }


}
class ShoppingCartView extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ShoppingCartView({super.key, required this.scaffoldKey});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        var drawerWidth = constraint.maxWidth > 500 ? 500 : constraint.maxWidth;
        var cart = context.watch<ShoppingCart>();
        var drawerBody = cart.getNumberOfItemsInCart() == 0 ? Expanded(child: EmptyCartView()) : Expanded(child: ItemsInCartView());
        return Drawer(
          width: drawerWidth.toDouble(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              drawerBody,
              Align(child: ElevatedButton.icon(label: Text(AppLocalizations.of(context)!.closeDrawer), onPressed: scaffoldKey.currentState!.closeDrawer, icon: Icon(Icons.arrow_back)), alignment: Alignment(1, 0),),
            ],
          ),
        );
      }
    );
  }

}

class ShoppingCart extends ChangeNotifier {
  final Set<Item> _items = {};

  /// The global key of the main scaffold. used to open the scaffold drawer
  Widget getCartIcon(GlobalKey<ScaffoldState> scaffoldKey) {
    return ElevatedButton(
        onPressed: () => showShoppingCart(scaffoldKey),
        child: badges.Badge(
          badgeContent: Text(getNumberOfItemsInCart().toString(),
              style: TextStyle(fontSize: 17, color: Colors.white)),
          child: Icon(
            Icons.shopping_bag,
            size: 35,
          ),
        ));
  }

  void showShoppingCart(GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState!.openDrawer();
  }

  void removeItem(Item item) {
    _items.remove(item);
    notifyListeners();
  }

  int getTotalAmount() {
    return _items.fold(0, (sum, item) => sum + item.cost);
  }

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  Set<Item> getItemsInCart() {
    return _items;
  }

  int getNumberOfItemsInCart() {
    return getItemsInCart().length;
  }

  Widget getShoppingCartView(GlobalKey<ScaffoldState> scaffoldKey) {
    return ShoppingCartView(scaffoldKey: scaffoldKey,);
  }

  void clearItems() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(Item item) {
    return _items.contains(item);
  }
}
