import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_app/models/calendar_meeting.dart';
import 'package:project_app/models/user_details.model.dart';

class AppointmentModel {
  String? sId;
  UserDetails? appointer;
  UserDetails? appointee;
  String? fromDate;
  String? toDate;
  String? description;
  int confirmed = 0;
  bool completed = false;
  bool cancelled = false;

  AppointmentModel(
      {this.sId,
      this.appointer,
      this.appointee,
      this.fromDate,
      this.toDate,
      this.description,
      required this.confirmed,
      required this.completed,
      required this.cancelled});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    appointer = json['appointer'] != null
        ? UserDetails.fromJson(json['appointer'])
        : null;
    appointee = json['appointee'] != null
        ? UserDetails.fromJson(json['appointee'])
        : null;
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    description = json['description'];
    confirmed = json['confirmed'];
    completed = json['completed'];
    cancelled = json['cancelled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (appointer != null) {
      data['appointer'] = appointer!.toJson();
    }
    if (appointee != null) {
      data['appointee'] = appointee!.toJson();
    }
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['description'] = description;
    data['confirmed'] = confirmed;
    data['completed'] = completed;
    data['cancelled'] = cancelled;
    return data;
  }

  @override
  String toString() {
    return description.toString();
  }

  Meeting getCalendarMeeting() {
    final dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    Color eventColor = Colors.orange;
    if (completed) {
      eventColor = Colors.green;
    } else if (confirmed == 1 || cancelled) {
      eventColor = Colors.red;
    }

    return Meeting(
        description.toString(),
        dateFormat.parse(
          fromDate.toString(),
        ),
        dateFormat.parse(toDate.toString()),
        eventColor,
        false,
        this);
  }
}
