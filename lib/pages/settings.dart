import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_review/in_app_review.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  bool lightTheme = false;

  //Color currentColor = Colors.limeAccent;
  Color prioAColor = Colors.red;
  Color prioBColor = Colors.orange;
  Color prioCColor = Colors.lightBlueAccent;
  Color doneColor = Colors.green;
  final InAppReview inAppReview = InAppReview.instance;

  //List<Color> currentColors = [Colors.limeAccent, Colors.green];

  @override
  void initState() {
    loadColors();
    super.initState();
  }

  //
  // void changeColor(Color color) => setState(() => currentColor = color);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lightTheme ? ThemeData.light() : ThemeData.dark(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              child: const Text('Settings'),
              onDoubleTap: () => setState(() => lightTheme = !lightTheme),
            ),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(text: 'Color'),
                Tab(text: 'Autor'),
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
                  buildColorChooser(
                      context, prioAColor, "Prio A", "prio_a_color"),
                  //SizedBox(height: 10,),
                  buildColorChooser(
                      context, prioBColor, "Prio B", "prio_b_color"),
                  //SizedBox(height: 10,),
                  buildColorChooser(
                      context, prioCColor, "Prio C", "prio_c_color"),
                  buildColorChooser(context, doneColor, "Done", "done_color"),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Magnus Müller",
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    "Thank you for using my app.\n\nPlease contact me for any feedback.\nThank you for helping me to improve and optimize the app. A Google Play review or donation would help me immensely. Also check my other social media channels.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          iconSize: 100.0,
                          icon: FaIcon(
                            FontAwesomeIcons.paypal,
                          ),
                          onPressed: () async {
                            const url =
                                'https://www.paypal.com/paypalme/stormysix6/10';
                            launch(url);
                          }),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          IconButton(
                              iconSize: 100.0,
                              icon: FaIcon(
                                FontAwesomeIcons.googlePlay,
                              ),
                              onPressed: () async {
                                const url =
                                    'http://play.google.com/store/apps/details?id=.de.king_of_live';
                                launch(url);
                              }),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          iconSize: 70.0,
                          icon: FaIcon(
                            FontAwesomeIcons.youtubeSquare,
                          ),
                          onPressed: () async {
                            const url =
                                'https://www.youtube.com/channel/UC9V_QjZXWEU9uBJuc78vnaA';
                            launch(url);
                          }),
                      IconButton(
                          iconSize: 70.0,
                          icon: FaIcon(
                            FontAwesomeIcons.tiktok,
                          ),
                          onPressed: () async {
                            const url = 'https://www.tiktok.com/@stormysix';
                            launch(url);
                          }),
                      IconButton(
                          iconSize: 70.0,
                          icon: FaIcon(
                            FontAwesomeIcons.instagram,
                          ),
                          onPressed: () async {
                            const url =
                                'https://www.instagram.com/magnus_yeah/';
                            launch(url);
                          }),
                      IconButton(
                          iconSize: 70.0,
                          icon: FaIcon(
                            FontAwesomeIcons.mailBulk,
                          ),
                          onPressed: () async {
                            const url = 'mailto:mamagnus00@gmail.com';
                            launch(url);
                          })
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox buildColorChooser(
      BuildContext context, Color currentColor, String name, String storeKey) {
    return SizedBox(
      width: 190,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  titlePadding: const EdgeInsets.all(0.0),
                  contentPadding: const EdgeInsets.all(0.0),
                  content: SingleChildScrollView(
                    child: MaterialPicker(
                      pickerColor: currentColor,
                      onColorChanged: (Color color) => setState(() {
                        currentColor = color;
                        saveColor(storeKey, currentColor);
                      }),
                      enableLabel: true,
                    ),
                  ),
                );
              },
            );
          },
          child: Text(name),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith((states) => currentColor),
              foregroundColor: MaterialStateProperty.resolveWith((states) =>
                  useWhiteForeground(currentColor)
                      ? const Color(0xffffffff)
                      : const Color(0xff000000))),
        ),
      ),
    );
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

  void saveColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('prio_a_color', prioAColor.value);
    prefs.setInt('prio_b_color', prioBColor.value);
    prefs.setInt('prio_c_color', prioCColor.value);
    prefs.setInt('done_color', doneColor.value);
  }

  void saveColor(String name, Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(name, color.value);

    setState(() {
      switch (name) {
        case 'prio_a_color':
          prioAColor = color;
          break;
        case 'prio_b_color':
          prioBColor = color;
          break;
        case 'prio_c_color':
          prioCColor = color;
          break;
        case 'done_color':
          doneColor = color;
          break;
      }
    });
  }
}
