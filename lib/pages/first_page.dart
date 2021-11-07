import 'package:flutter/material.dart';
import 'package:king_of_live/pages/drag_and_drop_calendar.dart';
import '../pages/prio.dart';
import '../pages/settings.dart';



class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool lightTheme = false;
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lightTheme ? ThemeData.light() : ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            child: const Text('King of your live'),
            onDoubleTap: () => setState(() => lightTheme = !lightTheme),
          ),
          //title: const Text('King of your live'),
          centerTitle: true,
          actions: [
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.black,
                iconTheme: const IconThemeData(color: Colors.white),
                textTheme: const TextTheme().apply(bodyColor: Colors.white),
              ),
              child: PopupMenuButton<int>(
                color: Colors.blue,
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
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildCustomButton(context, "My Priorities", const PrioPage()),
              buildCustomButton(context, "My day", const DragAndDropCalendar()),

            ],
          ),
        ),
      ),
    );
  }


  SizedBox buildCustomButton(BuildContext context, String name, dynamic nextPage) {
    return SizedBox(
      height: 80,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: ElevatedButton(
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 30),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => nextPage),
                    );
                  },
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
