import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() => runApp(CustomAppointmentDetails());

class CustomAppointmentDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomAppointmentTapDetails(),
    );
  }
}

class CustomAppointmentTapDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppointmentDetails();
}

List<String> colors = <String>[
  'Pink',
  'Blue',
  'Wall Brown',
  'Yellow',
  'Default'
];

class AppointmentDetails extends State<CustomAppointmentTapDetails> {
  CalendarController _controller = CalendarController();
  String? _subjectText, _startTimeText, _endTimeText, _dateText, _timeDetails;
  Color? headerColor, viewHeaderColor, calendarColor, defaultColor;

  @override
  void initState() {
    _subjectText = '';
    _startTimeText = '';
    _endTimeText = '';
    _dateText = '';
    _timeDetails = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(Icons.color_lens),
              itemBuilder: (BuildContext context) {
                return colors.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              onSelected: (String value) {
                setState(() {
                  if (value == 'Pink') {
                    headerColor = const Color(0xFF09e8189);
                    viewHeaderColor = const Color(0xFF0f3acb6);
                    calendarColor = const Color(0xFF0ffe5d8);
                  } else if (value == 'Blue') {
                    headerColor = const Color(0xFF0007eff);
                    viewHeaderColor = const Color(0xFF03aa4f6);
                    calendarColor = const Color(0xFF0bae5ff);
                  } else if (value == 'Wall Brown') {
                    headerColor = const Color(0xFF0937c5d);
                    viewHeaderColor = const Color(0xFF0e6d9b1);
                    calendarColor = const Color(0xFF0d1d2d6);
                  } else if (value == 'Yellow') {
                    headerColor = const Color(0xFF0f7ed53);
                    viewHeaderColor = const Color(0xFF0fff77f);
                    calendarColor = const Color(0xFF0f7f2cc);
                  } else if (value == 'Default') {
                    headerColor = null;
                    viewHeaderColor = null;
                    calendarColor = null;
                  }
                });
              },
            ),
          ],
          backgroundColor: headerColor,
          centerTitle: true,
          titleSpacing: 60,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SfCalendar(
                viewHeaderStyle:
                    ViewHeaderStyle(backgroundColor: viewHeaderColor),
                backgroundColor: calendarColor,
                view: CalendarView.week,
                controller: _controller,
                allowedViews: [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.workWeek,
                  CalendarView.month,
                  CalendarView.timelineDay,
                  CalendarView.timelineWeek,
                  CalendarView.timelineWorkWeek,
                ],
                monthViewSettings: MonthViewSettings(showAgenda: true),
                dataSource: getCalendarDataSource(),
                onTap: calendarTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Meeting appointmentDetails = details.appointments![0];
      _subjectText = appointmentDetails.eventName;
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.from!)
          .toString();
      _startTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.from!).toString();
      _endTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.to!).toString();
      if (appointmentDetails.isAllDay!) {
        _timeDetails = 'All day';
      } else {
        _timeDetails = '$_startTimeText - $_endTimeText';
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(child: new Text('$_subjectText')),
              content: Container(
                height: 80,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '$_dateText',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(''),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(_timeDetails!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15)),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text('close'))
              ],
            );
          });
    }
  }

  MeetingDataSource getCalendarDataSource() {
    List<Meeting> appointments = <Meeting>[];
    appointments.add(Meeting(
      from: DateTime.now(),
      to: DateTime.now().add(const Duration(hours: 1)),
      eventName: 'Meeting',
      background: Colors.pink,
      isAllDay: true,
    ));
    appointments.add(Meeting(
      from: DateTime.now().add(const Duration(hours: 4, days: -1)),
      to: DateTime.now().add(const Duration(hours: 5, days: -1)),
      eventName: 'Release Meeting',
      background: Colors.lightBlueAccent,
    ));
    appointments.add(Meeting(
      from: DateTime.now().add(const Duration(hours: 2, days: -2)),
      to: DateTime.now().add(const Duration(hours: 4, days: -2)),
      eventName: 'Performance check',
      background: Colors.amber,
    ));
    appointments.add(Meeting(
      from: DateTime.now().add(const Duration(hours: 6, days: -3)),
      to: DateTime.now().add(const Duration(hours: 7, days: -3)),
      eventName: 'Support',
      background: Colors.green,
    ));
    appointments.add(Meeting(
      from: DateTime.now().add(const Duration(hours: 6, days: 2)),
      to: DateTime.now().add(const Duration(hours: 7, days: 2)),
      eventName: 'Retrospective',
      background: Colors.purple,
    ));

    return MeetingDataSource(appointments);
  }
}

class Meeting {
  Meeting(
      {this.eventName,
      this.from,
      this.to,
      this.background,
      this.isAllDay = false});

  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}
