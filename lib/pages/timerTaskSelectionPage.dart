// ignore_for_file: file_names
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'prio.dart';
import 'package:flutter/material.dart';
import '../model/items.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class TimerSelectionPage extends StatefulWidget {
  const TimerSelectionPage({Key? key}) : super(key: key);

  @override
  State<TimerSelectionPage> createState() => _TimerSelectionPageState();
}

class _TimerSelectionPageState extends State<TimerSelectionPage> {
  int isSelected = 0;

  DateTime _today = DateTime.now();
  DateTime _dateTime = DateTime(0, 0, 0, 0, 30); //DateTime.now();
  DateTime _dateTimeStandard = DateTime(0, 0, 0, 0, 30);

  _TimerSelectionPageState();

  List<Items> users = [];
  bool lightTheme = false;
  Color prioAColor = Colors.red;
  Color prioBColor = Colors.purpleAccent;
  Color prioCColor = Colors.blueAccent;
  Color doneColor = Colors.green;
  late TimePickerSpinner mySpinner;

  @override
  void initState() {
    super.initState();

    mySpinner = TimePickerSpinner(
      isShowSeconds: false,
      time: _dateTimeStandard,
      minutesInterval: 1,
      //highlightedTextStyle: TextStyle(color: Colors.white),
      onTimeChange: (hh) {
        setState(() {
          _dateTime = hh;
        });
      },
    );
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
            children: [
              Expanded(
                child: SizedBox(
                  height: 750,

                  ///scrollable list
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 5,
                    ),

                    ///logic for reorder
                    itemCount: users.length,

                    itemBuilder: (context, index) {
                      final user = users[index];
                      return buildUser(index, user, 6.0);
                    },
                  ),
                ),
              ),
              Container(
                height: 200,

                color: lightTheme
                    ? Theme.of(context).primaryColor
                    : const Color(0xFF424242),
                child: mySpinner,
                //color: ThemeData.,
              ),
              //bottom box bellow the list -> you can scroll further up
            ],
          ),
          floatingActionButton: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [],
          ),
        ),
      );

  ///this is one list entry
  Widget buildUser(int index, Items user, double edgeInsets) {
    Color currentColor = getMyColor(user.prio, user.done);
    Color currentTextColor = getOppositeColor(currentColor);

    return ListTile(
      ///key needed for ListTile
      key: ValueKey(user),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      tileColor:
          index == isSelected ? currentColor : currentColor.withOpacity(0.3),
      onTap: () => setState(() {
        if (isSelected == index) {
          ///already selected
          isSelected = -1;
          mySpinner = TimePickerSpinner(
            isShowSeconds: false,
            time: _dateTimeStandard,
            minutesInterval: 1,
            //highlightedTextStyle: TextStyle(color: Colors.white),
            onTimeChange: (hh) {
              setState(() {
                _dateTime = hh;
              });
            },
          );
        } else {
          isSelected = index;
          mySpinner = TimePickerSpinner(
            isShowSeconds: false,
            time: DateTime(0, 0, 0, 0, 0, 0, 0)
                .add(Duration(minutes: users[index].time)),
            minutesInterval: 1,
            //highlightedTextStyle: TextStyle(color: Colors.white),
            onTimeChange: (hh) {
              setState(() {
                _dateTime = hh;
              });
            },

          );
          print(mySpinner.time);
          // .add(Duration(minutes: users[index].time));
        }
      }),
      title: Text(user.name,
          style: TextStyle(color: getOppositeColor(currentTextColor))),
      trailing: Theme(
        data: ThemeData(hintColor: currentTextColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///duration
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: currentTextColor,
                border: Border.all(),
                borderRadius: BorderRadius.circular(360.0),
              ),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Center(
                    child: Text(user.time.toString(),
                        style: TextStyle(
                            color: getOppositeColor(currentTextColor)))),
              ),
            ),
            const SizedBox(width: 10),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: currentTextColor,
                border: Border.all(),
                borderRadius: BorderRadius.circular(360.0),
              ),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Center(
                    child: Text(getPrioText(user.prio),
                        style: TextStyle(
                            color: getOppositeColor(currentTextColor)))),
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
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
    });
  }

  void loadColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prioAColor = Color(prefs.getInt('prio_a_color') ?? Colors.red.value);
      prioBColor = Color(prefs.getInt('prio_b_color') ?? Colors.orange.value);
      prioCColor =
          Color(prefs.getInt('prio_c_color') ?? Colors.lightBlueAccent.value);
      doneColor = Color(prefs.getInt('done_color') ?? Colors.green.value);
    });
  }

  Color getMyColor(int prio, bool done) {
    loadColors();
    if (done) {
      return doneColor;
    }
    switch (prio) {
      case 1:
        return prioAColor;
      case 2:
        return prioBColor;
      case 3:
        return prioCColor;
    }
    //if nothing fits
    return prioAColor;
  }

/*
  Widget hourMinuteSecond() {

    return ;
  }

   */
}
