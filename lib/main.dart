
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:king_of_live/pages/drag_and_drop_calendar.dart';
import '../pages/prio.dart';
import '../pages/settings.dart';
//import '../pages/calendar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


void main() {
  runApp(const MaterialApp(

    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KOL'),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme().apply(bodyColor: Colors.white),
            ),
            child: PopupMenuButton<int>(
              color: Colors.indigo,
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 0,
                  child: Text('Settings'),
                ),

                PopupMenuDivider(),

              ],
            ),
          ),
        ],



      ),

      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text(
                'Start Prioritize',
                style: TextStyle(fontSize: 30),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrioPage()),
                );
              },
            ),
            ElevatedButton(
              child: const Text(
                'Calendar',
                style: TextStyle(fontSize: 30),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DragAndDropCalendar()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>  SettingsRoute()),
        );
        break;

    }
  }
}



class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Second Route"),
        ),
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go back!'),
              ),
              SizedBox(
                width: 50,
                height: 100,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CalenderRoute()),
                  );
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ));
  }
}

class CalenderRoute extends StatelessWidget {
  const CalenderRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CalenderRoute"),
      ),
      body: Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PrioPage()),
            );
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

/**


//import 'dart:math';

import 'sample_browser.dart';
///Package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

///Local import
//import '../../model/sample_view.dart';
import 'model/model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await updateControlItems();
  print("We are here");
  runApp(const SampleBrowser());
}
**/