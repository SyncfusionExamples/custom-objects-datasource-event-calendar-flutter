import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() => runApp(const CustomAppointmentDetails());

class CustomAppointmentDetails extends StatelessWidget {
  const CustomAppointmentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomAppointmentTapDetails(),
    );
  }
}

class CustomAppointmentTapDetails extends StatefulWidget {
  const CustomAppointmentTapDetails({super.key});

  @override
  State<StatefulWidget> createState() => AppointmentDetails();
}

class AppointmentDetails extends State<CustomAppointmentTapDetails> {
  MeetingDataSource? _dataSource;

  @override
  void initState() {
    _dataSource = getCalendarDataSource();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: SafeArea(
            child: SfCalendar(
              view: CalendarView.week,
              monthViewSettings: const MonthViewSettings(showAgenda: true),
              dataSource: _dataSource,
              onTap: calendarTapped,
            ),
          )),
    );
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Meeting meeting = details.appointments![0];

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(child: const Text('Appointment details')),
              content: Text("${meeting.eventName}\nId: ${meeting.id}\nRecurrenceId: ${meeting.recurrenceId}"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('close'))
              ],
            );
          });
    }
  }

  MeetingDataSource getCalendarDataSource() {
    List<Meeting> appointments = <Meeting>[];
    final DateTime exceptionDate = DateTime(2021, 07, 20);

    final Meeting normalAppointment = Meeting(
      from: DateTime(2021, 07, 10, 10),
      to: DateTime(2021, 07, 10, 12),
      eventName: 'Planning',
      id: '01',
      background: Colors.pink,
    );

    appointments.add(normalAppointment);
    final Meeting recurrenceApp = Meeting(
      from: DateTime(2021, 07, 11, 10),
      to: DateTime(2021, 07, 11, 12),
      eventName: 'Planning',
      id: '02',
      background: Colors.green,
      recurrenceRule: 'FREQ=DAILY;COUNT=20',
      exceptionDates: <DateTime>[exceptionDate],
    );

    appointments.add(recurrenceApp);

    final Meeting exceptionAppointment = Meeting(
        from: exceptionDate.add(const Duration(hours: 14)),
        to: exceptionDate.add(const Duration(hours: 15)),
        eventName: 'Changed occurence',
        id: '03',
        background: Colors.pinkAccent,
        recurrenceId: recurrenceApp.id);

    appointments.add(exceptionAppointment);

    appointments.add(Meeting(
      from: DateTime.now().add(const Duration(hours: 4, days: -1)),
      to: DateTime.now().add(const Duration(hours: 5, days: -1)),
      eventName: 'Release Meeting',
      id: '04',
      background: Colors.lightBlueAccent,
    ));

    return MeetingDataSource(appointments);
  }
}

class Meeting {
  Meeting(
      {required this.from,
        required this.to,
        this.id,
        this.recurrenceId,
        this.eventName = '',
        this.isAllDay = false,
        this.background,
        this.exceptionDates,
        this.recurrenceRule});

  DateTime from;
  DateTime to;
  Object? id;
  Object? recurrenceId;
  String eventName;
  bool isAllDay;
  Color? background;
  String? fromZone;
  String? toZone;
  String? recurrenceRule;
  List<DateTime>? exceptionDates;
}

class MeetingDataSource extends CalendarDataSource<Meeting> {
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
  Object? getId(int index) {
    return appointments![index].id;
  }

  @override
  Object? getRecurrenceId(int index) {
    return appointments![index].recurrenceId as Object?;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background as Color;
  }

  @override
  List<DateTime>? getRecurrenceExceptionDates(int index) {
    return appointments![index].exceptionDates as List<DateTime>?;
  }

  @override
  String? getRecurrenceRule(int index) {
    return appointments![index].recurrenceRule;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName as String;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay as bool;
  }

  @override
  Meeting? convertAppointmentToObject(
      Meeting? customData, Appointment appointment) {
    // TODO: implement convertAppointmentToObject
    return Meeting(
        from: appointment.startTime,
        to: appointment.endTime,
        eventName: appointment.subject,
        background: appointment.color,
        isAllDay: appointment.isAllDay,
        id: appointment.id,
        recurrenceRule: appointment.recurrenceRule,
        recurrenceId: appointment.recurrenceId,
        exceptionDates: appointment.recurrenceExceptionDates);
  }
}