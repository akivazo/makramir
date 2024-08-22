import 'Item.dart';
import 'package:flutter/material.dart';

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

class ItemsShopView extends StatelessWidget {
  final Set<Item> items;
  final void Function(Item) addToCart;
  const ItemsShopView({super.key, required this.items, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    var controller = ScrollController(
      initialScrollOffset: MediaQuery.of(context).size.width / 2,
    );
    return SizedBox(
      height: 550,
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