import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_app/models/calendar_meeting.dart';
import 'package:project_app/models/appointment.dart';
import 'package:project_app/widgets/appointment_details.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatelessWidget {
  List<AppointmentModel> appointments;

  CalendarScreen({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.schedule,
      dataSource: MeetingDataSource(_getDataSource()),
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      onTap: (details) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AppointmentDetails(details);
            });
      },
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    for (var e in appointments) {
      meetings.add(e.getCalendarMeeting());
    }
    return meetings;
  }
}
