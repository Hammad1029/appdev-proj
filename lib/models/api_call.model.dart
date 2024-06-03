import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project_app/providers/user_provider.dart';

class ApiCall {
  Request request;
  ApiResponse response;

  ApiCall({
    required this.request,
    ApiResponse? response,
  }) : response = response ?? ApiResponse();

  Future<dynamic> call() async {
    try {
      final user = request.ref?.read(userProviderProvider);

      if (request.authorized) {
        request.headers = {
          ...request.headers,
          "Authorization": "Bearer ${user?.token}"
        };
      }

      http.Response res;
      if (request.reqBody.isEmpty) {
        res = await http.get(
          request.getUrl(),
          headers: request.headers,
        );
      } else {
        res = await http.post(
          request.getUrl(),
          headers: request.headers,
          body: jsonEncode(request.reqBody),
        );
      }

      response = ApiResponse.fromHttpResponse(res);

      switch (response.responseCode) {
        case '00':
          if (request.successNotif) {
            Fluttertoast.showToast(
                msg: response.responseDescription,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green);
          }
          return response.data;
        case '400':
          Fluttertoast.showToast(
              msg: response.data.values.join("\n"),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.orange);
          break;
        case '401':
          Fluttertoast.showToast(
              msg: "Please login again",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.orange);
          user?.logout();
          break;
        default:
          if (request.notif) {
            Fluttertoast.showToast(
                msg: response.responseDescription,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red);
          }
          break;
      }
    } catch (e) {
      print("ERROR $e");
      Fluttertoast.showToast(
          msg: "Please contact system administrators",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red);
    } finally {
      // Provider.of<AppState>(context, listen: false).setLoading(false);
    }
    return {"success": false};
  }
}

class Request<T extends WidgetRef> {
  String baseURL;
  String base;
  String endpoint;
  Map<String, dynamic> reqBody;
  bool notif;
  bool successNotif;
  String description;
  String token;
  bool authorized;
  Map<String, String> headers;
  T? ref;

  Request(
      {required this.base,
      required this.endpoint,
      this.baseURL = 'http://192.168.100.184:5500',
      this.reqBody = const {},
      this.headers = const {'Content-Type': 'application/json'},
      this.notif = true,
      this.successNotif = false,
      this.description = "",
      this.token = "",
      this.authorized = true,
      this.ref});

  Uri getUrl() {
    return Uri.parse("$baseURL/$base/$endpoint");
  }
}

class ApiResponse {
  dynamic data;
  String responseCode;
  String responseDescription;

  ApiResponse({
    this.data = const {},
    this.responseCode = "",
    this.responseDescription = "",
  });

  factory ApiResponse.fromHttpResponse(http.Response httpResponse) {
    Map<String, dynamic> decodedData = jsonDecode(httpResponse.body);

    return ApiResponse(
      data: decodedData["data"],
      responseCode: decodedData["responseCode"],
      responseDescription: decodedData["responseDescription"],
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data,
        'responseCode': responseCode,
        'responseDescription': responseDescription,
      };
}
