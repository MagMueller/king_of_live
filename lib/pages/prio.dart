import 'package:flutter/material.dart';
import '../model/item.dart';

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

    Items mag = Items(name: "Magnus Müller", prio: 1);
    Items joh = new Items(name: "Johanna Müller", prio: 2);
    users = [
      mag,
      joh,
      new Items(name: "Johanna Müller", prio: 2),
      new Items(name: "Johanna Müller", prio: 2),
      new Items(name: "Johanna Müller", prio: 2),
      new Items(name: "Johanna Müller", prio: 2),
      new Items(name: "Johanna Müller", prio: 2),
      new Items(name: "Johanna Müller", prio: 2),
      new Items(name: "Johanna Müller", prio: 2),
      new Items(name: "Johanna Müller", prio: 2),
      new Items(name: "Johanna Müller", prio: 2),
      new Items(name: "Johanna Müller", prio: 2),
      new Items(name: "Johanna Müller", prio: 2)
    ];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Prioritize"), //MyApp.title
          centerTitle: true,
        ),
        body: ReorderableListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 4),
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
                onPressed: () => delete_all_items(), child: Icon(Icons.delete_sharp)),
            Container(
              height: 80.0,
              width: 80.0,
              child: FloatingActionButton(
                  onPressed: () => _displayDialog(),
                  tooltip: 'Add Item',
                  child: Icon(Icons.add)),
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

  void remove(int index) => setState(() => users.removeAt(index));

  void edit(int index) => showDialog(
        context: context,
        builder: (context) {
          final user = users[index];

          return AlertDialog(
            content: TextFormField(
              initialValue: user.name,
              onFieldSubmitted: (_) => Navigator.of(context).pop(),
              onChanged: (name) => setState(() => user.name = name),
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
      });

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

  String get_prio_text(int prio) {
    List<String> prios = ["A", "B", "C"];
    if (prio <= 3 && prio >= 1) {
      return prios[prio - 1];
    } else {
      return "Error";
    }
  }

  _addTodoItem(String name) =>
      setState(() => users.add(Items(name: name, prio: 3)));

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
    });
  }

  delete_all_items() {
    users = [];
  }
}
