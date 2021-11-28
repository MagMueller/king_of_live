//import 'package:flutter/material.dart';

class Items {
  String name = "TODO";
  int prio = 3;
  bool done = false;
  int time = 60;
   //String today =  DateTime.now().toIso8601String();
  String start =  DateTime.now().toIso8601String(); // = today; //DateTime(today.year, today.day, today.hour, today.);
  bool placed = false;
  int myId = 0;

  Items({
    required this.name,
    required this.prio,
  });

  Map<String, dynamic> toJson(){
    return{
      'name': name,
      'prio': prio,
      'done': done,
      'time': time,
      'start': start,
      'placed': placed,
      'my_id': myId,
    };
  }

   Items.fromJson(Map<String, dynamic> json){
    name = json['name'];
    prio = json['prio'];
    done = json['done'];
    time = json['time'];
    start = json['start'];
    placed = json['placed'];
    myId = json['my_id'];
  }
}