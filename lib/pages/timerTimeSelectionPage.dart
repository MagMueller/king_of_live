// ignore_for_file: file_names
import 'dart:convert';

import 'package:king_of_live/pages/timerTaskSelectionPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'countdown.dart';
import 'prio.dart';
import 'package:flutter/material.dart';
import '../model/items.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'dart:io';
import 'timerTaskSelectionPage.dart';

class TimerSelectionPage extends StatefulWidget {
  DateTime? time;

  TimerSelectionPage({this.time, Key? key}) : super(key: key);

  @override
  State<TimerSelectionPage> createState() =>
      _TimerSelectionPageState();
}

class _TimerSelectionPageState extends State<TimerSelectionPage> {
  int isSelected = 0;
  //DateTime _today = DateTime.now();
  DateTime zero = DateTime(0, 0, 0, 0, 0);
  DateTime _dateTime = DateTime(0, 0, 0, 0, 0); //DateTime.now();
  DateTime _dateTimeStandard = DateTime(0, 0, 0, 0, 30);
  late DateTime newTime;

  int lastSelected = 0;

  _TimerSelectionPageState();

  List<Items> users = [];
  bool lightTheme = false;

  //Widget mySpinner = buildTimePickerSpinner(_dateTimeStandard, "Hello");
  @override
  void initState() {
    super.initState();
    newTime = widget.time!;
    //print(mySpinner.time!);
    loadItems();
  }

  @override
  Widget build(BuildContext context) => Theme(
        data: lightTheme ? ThemeData.light() : ThemeData.dark(),
        child: Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              child: const Text('Select duration'),
              onDoubleTap: () => setState(() => lightTheme = !lightTheme),
            ),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
//crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Container(
                    height: 200,
                    color: lightTheme
                        ? Theme.of(context).primaryColor
                        : const Color(0xFF424242),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: buildTimePickerSpinner(newTime, "first")),

                        //Container(child:   mySpinner),
                        //Text(_dateTime.minute.toString())
                      ],
                    )

                    //color: ThemeData.,
                    ),
              ),
              //bottom box bellow the list -> you can scroll further up
            ],
          ),
          floatingActionButton: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: roundBoxDeco(),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TimerTaskSelectionPage()),
                      );
                    },
                    icon: Icon(Icons.navigate_before_rounded)),
              ),
              Container(
                decoration: roundBoxDeco(),
                child: IconButton(

                    onPressed: () {
                      print("to countdownd" + newTime.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CountdownPage(time: newTime, title: "Start Task",)),
                      );
                    },
                    icon: Icon(Icons.navigate_next_rounded)),
              ),
            ],
          ),
        ),
      );

  Widget buildTimePickerSpinner(DateTime dateTime, String s) {
    print(s + dateTime.toString());
    setState(() {
      //lastSelected = isSelected;
      print(lastSelected.toString());
    });
    return TimePickerSpinner(
      isShowSeconds: false,

      //alignment: Alignment.center,
      time: dateTime,
      minutesInterval: 1,
      //highlightedTextStyle: TextStyle(color: Colors.white),
      onTimeChange: (hh) {
        setState(() {
          newTime = hh;
        });
      },
    );
  }

  String getPrioText(int prio) {
    List<String> prios = ["A", "B", "C"];
    if (prio <= 3 && prio >= 1) {
      return prios[prio - 1];
    } else {
      return "Error";
    }
  }

  Future<void> loadItems({String key = 'users'}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> usersString = prefs.getStringList(key) ?? [];
    List<Items> userList = [];

    ///get every single item of the saved list and turn it into a user
    if (usersString != []) {
      for (int i = 0; i < usersString.length; i++) {
        Map<String, dynamic> map = jsonDecode(usersString[i]);
        final loadedItem = Items.fromJson(map);
        userList.add(loadedItem);
      }
    }

    setState(() {
      users = userList;
      //newTime = zero.add(Duration(minutes: users[0].time));
    });
  }

BoxDecoration roundBoxDeco() {
    return BoxDecoration(
      color: Colors.blue,
      border: Border.all(width: 9.0),
      borderRadius: BorderRadius.all(
          Radius.circular(30.0) //                 <--- border radius here
          ),
    );
  }
/*
  Widget hourMinuteSecond() {

    return ;
  }

   */
}
