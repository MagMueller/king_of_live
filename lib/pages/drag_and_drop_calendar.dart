///Dart imports
import 'dart:convert';

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
    CalendarView.week,
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

  Color prioAColor = Colors.red;
  Color prioBColor = Colors.orange;
  Color prioCColor = Colors.lightBlueAccent;
  Color doneColor = Colors.green;

  @override
  void initState() {
    ///loadItems();
    loadColors();
    _currentView = CalendarView.day;
    _calendarController.view = _currentView;
    loadMeetings();
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const CircularProgressIndicator();

    final Widget calendar = Theme(

        /// The key set here to maintain the state,
        ///  when we change the parent of the widget
        key: _globalKey,
        data: ThemeData.light(),
        child: _getDragAndDropCalendar(
            _calendarController, _events, _onViewChanged));

    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(children: <Widget>[
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
              : Container(
                  color: model.cardThemeColor,
                  padding: const EdgeInsets.only(top: 20),
                  child: calendar),
        ),
        FloatingActionButton(
            child: const Icon(Icons.refresh_outlined), onPressed: reorder),
      ]),
    );
  }

  /// Update the current view when the view changed and update the scroll view
  /// when the view changes from or to month view because month view placed
  /// on scroll view.
  void _onViewChanged(ViewChangedDetails viewChangedDetails) {
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
  List<Appointment> getAppointmentDetails({bool reorder = false}) {
    final List<Appointment> appointments = <Appointment>[];
    DateTime today = DateTime.now();

    /// first Meeting now
    DateTime nextMeeting = today;

    //DateTime(today.year, today.month, today.day, 8, 0, 0);

    for (int i = 0; i < users.length; i++) {
      ///duration of event
      users[i].time = users[i].time == 0 ? 60 : users[i].time;
      DateTime startDate;

      /// is item already place? -> use this time : else calculate last stop
      if (users[i].placed && !reorder) {
        startDate = DateTime.parse(users[i].start);
      } else {


        /// just calculate new place, if it is not done
        if (!users[i].done) {
          startDate = nextMeeting;
          nextMeeting = startDate.add(Duration(minutes: users[i].time));
          users[i].placed = true;
        } else {
          /// skip done
          /// dont place them any more
          users[i].placed = false;
          continue;
        }
      }

      /// save beginning of Meeting
      users[i].start = startDate.toIso8601String();
      Appointment appointment = Appointment(
        subject: users[i].name,
        startTime: startDate,
        endTime: startDate.add(Duration(minutes: users[i].time)),
        color: getMyColor(users[i].prio, users[i].done),
      );

      appointments.add(appointment);
      users[i].myId = appointment.id as int;
    }
    saveItems(users);
    return appointments;
  }

  /// Returns the calendar widget based on the properties passed.
  SfCalendar _getDragAndDropCalendar(
      [CalendarController? calendarController,
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
      onDragEnd: dragEnd,
      dragAndDropSettings: const DragAndDropSettings(
          indicatorTimeFormat: 'hh:mm a', showTimeIndicator: true),
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      timeSlotViewSettings: const TimeSlotViewSettings(
          minimumAppointmentDuration: Duration(minutes: 15)),
    );
  }

  Future<void> loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> usersString = prefs.getStringList('users') ?? [];
    List<Items> userList = [];

    ///get every single item of the saved list and turn it into a user
    if (usersString != []) {
      for (int i = 0; i < usersString.length; i++) {
        Map<String, dynamic> map = jsonDecode(usersString[i]);
        Items loadedItem = Items.fromJson(map);
        userList.add(loadedItem);
      }
    }
    setState(() {
      users = userList;
      loading = false;
    });
  }

  void loadMeetings() async {
    await loadItems();
    setState(() {
      _events = _DataSource(getAppointmentDetails());
    });
  }

  void dragEnd(AppointmentDragEndDetails appointmentDragEndDetails) {
    dynamic appointment = appointmentDragEndDetails.appointment!;

    // change the time of the moved appointment
    for (int i = 0; i < users.length; i++) {
      if (users[i].myId == appointment.id) {
        users[i].start = appointment.startTime.toIso8601String();
        break;
      }
    }
    saveItems(users);
  }

  Color getMyColor(int prio, bool done) {
    loadColors();
    if (done) {
      return doneColor;
    }
    switch (prio) {
      case 1:
        return prioAColor;
      case 2:
        return prioBColor;
      case 3:
        return prioCColor;
    }

    //if nothing fits
    return prioAColor;
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

  reorder() async {
    await loadItems();
    setState(() {
      _events = _DataSource(getAppointmentDetails(reorder: true));
    });
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
