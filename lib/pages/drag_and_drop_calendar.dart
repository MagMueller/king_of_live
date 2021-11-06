///Dart imports
import 'dart:convert';

import 'dart:math';

///Package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:king_of_live/model/items.dart';
import 'package:shared_preferences/shared_preferences.dart';

///calendar import
import 'package:syncfusion_flutter_calendar/calendar.dart';

///Local import
import '../../model/sample_view.dart';
import 'prio.dart';

/// Widget of getting started calendar
class DragAndDropCalendar extends SampleView {
  /// Creates default getting started calendar
  const DragAndDropCalendar({Key? key}) : super(key: key);

  @override
  _DragAndDropCalendarState createState() => _DragAndDropCalendarState();
}

class _DragAndDropCalendarState extends SampleViewState {
  _DragAndDropCalendarState();

  _DataSource _events = _DataSource(<Appointment>[]);
  late CalendarView _currentView;

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    //CalendarView.week,
    //CalendarView.workWeek,
    CalendarView.timelineDay,
    //CalendarView.month,
    //CalendarView.timelineWeek,
    //CalendarView.timelineWorkWeek,
    //CalendarView.timelineMonth,
  ];

  /// Global key used to maintain the state, when we change the parent of the
  /// widget
  final GlobalKey _globalKey = GlobalKey();
  final ScrollController _controller = ScrollController();
  final CalendarController _calendarController = CalendarController();
  List<Items> users = [];
  bool loading = true;
  @override
  void initState() {
    //loadItems();
    _currentView = CalendarView.day;
    _calendarController.view = _currentView;
   // Future future = getAppointmentDetails();
    loadMeetings();

    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

  }

  @override
  Widget build(BuildContext context) {
    if(loading) return CircularProgressIndicator();

    final Widget calendar = Theme(

      /// The key set here to maintain the state,
      ///  when we change the parent of the widget
      //key: _globalKey,
        data: ThemeData.light(),
        child: _getDragAndDropCalendar(
            _calendarController, _events, _onViewChanged));

    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      body: Row(children: <Widget>[
        Expanded(
          child: _calendarController.view == CalendarView.month &&
              model.isWebFullView &&
              screenHeight < 800
              ? Scrollbar(
              isAlwaysShown: true,
              controller: _controller,
              child: ListView(
                controller: _controller,
                children: <Widget>[
                  Container(
                    color: model.cardThemeColor,
                    height: 600,
                    child: calendar,
                  )
                ],
              ))
              : Container(color: model.cardThemeColor, child: calendar),
        )
      ]),
    );
  }

  /// Update the current view when the view changed and update the scroll view
  /// when the view changes from or to month view because month view placed
  /// on scroll view.
  void _onViewChanged(ViewChangedDetails viewChangedDetails) {
    //loadItems();
    if (_currentView != CalendarView.month &&
        _calendarController.view != CalendarView.month) {
      _currentView = _calendarController.view!;
      return;
    }

    _currentView = _calendarController.view!;
    SchedulerBinding.instance?.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        // Update the scroll view when view changes.
      });
    });
  }

  /// Creates the required appointment details as a list.
  List<Appointment> getAppointmentDetails() {

    final List<String> subjectCollection = <String>[];
    final List<Color> colorCollection = <Color>[];

    final List<Appointment> appointments = <Appointment>[];

    //sort user by start time
    //TODO


    print("users123: $users");

    DateTime today = DateTime.now();
    DateTime nextMeeting = DateTime(
        today.year, today.month, today.day, 8, 0, 0);


    for (int i = 0; i < users.length; i++) {
      //subjectCollection.add(users[i].name);
      //colorCollection.add(get_my_color(users[i].prio, users[i].done));

      users[i].time = users[i].time == 0 ? 60: users[i].time;



      DateTime startDate;
      // is item already place? -> use this time : else calculate last stop
      if (users[i].placed){
        startDate = DateTime.parse(users[i].start);

      } else{
        startDate = nextMeeting;
        nextMeeting = startDate.add(Duration(minutes: users[i].time));
        users[i].placed = true;
      }


      appointments.add(Appointment(
        subject: users[i].name,
        startTime: startDate,
        endTime: startDate.add(Duration(minutes: users[i].time)),
        color: get_my_color(users[i].prio, users[i].done),
      ));
    }

    /**
    final Random random = Random();
    DateTime today = DateTime.now();


    final DateTime rangeStartDate =
    today.add(const Duration(days: -(365 ~/ 2)));
    final DateTime rangeEndDate = today.add(const Duration(days: 365));

    for (DateTime i = rangeStartDate;
    i.isBefore(rangeEndDate);
    i = i.add(const Duration(days: 1))) {
      final DateTime date = i;
      final int count = random.nextInt(2);

      for (int j = 0; j < count; j++) {
        final DateTime startDate = DateTime(
            today.year, today.month, today.day, 8 + random.nextInt(8), 0, 0);
      }
    }


    today = DateTime(today.year, today.month, today.day, 8);
    // added recurrence appointment
    appointments.add(Appointment(
        subject: 'Development status',
        startTime: today,
        endTime: today.add(const Duration(hours: 2)),
        color: colorCollection[random.nextInt(9)],
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=FR;INTERVAL=1'));

        **/
    return appointments;
  }

  /// Returns the calendar widget based on the properties passed.
  SfCalendar _getDragAndDropCalendar([CalendarController? calendarController,
    CalendarDataSource? calendarDataSource,
    ViewChangedCallback? viewChangedCallback]) {
    return SfCalendar(
      controller: calendarController,
      dataSource: calendarDataSource,
      allowedViews: _allowedViews,
      showNavigationArrow: model.isWebFullView,
      onViewChanged: viewChangedCallback,
      allowDragAndDrop: true,
      showDatePickerButton: true,
      dragAndDropSettings:
      const DragAndDropSettings(indicatorTimeFormat: 'hh:mm a'),
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      timeSlotViewSettings: const TimeSlotViewSettings(
          minimumAppointmentDuration: Duration(minutes: 15)),
    );
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
        Items loaded_item = Items.fromJson(map);
        print("list $loaded_item");
        user_list.add(loaded_item);
      }
    }
    setState(() {

      users = user_list;
      loading = false;
    });
  }

  void loadMeetings() async{
    await loadItems();
    setState(() {
      _events = _DataSource(getAppointmentDetails());
    });


  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
