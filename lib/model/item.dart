import 'package:flutter/material.dart';

class Items {
  String name;
  int prio;
  bool done;
  Items({
    required this.name,
    required this.prio,
    this.done = false,
  });
}