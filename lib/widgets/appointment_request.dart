import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_app/models/api_call.model.dart';
import 'package:project_app/models/appointment.dart';

class AppointmentRequest extends ConsumerWidget {
  AppointmentRequest(
      {super.key, required this.appointment, required this.refresh});
  AppointmentModel appointment;
  final AsyncCallback refresh;

  void handleRequest(bool decision, WidgetRef ref) async {
    ApiCall appointmentsCall = ApiCall(
        request: Request(
            base: "appointments",
            endpoint: "update",
            ref: ref,
            successNotif: true,
            reqBody: {"confirmed": decision, "id": appointment.sId}));
    await appointmentsCall.call();
    await refresh();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(appointment.appointer?.getFullName() ?? ""),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Description: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(appointment.description ?? "")
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Date/Time: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "${appointment.fromDate?.split(".")[0].replaceAll("T", " ")} - ${appointment.toDate?.split("T")[1]}")
                ],
              ),
            ],
          ),
          Column(
            children: [
              ElevatedButton(
                  onPressed: () => handleRequest(true, ref),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.green,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      "Accept",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              ElevatedButton(
                  onPressed: () => handleRequest(false, ref),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.red,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      "Reject",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
            ],
          )
        ],
      ),
    ));
  }
}
