import 'package:shopping/ShoppingCart.dart';

import 'Item.dart';
import 'package:flutter/material.dart';

class ItemShopView extends StatefulWidget {
  final Item item;
  final ShoppingCart cart;


  ItemShopView({super.key, required this.item, required this.cart});

  @override
  State<ItemShopView> createState() => _ItemShopViewState();
}

class _ItemShopViewState extends State<ItemShopView> {
  bool inCart = false;

  @override
  Widget build(BuildContext context) {
    var itemImage = inCart ? Stack(children: [widget.item.image, const Text("Already in cart", style: TextStyle(color: Colors.white),)]) : widget.item.image;
    var itemAction = inCart ? ElevatedButton(
      onPressed: () {
        widget.cart.removeItem(widget.item);
        setState(() {
          inCart = false;
        });
      },
      child: Text("Return item"),
    ) :
    ElevatedButton(
      onPressed: () {
        widget.cart.addItem(widget.item);
        setState(() {
          inCart = true;
        });
      },
      child: Text("Pick item"),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.transparent,
        elevation: 2,
        child: Column(
          children: [
            itemImage,
            itemAction
          ],
        ),
      ),
    );
  }
}

class ItemsShopView extends StatelessWidget {
  final Set<Item> items;
  final ShoppingCart cart;
  const ItemsShopView({super.key, required this.items, required this.cart});

  @override
  Widget build(BuildContext context) {
    var controller = ScrollController(
      initialScrollOffset: MediaQuery.of(context).size.width / 2,
    );
    return SizedBox(
      height: 500,

      child: Scrollbar(
        controller: controller,
        child: ListView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            controller: controller,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            children: items.map((item) => ItemShopView(item: item, cart: cart,)).toList()
        ),
      ),
    );
  }

}