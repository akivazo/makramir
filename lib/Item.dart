import 'package:flutter/material.dart';


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


