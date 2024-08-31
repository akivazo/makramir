import 'shopping_cart.dart';
import 'package:provider/provider.dart';
import 'item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';

class ItemDetailsDialog extends StatelessWidget {
  final String description;
  final List<Image> images;
  final int cost;

  const ItemDetailsDialog(
      {super.key,
      required this.description,
      required this.images,
      required this.cost});

  @override
  Widget build(BuildContext context) {
    Axis direction = MediaQuery.of(context).size.width > 500
        ? Axis.horizontal
        : Axis.vertical;
    return Dialog(
      child: Card(
        child: SingleChildScrollView(
          scrollDirection: direction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                direction: direction,
                children: images,
                spacing: 10,
              ),
              Text(description),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(AppLocalizations.of(context)!.itemCost(cost)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                        AppLocalizations.of(context)!.closeItemDetailsDialog)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ResponsiveImage extends StatelessWidget {
  final Widget imageView;
  final String description;
  final List<Image> images;
  final int cost;

  const ResponsiveImage(
      {super.key,
      required this.imageView,
      required this.description,
      required this.images,
      required this.cost});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => ItemDetailsDialog(
                    description: description,
                    images: images,
                    cost: cost,
                  ));
        },
        child: imageView,
      ),
    );
  }
}

class ItemShopView extends StatelessWidget {
  final Item item;

  ItemShopView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<ShoppingCart>();
    bool inCart = cart.isInCart(item);
    var itemImage = getItemImage(context, inCart);
    var itemAction = getItemAction(context, inCart, cart);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 300,
        child: Card(
          color: Colors.transparent,
          elevation: 2,
          child: Column(
            children: [
              Expanded(
                child: ResponsiveImage(
                  imageView: itemImage,
                  description: item.description,
                  images: [
                    item.image,
                    if (item.extraImages != null) ...item.extraImages!
                  ],
                  cost: item.cost,
                ),
              ),
              itemAction
            ],
          ),
        ),
      ),
    );
  }

  Widget getItemImage(BuildContext context, bool inCart) {
    return inCart
        ? Stack(children: [
            item.image,
            Text(
              AppLocalizations.of(context)!.alreadyInBag,
              style: TextStyle(color: Colors.white),
            )
          ])
        : item.image;
  }

  Widget getItemAction(BuildContext context, bool inCart, ShoppingCart cart) {
    return inCart
        ? ElevatedButton(
            onPressed: () {
              cart.removeItem(item);
            },
            child: Text(AppLocalizations.of(context)!.returnItem),
          )
        : ElevatedButton(
            onPressed: () {
              cart.addItem(item);
            },
            child: Text(AppLocalizations.of(context)!.addItem),
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
