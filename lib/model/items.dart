//import 'package:flutter/material.dart';

class Items {
  String name = "TODO";
  int prio = 3;
  bool done = false;
  int time = 30;
  int start = 8;

  Items({
    required this.name,
    required this.prio,
    required this.done,
    required this.time,
  this.start =  -1});

  Map<String, dynamic> toJson(){
    return{
      'name': name,
      'prio': prio,
      'done': done,
      'time': time,
      'start': start,
    };
  }

   Items.fromJson(Map<String, dynamic> json){
    name = json['name'];
    prio = json['prio'];
    done = json['done'];
    time = json['time'];
    start = json['start'];
  }
}