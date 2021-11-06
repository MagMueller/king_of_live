//import 'package:flutter/material.dart';

class Items {
  String name = "TODO";
  int prio = 3;
  bool done = false;
  int time = 30;

  Items({
    required this.name,
    required this.prio,
    required this.done,
    required this.time});

  Map<String, dynamic> toJson(){
    return{
      'name': name,
      'prio': prio,
      'done': done,
      'time': time,
    };
  }

   Items.fromJson(Map<String, dynamic> json){
    name = json['name'];
    prio = json['prio'];
    done = json['done'];
    time = json['time'];
  }
}