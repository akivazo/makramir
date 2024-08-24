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
            width: 450,
            child: Column(
              children: [
                SingleChildScrollView (
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
                                child: Text("${item.cost.toString()} \$")
                              ),
                            ]
                        ),
                      );
                    }).toList()
                  )
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            cart.clearItems();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                          child: Text('Clear items', style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Button action
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                          child: Text('Proceed to checkout (${cart.getTotalAmount()} \$)', style: TextStyle(color: Colors.black),),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
          badgeContent: Text(getNumberOfItemsInCart().toString(), style: TextStyle(fontSize: 17, color: Colors.white)),
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

  int getTotalAmount() {
    return _items.fold(0, (sum, item) => sum + item.cost);
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

  void clearItems(){
    _items.clear();
    notifyListeners();
  }

  bool isInCart(Item item){
    return _items.contains(item);
  }
}