// ignore_for_file: file_names
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'prio.dart';
import 'package:flutter/material.dart';
import '../model/items.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({Key? key}) : super(key: key);

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  bool byDate = false;

  _CompletedPageState();

  List<Items> users = [];
  bool lightTheme = false;

  @override
  void initState() {
    super.initState();
    loadDoneItems();
  }

  @override
  Widget build(BuildContext context) => Theme(
        data: lightTheme ? ThemeData.light() : ThemeData.dark(),
        child: Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              child: const Text('My completed tasks'),
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
                    separatorBuilder: (BuildContext context, int index) => Divider(),

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
              Container(
                height: 80,

                color: lightTheme
                    ? Theme.of(context).primaryColor
                    : const Color(0xFF424242),
                //color: ThemeData.,
              ),
            ],
          ),

          ///Buttons in bottom row
          floatingActionButton: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ///with sized box on the left the buttons are more in center

              FloatingActionButton(
                child: const Icon(Icons.shuffle),
                heroTag: "reorder",
                onPressed: orderList,
              ),
              const SizedBox(width: 30,)
            ],
          ),
        ),
      );

  ///this is one list entry
  Widget buildUser(int index, Items user, double edgeInsets) {
    Color currentColor = Colors.green;
    Color currentTextColor = getOppositeColor(currentColor);

    return ListTile(

      ///key needed for ListTile
      key: ValueKey(user),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      tileColor: currentColor,
      title: Text(user.name, style: TextStyle(color:getOppositeColor(currentTextColor))),
      trailing: Theme(
        data: ThemeData(hintColor: currentTextColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [


            ///duration
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: currentTextColor,border: Border.all(), borderRadius: BorderRadius.circular(360.0),),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Center(child: Text(user.time.toString(), style: TextStyle(color:getOppositeColor(currentTextColor)))),
              ),
            ),
            const SizedBox(width: 10),
            ///Date
            Container(
              padding: EdgeInsets.all(13),
              decoration: BoxDecoration(color: currentTextColor,border: Border.all(), borderRadius: BorderRadius.circular(360.0),),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Center(child: Text(user.start.substring(0, 10), style: TextStyle(color:getOppositeColor(currentTextColor)))),
              ),
            ),
            const SizedBox(width: 10),
            ///Prio
            ///

            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: currentTextColor,border: Border.all(), borderRadius: BorderRadius.circular(360.0),),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Center(child: Text(getPrioText(user.prio), style: TextStyle(color:getOppositeColor(currentTextColor)))),
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

  void orderList() => setState(() {
    loadDoneItems();
        if (byDate) {
          users.sort((a, b) {
            int compare = (a.prio.compareTo(b.prio));
            if (compare == 0) {
              return (a.done ? 1 : 0).compareTo(b.done ? 1 : 0);
            } else {
              return compare;
            }
          });
        } else {
          users.sort((a, b) {
            int compare = (a.done ? 1 : 0).compareTo(b.done ? 1 : 0);
            if (compare == 0) {
              return (a.prio.compareTo(b.prio));
            } else {
              return compare;
            }
          });
        }
        byDate = !byDate;

      });

  void loadDoneItems() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> usersString = prefs.getStringList('done_items') ?? [];
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
}
