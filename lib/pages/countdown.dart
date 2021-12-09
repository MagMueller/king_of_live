import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class CountdownPage extends StatefulWidget {
  CountdownPage({Key? key, this.title, this.time}) : super(key: key);
  final DateTime? time;
  final String? title;

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  CountDownController _controller = CountDownController();
  late int _duration;
  bool started = false;
  bool first = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.time != null) {
      _duration = widget.time!.hour * 60 * 60 +
          widget.time!.minute * 60 +
          widget.time!.second;
    } else {
      _duration = 30 * 60;
    }
    print("my time:" +
        _duration.toString() +
        "current widget time " +
        widget.time.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
          child: CircularCountDownTimer(
        // Countdown duration in Seconds.
        duration: _duration,

        // Countdown initial elapsed Duration in Seconds.
        initialDuration: 0,

        // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
        controller: _controller,

        // Width of the Countdown Widget.
        width: MediaQuery.of(context).size.width / 2,

        // Height of the Countdown Widget.
        height: MediaQuery.of(context).size.height / 2,

        // Ring Color for Countdown Widget.
        ringColor: Colors.grey[300]!,

        // Ring Gradient for Countdown Widget.
        ringGradient: null,

        // Filling Color for Countdown Widget.
        fillColor: Colors.green[100]!,

        // Filling Gradient for Countdown Widget.
        fillGradient: null,

        // Background Color for Countdown Widget.
        backgroundColor: Colors.green[500],

        // Background Gradient for Countdown Widget.
        backgroundGradient: null,

        // Border Thickness of the Countdown Ring.
        strokeWidth: 20.0,

        // Begin and end contours with a flat edge and no extension.
        strokeCap: StrokeCap.round,

        // Text Style for Countdown Text.
        textStyle: TextStyle(
            fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),

        // Format for the Countdown Text.
        textFormat: CountdownTextFormat.MM_SS,

        // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
        isReverse: true,

        // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
        isReverseAnimation: true,

        // Handles visibility of the Countdown Text.
        isTimerTextShown: true,

        // Handles the timer start.
        autoStart: false,

        // This Callback will execute when the Countdown Starts.
        onStart: () {
          // Here, do whatever you want
          print('Countdown Started');
        },

        // This Callback will execute when the Countdown Ends.
        onComplete: () {
          // Here, do whatever you want
          print('Countdown Ended');
        },
      )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (() {
            // your code here
            if (!started) {
              //first time -> start
              if (first) {
                return _button(
                    icon: Icon(Icons.play_circle_fill),
                    title: "Start",
                    onPressed: () {
                      started = !started;
                      first = !first;
                      _controller.start();
                    });
              } else {
                //next -> rsume
                return _button(
                    icon: Icon(Icons.play_circle_fill),
                    title: "Resume",
                    onPressed: () {
                      started = !started;
                      _controller.resume();
                    });
              }
            } else {
              return _button(
                  icon: Icon(Icons.pause_circle_filled),
                  title: "Pause",
                  onPressed: () {
                    started = !started;
                    _controller.pause();
                  });
            }
          }()),
        ],
      ),
    );
  }

  _button(
      {required String title, VoidCallback? onPressed, required Icon icon}) {
    return Expanded(
        child: IconButton(
      icon: icon,
      onPressed: onPressed,
      color: Colors.green,
    ));
  }
}
