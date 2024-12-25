import 'package:flutter/material.dart';

enum StockType {


  food('Food', Icons.restaurant_menu),
  drink('Drink', Icons.local_drink),
  snack('Snack', Icons.fastfood),
  other('Other', Icons.category);

  final String label;
  final IconData icon;

  const StockType(this.label, this.icon);
}
