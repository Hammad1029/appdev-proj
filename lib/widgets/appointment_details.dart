import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_app/models/api_call.model.dart';
import 'package:project_app/models/calendar_meeting.dart';
import 'package:project_app/providers/appointments_provider.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentDetails extends ConsumerWidget {
  final CalendarTapDetails appointment;
  AppointmentDetails(this.appointment, {super.key});
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  Row getStatusWithIcon(String status, bool checked) {
    return Row(children: [
      Icon(checked ? Icons.check : Icons.close),
      Text(status, style: TextStyle(color: checked ? Colors.green : Colors.red))
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProviderProvider);
    final Meeting details = appointment.appointments![0];

    void updateAppointment(bool done) async {
      ApiCall updateCall = ApiCall(
          request: Request(
              base: "appointments",
              endpoint: "update",
              reqBody: {
                "id": details.appointment.sId,
                done ? "completed" : "cancelled": true
              },
              ref: ref));
      Map<String, dynamic> res = await updateCall.call();
      if (res["success"] != false) {
        await ref.read(appointmentsProvider.notifier).getAppointments(ref);
        Navigator.of(context).pop();
      }
    }

    return AlertDialog(
      title: const Text("Appointment Details"),
      content: SizedBox(
        height: 280,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Text(
                  "Description: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  details.eventName,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Date & Time:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${DateFormat("yyyy-MM-dd HH:mm").format(details.from)} - ${DateFormat("HH:mm").format(details.to)}",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: <Widget>[
                const Text(
                  "Appointer: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  details.appointment.appointer!.getFullName(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const Text(
                  "Appointee: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  details.appointment.appointee!.getFullName(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            getStatusWithIcon(
                details.appointment.confirmed == 2
                    ? "Confirmed"
                    : details.appointment.confirmed == 1
                        ? "Rejected"
                        : "Pending",
                details.appointment.confirmed == 2 ||
                    details.appointment.confirmed == 1),
            getStatusWithIcon("Completed", details.appointment.completed),
            getStatusWithIcon("Cancelled", details.appointment.cancelled),
            Row(
              children: [
                if (!details.appointment.completed &&
                    details.appointment.confirmed == 2 &&
                    user.userDetails?.role.toString() == "Professor" &&
                    !details.appointment.cancelled)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.red)),
                      onPressed: () {
                        updateAppointment(false);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                if (!details.appointment.completed &&
                    details.appointment.confirmed == 2 &&
                    user.userDetails?.role.toString() == "Professor")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.green)),
                      onPressed: () {
                        updateAppointment(true);
                      },
                      child: const Text("Mark as done",
                          style: TextStyle(color: Colors.white)),
                    ),
                  )
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.indigo)),
            child: const Text(
              'close',
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
