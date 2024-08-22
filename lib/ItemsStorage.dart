import 'Item.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ItemsStorage {
  Set<Item> getItems(){
    var rng = Random();
    return List.generate(9, (index) {
      return Item(
        id: index,
        image: Image(image: AssetImage('assets/images/item${index + 1}_1.jpg'), width: 200, height: 400,),
        cost: rng.nextInt(10),
        description: index.toString()
      );
    }).toSet();
  }
}

