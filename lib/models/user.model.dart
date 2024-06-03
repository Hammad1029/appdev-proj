import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_app/models/user_details.model.dart';

class UserModel {
  UserDetails? userDetails;
  String token = "";
  bool loggedIn = false;

  UserModel(
      {required this.userDetails, required this.token, required this.loggedIn});

  login(Map<String, dynamic> json) {
    userDetails = UserDetails.fromJson(json["userDetails"]);
    token = json["token"];
    loggedIn = true;
  }

  logout() {
    userDetails = null;
    token = "";
    loggedIn = false;
  }
}
