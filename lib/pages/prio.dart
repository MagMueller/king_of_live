import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../model/items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drag_and_drop_calendar.dart';
import 'package:duration_picker/duration_picker.dart';


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

    /*
    _textFieldController.addListener(() {
      final newText = _textFieldController.text;
      _textFieldController.value = _textFieldController.value.copyWith(
        text: newText,
        selection: TextSelection(baseOffset: newText.length, extentOffset: newText.length),
        composing: TextRange.empty,
      );
    });
    */

    return ListTile(
      ///key needed for ListTile
      key: ValueKey(user),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      tileColor: currentColor,
      title: TextButton(
          onPressed: () => edit(index),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(user.name,
                textAlign: TextAlign.left,
                style: TextStyle(color: currentTextColor)),
          )),

      trailing: Theme(
        data: ThemeData(hintColor: currentTextColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///Text field for task time

            buildBuilderDurationPicker(user, currentColor),

            //TextButton(onPressed: () => openDurationPicker, child: Text(user.time.toString())),
            const SizedBox(width: 4),

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

  /// Time Picker Duration Button
  Builder buildBuilderDurationPicker(Items user, Color currentColor) {
    return Builder(
        builder: (BuildContext context) => ElevatedButton(
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
              onPressed: () async {
                var resultingDuration = await showDurationPicker(
                  context: context,
                  initialTime: Duration(minutes: user.time),
                );

                if (resultingDuration != null) {
                  user.time = resultingDuration.inMinutes;
                  saveItems(users);
                }
              },
              child: Text(
                user.time.toString(),
              ),
            ));
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

  _addTodoItem(String name, int prio) => setState(() {
        users.add(Items(name: name, prio: prio));
        saveItems(users);
      });

  Future<void> _addNewItem() async {
    int currentPrio = 3;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add a new todo item'),
              content: TextField(
                onSubmitted: (newTodo) => onFinishSubmitted(currentPrio),
                autofocus: true,
                controller: _textFieldController,
                decoration:
                    const InputDecoration(hintText: 'Type your new todo'),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.resolveWith(
                          (states) => const Size(1, 40)),
                      backgroundColor: MaterialStateProperty.resolveWith(
                              (states) =>  getMyColor(currentPrio, false)),
                      ///backgroundColor: get_my_color(user.prio, user.done),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(700.0),
                        side: BorderSide(color: getMyColor(currentPrio, false), width: 10.0)
                      ))),
                  child: Text(
                    getPrioText(currentPrio),
                    style: TextStyle(color: getOppositeColor(getMyColor(currentPrio, false))),
                  ),

                  ///prio logic
                  onPressed: () {
                    setState(() {
                      if (currentPrio == 3) {
                        currentPrio = 1;
                      } else {
                        currentPrio += 1;
                      }
                      //saveItems(users);
                    });
                  },
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () => onFinishSubmitted(currentPrio),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void onFinishSubmitted(int currentPrio) {
    Navigator.of(context).pop();
    _addTodoItem(_textFieldController.text, currentPrio);
    _textFieldController.text = "";
  }

  void done(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int score = prefs.getInt('score') ?? 0;

    setState(() {
      users[index].done = !users[index].done;
    });

    if (users[index].done) {
      /// increase score
      score += 4 - users[index].prio;
      safeItem(users[index]);
    } else {
      /// decrease score
      score -= 4 - users[index].prio;
    }
    saveItems(users);
    prefs.setInt('score', score);
  }

  deleteAllItems() {
    setState(() {
      users = [];
    });
    saveItems(users);
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

  void safeItem(Items doneItem) async {
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

    ///append done item
    userList.add(doneItem);
    saveItems(userList, key: 'done_items');

    ///safe list
    ///
  }
}

Color getOppositeColor(Color currentColor) {
  Color currentTextColor = useWhiteForeground(currentColor)
      ? const Color(0xffffffff)
      : const Color(0xff000000);

  return currentTextColor;
}

saveItems(List<Items> users, {String key = 'users'}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> usersStrings = [];
  for (int i = 0; i < users.length; i++) {
    usersStrings.add(jsonEncode(users[i]));
  }
  //print("This will be saved: $usersStrings");
  prefs.setStringList(key, usersStrings);
}
