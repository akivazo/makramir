import 'package:flutter/material.dart';


class Item {
  final int id;
  final Widget image;
  final String description;
  final int cost;

  const Item({
    required this.id,
    required this.image,
    this.description = "no description is available",
    this.cost = 0
  });

  @override
  bool operator ==(Object other) =>
      other is Item &&
          other.runtimeType == runtimeType &&
          other.id == id;

  @override
  int get hashCode => id.hashCode;
}


