import 'package:flutter/material.dart';
import 'package:project_app/models/office_hours.model.dart';

class OfficeHoursForm extends StatefulWidget {
  const OfficeHoursForm(
      {super.key,
      required this.officeHoursList,
      required this.setOfficeHoursList});

  @override
  _OfficeHoursFormState createState() => _OfficeHoursFormState();
  final List<OfficeHours> officeHoursList;
  final Function(OfficeHours, bool) setOfficeHoursList;
}

class _OfficeHoursFormState extends State<OfficeHoursForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDay;
  String? _selectedSlot;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.indigo),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Text(
                      "Office Hours",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      // Day dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedDay,
                          items: <String>[
                            'Monday',
                            'Tuesday',
                            'Wednesday',
                            'Thursday',
                            'Friday',
                            'Saturday'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedDay = newValue;
                            });
                          },
                        ),
                      ),
                      // Slot dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedSlot,
                          items: <String>[
                            "8:30 - 9:45",
                            "10:00 - 11:15",
                            "11:30 - 12:45",
                            "13:00 - 14:15",
                            "14:30 - 15:45",
                            "16:00 - 17:15"
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedSlot = newValue;
                            });
                          },
                        ),
                      ),
                      // Submit button
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Check if duplicate OfficeHours instance already exists
                            if (!widget.officeHoursList.any(
                                (OfficeHours officeHours) =>
                                    officeHours.day == _selectedDay &&
                                    officeHours.slot == _selectedSlot)) {
                              widget.setOfficeHoursList(
                                  OfficeHours(
                                      day: _selectedDay, slot: _selectedSlot),
                                  true);
                            }
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (OfficeHours officeHours in widget.officeHoursList)
                        Row(
                          children: [
                            Text('${officeHours.day} - ${officeHours.slot}'),
                            IconButton(
                                onPressed: () {
                                  widget.setOfficeHoursList(officeHours, false);
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
