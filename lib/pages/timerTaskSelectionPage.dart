// ignore_for_file: file_names
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'prio.dart';
import 'package:flutter/material.dart';
import '../model/items.dart';

import 'first_page.dart';
import 'timerTimeSelectionPage.dart';

class TimerTaskSelectionPage extends StatefulWidget {
  const TimerTaskSelectionPage({Key? key}) : super(key: key);

  @override
  State<TimerTaskSelectionPage> createState() => _TimerTaskSelectionPageState();
}

class _TimerTaskSelectionPageState extends State<TimerTaskSelectionPage> {
  int isSelected = 0;

  //DateTime _today = DateTime.now();
  //DateTime zero = DateTime(0, 0, 0, 0, 0);
  DateTime zero = DateTime(0, 0, 0, 0, 0); //DateTime.now();
  final DateTime _dateTimeStandard = DateTime(0, 0, 0, 0, 30);
  late DateTime newTime;

  //int lastSelected = 0;
  String defaultName = "No specific";
  late String todoName;


  _TimerTaskSelectionPageState();

  List<Items> users = [];
  bool lightTheme = false;
  Color prioAColor = Colors.red;
  Color prioBColor = Colors.purpleAccent;
  Color prioCColor = Colors.blueAccent;
  Color doneColor = Colors.green;

  @override
  void initState() {
    super.initState();
    newTime = _dateTimeStandard;
    todoName = defaultName;
    loadItems();
  }

  @override
  Widget build(BuildContext context) =>
      Theme(
        data: lightTheme ? ThemeData.light() : ThemeData.dark(),
        child: Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              child: const Text('Select a task'),
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
                        MaterialPageRoute(builder: (context) => const FirstScreen()),
                      );
                    },
                    icon: const Icon(Icons.navigate_before_rounded)),
              ),

              Container(
                decoration: roundBoxDeco(),
                child: IconButton(
                    onPressed: () {
                      //print("newTime: " + newTime.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            TimerSelectionPage(time: newTime, title: todoName)
                        ),
                      );
                    },
                    icon: const Icon(Icons.navigate_next_rounded)),
              ),
            ],
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
      onTap: () =>
          setState(() {
            if (isSelected == index) {
              ///already selected
              isSelected = -1;
              //_dateTime = _dateTimeStandard;
              newTime = _dateTimeStandard;
              todoName = defaultName;
            } else {
              isSelected = index;
              todoName = user.name;
              newTime = DateTime(
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0)
                  .add(Duration(minutes: users[index].time));

              //print("newTime:" + newTime.toString());
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

      if (users.isNotEmpty) {
        newTime = zero.add(Duration(minutes: users[0].time));
        todoName = users[0].name;
      }
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

BoxDecoration roundBoxDeco() {
  return BoxDecoration(
    color: Colors.blue,
    border: Border.all(width: 9.0),
    borderRadius: const BorderRadius.all(
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
