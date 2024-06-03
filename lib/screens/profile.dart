import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_app/models/api_call.model.dart';
import 'package:project_app/models/office_hours.model.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/widgets/add_office_hours.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<ProfileScreen> {
  final _profileKey = GlobalKey<FormState>();
  final _forgetKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};
  List<OfficeHours> officeHoursList = [];

  void setOfficeHoursList(OfficeHours oh, bool add) {
    setState(() {
      if (add) {
        officeHoursList.add(oh);
      } else {
        officeHoursList.remove(oh);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      final userDetails = ref.read(userProviderProvider).userDetails;
      formData = userDetails!.toJson();
      formData["coursesAssigned"] = userDetails.coursesAssigned!.join(",");
      officeHoursList = userDetails.officeHours!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProviderProvider).userDetails;

    final roleFields = {
      "Professor": [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            onSaved: (newValue) => formData["department"] = newValue.toString(),
            initialValue: formData["department"],
            decoration: const InputDecoration(
              hintText: 'Department',
              labelText: 'Department',
              errorStyle: TextStyle(fontSize: 18.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(9.0)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your department';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            onSaved: (newValue) =>
                formData["coursesAssigned"] = newValue.toString(),
            initialValue: formData["coursesAssigned"].toString(),
            decoration: const InputDecoration(
              hintText: 'Courses Assigned',
              labelText: 'Course Assigned',
              errorStyle: TextStyle(fontSize: 18.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(9.0)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your courses';
              }
              return null;
            },
          ),
        ),
        OfficeHoursForm(
          officeHoursList: officeHoursList,
          setOfficeHoursList: setOfficeHoursList,
        ),
      ],
      "Student": [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            onSaved: (newValue) => formData["program"] = newValue.toString(),
            initialValue: formData["program"],
            decoration: const InputDecoration(
              hintText: 'Program',
              labelText: 'Program',
              errorStyle: TextStyle(fontSize: 18.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(9.0)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your program';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            onSaved: (newValue) => formData["batch"] = newValue.toString(),
            initialValue: formData["batch"].toString(),
            decoration: const InputDecoration(
              hintText: 'Batch',
              labelText: 'Batch',
              errorStyle: TextStyle(fontSize: 18.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(9.0)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your batch';
              }
              return null;
            },
          ),
        ),
      ],
    };
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _profileKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    onSaved: (newValue) =>
                        formData["firstName"] = newValue.toString(),
                    initialValue: formData["firstName"],
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                      labelText: 'First Name',
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    onSaved: (newValue) =>
                        formData["lastName"] = newValue.toString(),
                    initialValue: formData["lastName"],
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                      labelText: 'Last Name',
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    onSaved: (newValue) =>
                        formData["email"] = newValue.toString(),
                    initialValue: formData["email"],
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                ),
                ...?roleFields[user?.role],
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_profileKey.currentState!.validate()) {
                          _profileKey.currentState?.save();

                          final reqBody = {
                            "firstName": formData["firstName"].toString(),
                            "lastName": formData["lastName"].toString(),
                            "email": formData["email"].toString(),
                            "department": formData["department"].toString(),
                            "coursesAssigned":
                                formData["coursesAssigned"].toString(),
                            "officeHours":
                                officeHoursList.map((e) => e.toJson()).toList(),
                            "program": formData["program"].toString(),
                            "batch": formData["batch"].toString(),
                          };
                          ApiCall updateProfile = ApiCall(
                              request: Request(
                                  base: "auth",
                                  endpoint: "updateProfile",
                                  ref: ref,
                                  reqBody: reqBody,
                                  successNotif: true));
                          Map<String, dynamic> res = await updateProfile.call();
                          if (res["success"] != false) {
                            ref.read(userProviderProvider.notifier).setDetails({
                              ...?user?.toJson(),
                              ...reqBody,
                              "coursesAssigned": reqBody["coursesAssigned"]
                                  .toString()
                                  .split(",")
                            });
                          }
                          print("hello");
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xFF673AB7))),
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 20,
            thickness: 5,
            indent: 20,
            endIndent: 0,
            color: Colors.black,
          ),
          Form(
            key: _forgetKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    onSaved: (newValue) =>
                        formData["password"] = newValue.toString(),
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'New Password',
                      labelText: 'New Password',
                      prefixIcon: Icon(Icons.key, color: Colors.green),
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    onSaved: (newValue) =>
                        formData["confirmPassword"] = newValue.toString(),
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.key, color: Colors.green),
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      ),
                    ),
                    validator: (value) {
                      _forgetKey.currentState?.save();
                      if (value == null ||
                          value.isEmpty ||
                          value != formData["password"].toString()) {
                        return 'Please enter the same password again';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_forgetKey.currentState!.validate()) {
                          _forgetKey.currentState?.save();

                          ApiCall forgetPassword = ApiCall(
                              request: Request(
                                  base: "auth",
                                  endpoint: "changePassword",
                                  ref: ref,
                                  reqBody: {
                                    "password": formData["password"].toString(),
                                    "confirmPassword":
                                        formData["confirmPassword"].toString()
                                  },
                                  description: "Please login again",
                                  successNotif: true));
                          Map<String, dynamic> res =
                              await forgetPassword.call();
                          if (res["success"] != false) {
                            Fluttertoast.showToast(
                                msg: "Please login again",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.orange);
                            ref.read(userProviderProvider.notifier).logout();
                          }
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xFF673AB7))),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
