import 'Item.dart';
import 'package:flutter/material.dart';
import 'Shop.dart';

class ItemsStorage {
  Set<Item> getItems(){
    return List.generate(9, (index) {
      return Item(
          image: Image(image: AssetImage('assets/images/item${index + 1}_1.jpg'), width: 200, height: 400,),
          cost: 0,
          description: index.toString()
      );
    }).toSet();
  }
}

