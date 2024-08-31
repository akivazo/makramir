import 'package:flutter/material.dart';


class Item {
  final int id;
  final Image image;
  final String description;
  final int cost;
  final Set<Image>? extraImages;

  const Item({
    required this.id,
    required this.image,
    this.description = "no description is available",
    this.cost = 0,
    this.extraImages

  });

  @override
  bool operator ==(Object other) =>
      other is Item &&
          other.runtimeType == runtimeType &&
          other.id == id;

  @override
  int get hashCode => id.hashCode;
}


