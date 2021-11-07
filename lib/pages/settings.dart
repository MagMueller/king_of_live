import 'package:flutter/cupertino.dart' show CupertinoTextField;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  bool lightTheme = true;

  //Color currentColor = Colors.limeAccent;
  Color prio_a_color = Colors.red;
  Color prio_b_color = Colors.orange;
  Color prio_c_color = Colors.lightBlueAccent;
  Color done_color = Colors.green;

  //List<Color> currentColors = [Colors.limeAccent, Colors.green];

  @override
  void initState() {
    loadColors();
  }

  //
  // void changeColor(Color color) => setState(() => currentColor = color);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lightTheme ? ThemeData.light() : ThemeData.dark(),
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              child: Text('Settings'),
              onDoubleTap: () => setState(() => lightTheme = !lightTheme),
            ),
            bottom: TabBar(
              tabs: <Widget>[
                const Tab(text: 'Color'),
                //const Tab(text: 'Material'),
                //const Tab(text: 'Block'),
              ],
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    elevation: 3.0,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            content: SingleChildScrollView(
                              child: MaterialPicker(
                                pickerColor: prio_a_color,
                                onColorChanged: (Color color) => setState(() {
                                  prio_a_color = color;
                                  saveColors();
                                }),
                                enableLabel: true,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Prio A'),
                    color: prio_a_color,
                    textColor: useWhiteForeground(prio_a_color)
                        ? const Color(0xffffffff)
                        : const Color(0xff000000),
                  ),
                  RaisedButton(
                    elevation: 3.0,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            content: SingleChildScrollView(
                              child: MaterialPicker(
                                pickerColor: prio_b_color,
                                onColorChanged: (Color color) => setState(() {
                                  prio_b_color = color;
                                  saveColors();
                                }),
                                enableLabel: true,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Prio B'),
                    color: prio_b_color,
                    textColor: useWhiteForeground(prio_b_color)
                        ? const Color(0xffffffff)
                        : const Color(0xff000000),
                  ),
                  RaisedButton(
                    elevation: 3.0,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            content: SingleChildScrollView(
                              child: MaterialPicker(
                                pickerColor: prio_c_color,
                                onColorChanged: (Color color) => setState(() {
                                  prio_c_color = color;
                                  saveColors();
                                }),
                                enableLabel: true,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Prio C'),
                    color: prio_c_color,
                    textColor: useWhiteForeground(prio_c_color)
                        ? const Color(0xffffffff)
                        : const Color(0xff000000),
                  ),
                  RaisedButton(
                    elevation: 3.0,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            content: SingleChildScrollView(
                              child: MaterialPicker(
                                pickerColor: done_color,
                                onColorChanged: (Color color) => setState(() {
                                  done_color = color;
                                  saveColors();
                                }),
                                enableLabel: true,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Done'),
                    color: done_color,
                    textColor: useWhiteForeground(done_color)
                        ? const Color(0xffffffff)
                        : const Color(0xff000000),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

      prio_a_color = Color(prefs.getInt('prio_a_color') ?? Colors.red.value);
      prio_b_color = Color(prefs.getInt('prio_b_color') ?? Colors.orange.value);
      prio_c_color =
          Color(prefs.getInt('prio_c_color') ?? Colors.lightBlueAccent.value);
      done_color = Color(prefs.getInt('done_color') ?? Colors.green.value);
    });
  }

  void saveColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('prio_a_color', prio_a_color.value);
    prefs.setInt('prio_b_color', prio_b_color.value);
    prefs.setInt('prio_c_color', prio_c_color.value);
    prefs.setInt('done_color', done_color.value);
  }
}


