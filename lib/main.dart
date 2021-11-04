import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../pages/prio.dart';

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
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text(
            'Start Prioritize',
            style: TextStyle(fontSize: 30),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondRoute()),
            );
          },
        ),
      ),
    );
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
