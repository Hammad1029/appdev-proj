import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_app/models/api_call.model.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/screens/home.dart';
import 'package:project_app/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Teachsync',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const CurrentPage());
  }
}

class CurrentPage extends ConsumerStatefulWidget {
  const CurrentPage({Key? key}) : super(key: key);

  @override
  _CurrentPageState createState() => _CurrentPageState();
}

class _CurrentPageState extends ConsumerState<CurrentPage> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user != null) {
        ApiCall loginCall = ApiCall(
            request: Request(
                base: "auth",
                endpoint: "login",
                authorized: false,
                ref: ref,
                reqBody: {"email": user.email.toString(), "google": true},
                successNotif: true));
        Map<String, dynamic> res = await loginCall.call();
        if (loginCall.response.responseCode == "10") {
          Fluttertoast.showToast(
              msg: "Please signup first",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.orange);
          FirebaseAuth.instance.signOut();
        }
        if (res["success"] != false) {
          ref.read(userProviderProvider.notifier).login(res);
        } else {
          FirebaseAuth.instance.signOut();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProviderProvider);
    return user.loggedIn ? const HomeScreen() : const LoginScreen();
  }
}
