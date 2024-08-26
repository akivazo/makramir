import 'shopping_cart.dart';
import 'package:provider/provider.dart';

import 'item.dart';
import 'package:flutter/material.dart';

class ItemShopView extends StatelessWidget {
  final Item item;

  ItemShopView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<ShoppingCart>();
    bool inCart = cart.isInCart(item);
    var itemImage = getItemImage(inCart);
    var itemAction = getItemAction(inCart, cart);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 300,
        child: Card(
          color: Colors.transparent,
          elevation: 2,
          child: Column(
            children: [itemImage, itemAction],
          ),
        ),
      ),
    );
  }

  Widget getItemImage(bool inCart) {
    return inCart
        ? Stack(children: [
            item.image,
            const Text(
              "Already in cart",
              style: TextStyle(color: Colors.white),
            )
          ])
        : item.image;
  }

  Widget getItemAction(bool inCart, ShoppingCart cart) {
    return inCart
        ? ElevatedButton(
            onPressed: () {
              cart.removeItem(item);
            },
            child: Text("Return item"),
          )
        : ElevatedButton(
            onPressed: () {
              cart.addItem(item);
            },
            child: Text("Pick item"),
          );
  }
}

class ItemsShopView extends StatelessWidget {
  final Set<Item> items;

  const ItemsShopView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    var controller = ScrollController(
      initialScrollOffset: 0,
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
            children: items.map((item) => ItemShopView(item: item)).toList()),
      ),
    );
  }
}
