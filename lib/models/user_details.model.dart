import 'package:project_app/models/office_hours.model.dart';

class UserDetails {
  String? sId;
  String? email;
  String? firstName;
  String? lastName;
  String? role;
  String? program;
  String? batch;
  List<String>? coursesAssigned;
  List<OfficeHours>? officeHours;
  String? createdAt;
  String? department;

  UserDetails(
      {required this.sId,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.role,
      required this.program,
      required this.batch,
      required this.coursesAssigned,
      required this.officeHours,
      required this.createdAt,
      required this.department});

  UserDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    role = json['role'];
    program = json['program'];
    batch = json['batch'];
    coursesAssigned = List<String>.from(json['coursesAssigned'].map((e) => e as String));
    if (json['officeHours'] != null) {
      officeHours = <OfficeHours>[];
      json['officeHours'].forEach((v) {
        officeHours?.add(OfficeHours.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['role'] = role;
    data['program'] = program;
    data['batch'] = batch;
    data['coursesAssigned'] = coursesAssigned!.join(",");
    data['officeHours'] = officeHours?.map((v) => v.toJson()).toList();
    data['createdAt'] = createdAt;
    data['department'] = department;
    return data;
  }

  String getFullName() {
    return "$firstName $lastName";
  }
}
