import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_app/models/api_call.model.dart';
import 'package:project_app/models/user.model.dart';
import 'package:project_app/models/user_details.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class UserProvider extends _$UserProvider {
  @override
  UserModel build() {
    return UserModel(userDetails: null, token: "", loggedIn: false);
  }

  Future<void> login(Map<String, dynamic> res) async {
    state.login(res);
    ref.notifyListeners();
  }

  void logout() {
    state.logout();
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.signOut();
    }
    ref.notifyListeners();
  }

  void setDetails(Map<String, dynamic> res) async {
    state.userDetails = UserDetails.fromJson(res);
    ref.notifyListeners();
  }
}
