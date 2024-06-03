import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_app/models/api_call.model.dart';
import 'package:project_app/providers/user_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  var method = "Login";
  Map<String, String> formData = {"role": "Professor"};
  List<String> roles = ["Professor", "Student"];

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      print('exception->$e');
    }
  }

  Future<void> onSubmit() async {
    String endpoint = "login";
    if (method == "Signup") {
      endpoint = "signup";
    } else if (method == "Forgot Password") {
      endpoint = "forgetPassword";
    }
    ApiCall loginCall = ApiCall(
        request: Request(
            base: "auth",
            endpoint: endpoint,
            authorized: false,
            ref: ref,
            reqBody: formData,
            successNotif: true));
    Map<String, dynamic> res = await loginCall.call();
    if (res["success"] != false) {
      if (endpoint == "login") {
        ref.read(userProviderProvider.notifier).login(res);
      }
      changeMethod("Login");
    }
  }

  void changeMethod(String m) {
    setState(() {
      method = m;
      formData = {"role": "Professor"};
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> signUpRoles = {
      "Professor": Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              onSaved: (newValue) =>
                  formData["department"] = newValue.toString(),
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
              initialValue: formData["coursesAssigned"],
              decoration: const InputDecoration(
                hintText: 'Courses Assigned',
                labelText: 'Courses Assigned',
                errorStyle: TextStyle(fontSize: 18.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(9.0)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your assigned courses';
                }
                return null;
              },
            ),
          ),
        ],
      ),
      "Student": Column(
        children: [
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
              initialValue: formData["batch"],
              decoration: const InputDecoration(
                hintText: 'Batch',
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
        ],
      )
    };

    final Map<String, Widget> formFields = {
      "Login": Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              onSaved: (newValue) => formData["password"] = newValue.toString(),
              decoration: const InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                prefixIcon: Icon(Icons.key, color: Colors.green),
                errorStyle: TextStyle(fontSize: 18.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(9.0)),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    changeMethod("Signup");
                  },
                  child: const Text("Don't have an account? sign up"))
            ],
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    changeMethod("Forgot Password");
                  },
                  child: const Text("Forgot password?"))
            ],
          ),
        ],
      ),
      "Signup": Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              onSaved: (newValue) => formData["password"] = newValue.toString(),
              decoration: const InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                prefixIcon: Icon(Icons.key, color: Colors.green),
                errorStyle: TextStyle(fontSize: 18.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(9.0)),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ),
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
              onSaved: (newValue) => formData["lastName"] = newValue.toString(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Role",
                style: TextStyle(fontSize: 15),
              ),
              ...List.generate(roles.length, (index) {
                return Row(
                  children: <Widget>[
                    Radio(
                      value: roles[index],
                      groupValue: formData["role"],
                      onChanged: (value) {
                        setState(() {
                          formData["role"] = value.toString();
                        });
                      },
                    ),
                    Text(roles[index]),
                  ],
                );
              })
            ],
          ),
          signUpRoles[formData["role"]]!
        ],
      ),
      "Forgot Password": const Column(
        children: [],
      )
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(method),
        centerTitle: true,
        leading: method == "Login"
            ? const Column(
                children: [],
              )
            : IconButton(
                onPressed: () {
                  changeMethod("Login");
                },
                icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF673AB7)),
                  ),
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          onSaved: (newValue) =>
                              formData["email"] = newValue.toString(),
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            errorStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(9.0)),
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
                      formFields[method]!,
                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    _formkey.currentState?.save();
                                    onSubmit();
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            const Color(0xFF673AB7))),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22),
                                ),
                              ),
                              if(method=="Login")Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Or Sign In With',
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                    IconButton(
                                        onPressed: signInWithGoogle,
                                        icon: Image.network(
                                          "https://static.vecteezy.com/system/resources/previews/013/948/549/original/google-logo-on-transparent-white-background-free-vector.jpg",
                                          height: 60,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
