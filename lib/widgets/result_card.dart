import 'package:flutter/material.dart';
import 'package:project_app/models/user_details.model.dart';
import 'package:project_app/widgets/book_appointment.dart';

class ResultCard extends StatelessWidget {
  UserDetails result;
  BuildContext sheetContext;
  ResultCard({super.key, required this.result, required this.sheetContext});

  @override
  Widget build(BuildContext context) {
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
                    child: Text(result.getFullName()),
                  )
                ],
              ),
              Text("Department: ${result.department.toString()}"),
              Text("Courses: ${result.coursesAssigned?.join(", ") ?? ""}"),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => BookAppointment(
                    user: result,
                    sheetContext: sheetContext,
                  ),
                );
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Colors.indigo,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Book \nappointment",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ],
      ),
    ));
  }
}
