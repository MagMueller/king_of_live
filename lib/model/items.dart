//import 'package:flutter/material.dart';
DateTime today =  DateTime.now();

class Items {
  String name = "TODO";
  int prio = 3;
  bool done = false;
  int time = 60;

  String start =  DateTime.now().toIso8601String(); // = today; //DateTime(today.year, today.day, today.hour, today.);
  bool placed = false;
  int myId = 0;
  bool isARoutine = false;
  int routineStreak = 0;
  String lastDone = DateTime(today.year, today.month, today.day - 1).toIso8601String();


  Items({
    required this.name,
    required this.prio,
    required this.isARoutine,
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
      'isARoutine': isARoutine,
      'routineStreak': routineStreak,
      'lastDone': lastDone,
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
    isARoutine = json['isARoutine'];
    routineStreak = json['routineStreak'];
    lastDone = json['lastDone'];
  }
}