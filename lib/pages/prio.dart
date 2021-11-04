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
    users = [mag, joh, new Items(name: "Johanna Müller", prio: 2), new Items(name: "Johanna Müller", prio: 2),new Items(name: "Johanna Müller", prio: 2), new Items(name: "Johanna Müller", prio: 2), new Items(name: "Johanna Müller", prio: 2),new Items(name: "Johanna Müller", prio: 2), new Items(name: "Johanna Müller", prio: 2),new Items(name: "Johanna Müller", prio: 2),new Items(name: "Johanna Müller", prio: 2),new Items(name: "Johanna Müller", prio: 2),new Items(name: "Johanna Müller", prio: 2)];
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
                onPressed: () => _displayDialog(),
                tooltip: 'Add Item',
                child: Icon(Icons.add)
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
        tileColor: setColor(user.prio, user.done),
        title: Text(user.name),
        trailing: Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //Text(user.prio),
            ToggleButtons(
                children: <Widget>[
                  // first toggle button
                  Text('A',
                      style: TextStyle(
                        fontSize: 25,
                      )),
                  // second toggle button
                  Text('B',
                      style: TextStyle(
                        fontSize: 25,
                      )),
                  // third toggle button
                  Text('C',
                      style: TextStyle(
                        fontSize: 25,
                      )),
                ],
                // logic for button selection below
                onPressed: (int index) {
                  setState(() {
                    user.prio = index + 1;
                  });
                },
                selectedColor: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                borderWidth: 3,
                isSelected: [1 == user.prio, 2 == user.prio, 3 == user.prio]),
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
              icon: Icon(Icons.done_outline, color: !user.done  ? Colors.green : Colors.black),
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

  Color setColor(int prio, bool done) {
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
}
