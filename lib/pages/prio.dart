import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/items.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drag_and_drop_calendar.dart';

class PrioPage extends StatefulWidget {
  @override
  _PrioPageState createState() => _PrioPageState();
}

class _PrioPageState extends State<PrioPage> {
  List<Items> users = [];
  List<bool> isSelected = [true, false, false];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Prioritize"), //MyApp.title
          centerTitle: true,
        ),
        body: ReorderableListView.builder(
          shrinkWrap: true,
          //padding: const EdgeInsets.symmetric(horizontal: 4),
          itemCount: users.length,
          onReorder: (oldIndex, newIndex) => setState(() {
            final index = newIndex > oldIndex ? newIndex - 1 : newIndex;

            final user = users.removeAt(oldIndex);
            users.insert(index, user);
          }),
          itemBuilder: (context, index) {
            final user = users[index];

            return buildUser(index, user, Colors.yellow, 6.0);
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
                onPressed: () => delete_all_items(),
                child: Icon(Icons.delete_sharp)),
            Container(
              height: 80.0,
              width: 80.0,
              child: FloatingActionButton(
                  onPressed: () => _displayDialog(),
                  tooltip: 'Add Item',
                  child: Icon(Icons.add)),
            ),
            Container(
              height: 80.0,
              width: 80.0,
              child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DragAndDropCalendar()),
                    );
                  },
                  child: Icon(Icons.calendar_today)),
            ),
            FloatingActionButton(
              child: Icon(Icons.shuffle),
              onPressed: orderList,
            ),
          ],
        ),
      );

  Widget buildUser(int index, Items user, Color color, double edge_insets) =>
      ListTile(
        key: ValueKey(user),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        tileColor: get_my_color(user.prio, user.done),
        title: Text(user.name),
        trailing: Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //Text(user.prio),
            SizedBox(
              width: 30,
              height: 40,
              child: Container(
                //padding: EdgeInsets.only(top: 9.0),
                alignment: Alignment.bottomCenter,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: user.time.toString(),
                    border: InputBorder.none,
                    //border: OutlineInputBorder(),
                    //contentPadding: EdgeInsets.only(top: 9.0)
                  ),
                  onChanged: (String time) {
                    setState(() {
                      user.time = int.parse(time);
                      _saveItems(users);
                    });
                  },
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.resolveWith(
                      (states) => Size(1, 40)),
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => get_my_color(user.prio, user.done)),
                  //backgroundColor: get_my_color(user.prio, user.done),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(700.0),
                          side: BorderSide(color: Colors.black, width: 3.0)))),
              child: Text(
                get_prio_text(user.prio),
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                setState(() {
                  if (user.prio == 3) {
                    user.prio = 1;
                  } else {
                    user.prio += 1;
                  }
                  _saveItems(users);
                });
              },
            ),

            IconButton(
              iconSize: 22,
              icon: Icon(Icons.edit, color: Colors.black),
              onPressed: () => edit(index),
            ),

            IconButton(
              icon: Icon(Icons.delete, color: Colors.black),
              onPressed: () => remove(index),
            ),
            IconButton(
              icon: Icon(Icons.done_outline,
                  color: !user.done ? Colors.green : Colors.black),
              onPressed: () => done(index),
            ),
          ],
        ),
      );

  void remove(int index) => setState(() {
        users.removeAt(index);
        _saveItems(users);
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
                _saveItems(users);
              }),
            ),
          );
        },
      );

  void orderList() => setState(() {
        List<Items> prio_A = [];
        List<Items> prio_B = [];
        List<Items> prio_C = [];
        for (int i = 0; i < users.length; i++) {
          if (users[i].prio == 1) {
            prio_A.add(users[i]);
          } else if (users[i].prio == 2) {
            prio_B.add(users[i]);
          } else if (users[i].prio == 3) {
            prio_C.add(users[i]);
          }
        }
        users = [...prio_A, ...prio_B, ...prio_C];
        _saveItems(users);
      });



  String get_prio_text(int prio) {
    List<String> prios = ["A", "B", "C"];
    if (prio <= 3 && prio >= 1) {
      return prios[prio - 1];
    } else {
      return "Error";
    }
  }

  _addTodoItem(String name) => setState(() {
        users.add(Items(name: name, prio: 3, done: false, time: 0));
        _saveItems(users);
      });

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new todo item'),
          content: TextField(
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
      _saveItems(users);
    });
  }

  delete_all_items() {
    setState(() {
      users = [];
    });
    _saveItems(users);
  }

  _saveItems(List<Items> users) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> users_strings = [];
    for (int i = 0; i < users.length; i++) {
      users_strings.add(jsonEncode(users[i]));
    }
    print("This will be saved: $users_strings");
    prefs.setStringList('users', users_strings);
  }

  Future<void> loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Started");

    List<String> users_string = prefs.getStringList('users') ?? [];

    List<Items> user_list = [];
    if (users_string == []) {
      print("no Data found");
    } else {
      print('Loaded $users_string');
      for (int i = 0; i < users_string.length; i++) {
        Map<String, dynamic> map = jsonDecode(users_string[i]);
        print("map: $map");
        final loaded_item = Items.fromJson(map);
        user_list.add(loaded_item);
      }
    }
    setState(() {
      users = user_list;
    });
  }
}
Color get_my_color(int prio, bool done) {
  if (done) {
    return Colors.green;
  } else if (prio == 1) {
    return Colors.red;
  } else if (prio == 2) {
    return Colors.orange;
  } else if (prio == 3) {
    return Colors.yellow;
  } else
    return Colors.pink;
}
