import 'package:flutter/material.dart';
import 'package:king_of_live/pages/drag_and_drop_calendar.dart';
import '../pages/prio.dart';
import '../pages/settings.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('King of your live'),
        centerTitle: true,
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.white),
              textTheme: const TextTheme().apply(bodyColor: Colors.white),
            ),
            child: PopupMenuButton<int>(
              color: Colors.indigo,
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text('Settings'),
                ),
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
                'Set priorities',
                style: TextStyle(fontSize: 30),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrioPage()),
                );
              },
            ),
            ElevatedButton(
              child: const Text(
                'Structure your day',
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
          MaterialPageRoute(builder: (context) => const SettingsRoute()),
        );
        break;
    }
  }
}
