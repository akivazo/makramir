
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

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
        body: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Stack(
                  children: [
                     SafeArea(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: cart.getCartIcon(context),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ItemsView(items: itemsStorage.getItems(), addToCart: cart.addItem,),
                    )
                  ]
          ),
        ),
      ),
    );
  }
}

class Item {
  final Widget image;
  final String description;
  final int cost;

  const Item({
    required this.image,
    this.description = "no description is available",
    this.cost = 0
  });
}

class ItemShopView extends StatefulWidget {
  final Item item;
  final void Function(Item) addToCart;


  ItemShopView({super.key, required this.item, required this.addToCart});

  @override
  State<ItemShopView> createState() => _ItemShopViewState();
}

class _ItemShopViewState extends State<ItemShopView> {
  bool inCart = false;
  @override
  Widget build(BuildContext context) {
    var itemImage = inCart ? Stack(children: [widget.item.image, Text("Already in cart")]) : widget.item.image;
    return Card(
      elevation: 5,
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(18),
              child: itemImage
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    widget.addToCart(widget.item);
                    setState(() {
                      inCart = true;
                    });
                  },
                  child: Text("addToCart")
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ItemsStorage {
  Set<Item> getItems(){
    return List.generate(20, (index) {
      return Item(
        image: Card(elevation: 20, child: Text((index + 1).toString())),
        cost: 0,
        description: index.toString()
      );
    }).toSet();
  }
}

class ItemsView extends StatelessWidget {
  final Set<Item> items;
  final void Function(Item) addToCart;
  const ItemsView({super.key, required this.items, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    var controller = ScrollController(
      initialScrollOffset: MediaQuery.of(context).size.width / 2,
    );
    return SizedBox(
      height: 200,
      child: Scrollbar(
        controller: controller,
        child: ListView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            controller: controller,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            children: items.map((item) => ItemShopView(item: item, addToCart: addToCart)).toList()
        ),
      ),
    );
  }

}

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
      child: Column(
        children: [
          Column(
              children: cart.getItemsInCart().map((item) {
                return Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      badges.Badge(
                        badgeContent: ElevatedButton(onPressed: () => cart.removeItem(item),child: Icon(Icons.close)),
                        child: item.image,
                      ),
                      Text(item.cost.toString()),
                    ]
                  ),
                );
              }).toList()),
          Row(
            children: [
              ElevatedButton(onPressed: () {}, child: Text("Proceed to checkout")),
              ElevatedButton(onPressed: () {}, child: Text("Clear cart"))

            ],
          )
        ]
      ),
    );
  }
}

class ShoppingCart extends ChangeNotifier {
  
  final Set<Item> _items = {};
  
  Widget getCartIcon(BuildContext context) {
    return ElevatedButton(
        onPressed: () => showShoppingCart(context),
        child: badges.Badge(
          badgeContent: Text(getNumberOfItemsInCart().toString(), style: TextStyle(fontSize: 17, color: Colors.black)),
          child: Icon(Icons.shopping_bag, size: 35,),
        )
    );
  }
  
  void showShoppingCart(BuildContext context){
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