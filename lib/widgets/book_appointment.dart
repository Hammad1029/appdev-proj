import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:project_app/models/api_call.model.dart';
import 'package:project_app/models/office_hours.model.dart';
import 'package:project_app/models/user_details.model.dart';
import 'package:project_app/providers/appointments_provider.dart';

class BookAppointment extends ConsumerStatefulWidget {
  const BookAppointment(
      {super.key, required this.user, required this.sheetContext});
  final UserDetails user;
  final BuildContext sheetContext;

  @override
  AppointmentState createState() => AppointmentState();
}

class AppointmentState extends ConsumerState<BookAppointment> {
  final _formkey = GlobalKey<FormState>();
  Map<String, String> formData = {};
  OfficeHours? selected;

  void book() async {
    if (selected == null) {
      Fluttertoast.showToast(
          msg: "Please fill details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.yellowAccent,
          textColor: Colors.black);
      return;
    }

    final Map<String, dynamic> reqBody = {
      'appointee': widget.user.sId,
      'description': formData['description'],
      'day': selected?.day,
      'slot': selected?.slot,
    };

    ApiCall createCall = ApiCall(
        request: Request(
            base: "appointments",
            endpoint: "create",
            ref: ref,
            reqBody: reqBody,
            successNotif: true));
    Map<String, dynamic> res = await createCall.call();
    if (res["success"] != false) {
      await ref.read(appointmentsProvider.notifier).getAppointments(ref);
      Navigator.of(widget.sheetContext).pop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool noOfficeHours = widget.user.officeHours?.isEmpty ?? true;
    return AlertDialog(
        title: const Text("Book Appointment"),
        content: Container(
            height: 200,
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    readOnly: noOfficeHours,
                    onSaved: (newValue) =>
                        formData["description"] = newValue.toString(),
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      labelText: 'Description',
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: noOfficeHours
                        ? const Text("No office hours avalable")
                        : DropdownButton<OfficeHours>(
                            value: selected,
                            onChanged: (OfficeHours? value) {
                              setState(() {
                                selected = value!;
                              });
                            },
                            items: widget.user.officeHours
                                ?.map<DropdownMenuItem<OfficeHours>>(
                                    (OfficeHours value) {
                              return DropdownMenuItem<OfficeHours>(
                                value: value,
                                child: Text("${value.day} - ${value.slot}"),
                              );
                            }).toList(),
                          ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              noOfficeHours ? Colors.grey : Colors.purple)),
                      child: const Text(
                        'Book',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      onPressed: () {
                        if (noOfficeHours) {
                          return;
                        }
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState?.save();
                          book();
                        }
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}
