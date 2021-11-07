import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../model/items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drag_and_drop_calendar.dart';

class PrioPage extends StatefulWidget {
  const PrioPage({Key? key}) : super(key: key);

  @override
  _PrioPageState createState() => _PrioPageState();
}

class _PrioPageState extends State<PrioPage> {
  bool lightTheme = false;
  List<Items> users = [];
  List<bool> isSelected = [true, false, false];

  final TextEditingController _textFieldController = TextEditingController();
  Color prioAColor = Colors.red;
  Color prioBColor = Colors.purpleAccent;
  Color prioCColor = Colors.blueAccent;
  Color doneColor = Colors.green;

  bool donesBellowEveryItems = false;

  @override
  void initState() {
    super.initState();

    ///load Data
    loadItems();
    loadColors();
  }

  @override
  Widget build(BuildContext context) => Theme(
        data: lightTheme ? ThemeData.light() : ThemeData.dark(),
        child: Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              child: const Text('Set priorities'),
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
                  child: ReorderableListView.builder(
                    shrinkWrap: true,

                    ///logic for reorder
                    itemCount: users.length,
                    onReorder: (oldIndex, newIndex) => setState(() {
                      final index =
                          newIndex > oldIndex ? newIndex - 1 : newIndex;
                      final user = users.removeAt(oldIndex);
                      users.insert(index, user);
                    }),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ///with sized box on the left the buttons are more in center
              const SizedBox(
                width: 0,
              ),
              FloatingActionButton(
                  heroTag: "delete",
                  onPressed: () => deleteAllItems(),
                  child: const Icon(Icons.delete_sharp)),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FloatingActionButton(
                    heroTag: "calendarView",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DragAndDropCalendar()),
                      ).then((context) {
                        loadItems();
                      });
                    },
                    child: const Icon(
                      Icons.calendar_today_rounded,
                      size: 30,
                    )),
              ),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FloatingActionButton(
                    heroTag: "newItem",
                    onPressed: () => _addNewItem(),
                    tooltip: 'Add Item',
                    child: const Icon(
                      Icons.add,
                      size: 50,
                    )),
              ),
              FloatingActionButton(
                child: const Icon(Icons.shuffle),
                heroTag: "reorder",
                onPressed: orderList,
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
      tileColor: currentColor,
      title: Text(user.name, style: TextStyle(color: currentTextColor)),
      trailing: Theme(
        data: ThemeData(hintColor: currentTextColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///Text field for task time
            SizedBox(
              width: 30,
              height: 40,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: TextField(
                  style: TextStyle(color: currentTextColor),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: user.time.toString(),
                    border: InputBorder.none,
                  ),
                  onChanged: (String time) {
                    setState(() {
                      user.time = int.parse(time);
                      saveItems(users);
                    });
                  },
                ),
              ),
            ),

            ///Prio Button
            ElevatedButton(
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.resolveWith(
                      (states) => const Size(1, 40)),
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => currentColor),

                  ///backgroundColor: get_my_color(user.prio, user.done),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(700.0),
                          side: BorderSide(color: currentColor, width: 10.0)))),
              child: Text(
                getPrioText(user.prio),
                style: TextStyle(color: currentTextColor),
              ),

              ///prio logic
              onPressed: () {
                setState(() {
                  if (user.prio == 3) {
                    user.prio = 1;
                  } else {
                    user.prio += 1;
                  }
                  saveItems(users);
                });
              },
            ),
            IconButton(
              iconSize: 22,
              icon: Icon(Icons.edit, color: currentTextColor),
              onPressed: () => edit(index),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: currentTextColor),
              onPressed: () => remove(index),
            ),
            IconButton(
              icon: Icon(Icons.done_outline,
                  color: user.done ? Colors.green : currentTextColor),
              onPressed: () => done(index),
            ),
          ],
        ),
      ),
    );
  }

  void remove(int index) => setState(() {
        users.removeAt(index);
        saveItems(users);
      });

  void edit(int index) => showDialog(
        context: context,
        builder: (context) {
          final user = users[index];

          return AlertDialog(
            content: TextFormField(
              initialValue: user.name,
              onFieldSubmitted: (_) => Navigator.of(context).pop(),
              onChanged: (name) => setState(() {
                user.name = name;
                saveItems(users);
              }),
            ),
          );
        },
      );

  void orderList() => setState(() {
        if (donesBellowEveryItems) {
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

        /**
            List<Items> prioA = [];
            List<Items> prioB = [];
            List<Items> prioC = [];
            for (int i = 0; i < users.length; i++) {
            if (users[i].prio == 1) {
            prioA.add(users[i]);
            } else if (users[i].prio == 2) {
            prioB.add(users[i]);
            } else if (users[i].prio == 3) {
            prioC.add(users[i]);
            }
            }
            users = [...prioA, ...prioB, ...prioC];

         **/
        donesBellowEveryItems = !donesBellowEveryItems;
        saveItems(users);
      });

  String getPrioText(int prio) {
    List<String> prios = ["A", "B", "C"];
    if (prio <= 3 && prio >= 1) {
      return prios[prio - 1];
    } else {
      return "Error";
    }
  }

  _addTodoItem(String name) => setState(() {
        users.add(Items(name: name));
        saveItems(users);
      });

  Future<void> _addNewItem() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new todo item'),
          content: TextField(
            autofocus: true,
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your new todo'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  done(int index) {
    setState(() {
      users[index].done = !users[index].done;
      saveItems(users);
    });
  }

  deleteAllItems() {
    setState(() {
      users = [];
    });
    saveItems(users);
  }

  Future<void> loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> usersString = prefs.getStringList('users') ?? [];
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
}

Color getOppositeColor(Color currentColor) {
  Color currentTextColor = useWhiteForeground(currentColor)
      ? const Color(0xffffffff)
      : const Color(0xff000000);

  return currentTextColor;
}

saveItems(List<Items> users) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> usersStrings = [];
  for (int i = 0; i < users.length; i++) {
    usersStrings.add(jsonEncode(users[i]));
  }
  //print("This will be saved: $users_strings");
  prefs.setStringList('users', usersStrings);
}
