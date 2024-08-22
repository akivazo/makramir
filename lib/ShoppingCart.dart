import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Item.dart';


class ItemCartView extends StatelessWidget {
  final Item item;

  const ItemCartView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: Column(
        children: [
          Row(
            children: [
              item.image,
              Text(item.cost.toString())
            ],
          ),
        ],
      ),
    );
  }
}

class ShoppingCartView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<ShoppingCart>();

    return Drawer(
            child: SingleChildScrollView (
              scrollDirection: Axis.vertical,
              child: Column(
                children: cart.getItemsInCart().map((item) {
                  return Card(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              item.image,
                              Align(
                                alignment: Alignment.topLeft,
                                child: ElevatedButton(onPressed: () => cart.removeItem(item), child: Icon(Icons.close)))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(item.cost.toString()),
                          ),
                          Icon(Icons.currency_exchange)
                        ]
                    ),
                  );
                }).toList()
              )
            ),
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
          badgeContent: Text(getNumberOfItemsInCart().toString(), style: TextStyle(fontSize: 17, color: Colors.black)),
          child: Icon(Icons.shopping_bag, size: 35,),
        )
    );
  }

  void showShoppingCart(GlobalKey<ScaffoldState> scaffoldKey){
    scaffoldKey.currentState!.openDrawer();
  }

  void removeItem(Item item) {
    _items.remove(item);
    notifyListeners();

  }

  void addItem(Item item){
    _items.add(item);
    notifyListeners();
  }
  Set<Item> getItemsInCart(){
    return _items;
  }

  int getNumberOfItemsInCart(){
    return getItemsInCart().length;
  }

  Widget getShoppingCartView(BuildContext context) {
    return ShoppingCartView();
  }
}