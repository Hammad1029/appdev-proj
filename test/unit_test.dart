import 'package:flutter_test/flutter_test.dart';
import 'package:project_app/models/api_call.model.dart';
import 'package:project_app/models/user.model.dart';
import 'package:project_app/providers/user_provider.dart';

class MockApiCall extends ApiCall {
  final ApiResponse responseData;

  MockApiCall({
    required Request request,
    required this.responseData,
  }) : super(request: request);

  @override
  Future<ApiResponse> call() async {
    return responseData;
  }
}

void main() {
  group('UnitTests', () {
    test('login', () async {
      // Arrange
      final userProvider = UserProvider().build();
      final request = Request(
        base: "auth",
        endpoint: "login",
        authorized: false,
        reqBody: {"email": "hammad1029@gmail.com", "password": "hello321"},
        successNotif: true,
      );
      final apiResponse = ApiResponse(
        data: {
          "userDetails": {
            "email": "hammad1029@gmail.com",
            "firstName": "Hammad",
            "lastName": "Ul Haq",
            "coursesAssigned": [],
            "officeHours": []
          },
          "token": "abcdefghijklmnopqrstuvwxyz123456",
        },
        responseCode: "00",
        responseDescription: "Login successful",
      );
      final apiCall = MockApiCall(request: request, responseData: apiResponse);
      final res = await apiCall.call();
      await userProvider.login(res.data);

      // Assert
      expect(userProvider.loggedIn, true);
      expect(userProvider.token, "abcdefghijklmnopqrstuvwxyz123456");
      expect(userProvider.userDetails?.email, "hammad1029@gmail.com");
      expect(userProvider.userDetails?.firstName, "Hammad");
      expect(userProvider.userDetails?.lastName, "Ul Haq");
      // Include other assertions for user details
    });
  });
}
