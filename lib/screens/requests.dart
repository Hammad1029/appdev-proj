import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_app/models/appointment.dart';
import 'package:project_app/widgets/appointment_request.dart';

class RequestsScreen extends StatelessWidget {
  RequestsScreen(
      {super.key, required this.appointments, required this.refresh});
  List<AppointmentModel> appointments;
  AsyncCallback refresh;

  @override
  Widget build(BuildContext context) {
    final filteredAppointments =
        appointments.where((e) => e.confirmed == 0).toList();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child:
                Text("Requests", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SingleChildScrollView(
            child: Container(
              height: 300,
              child: filteredAppointments.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredAppointments.length,
                      itemBuilder: (context, index) {
                        return AppointmentRequest(
                            appointment: filteredAppointments[index],
                            refresh: refresh);
                      },
                    )
                  : const Text("No requests found"),
            ),
          ),
        ],
      ),
    );
  }
}
