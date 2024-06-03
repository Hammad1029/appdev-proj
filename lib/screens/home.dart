import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_app/models/api_call.model.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/screens/profile.dart';
import 'package:project_app/screens/requests.dart';
import 'package:project_app/screens/calendar.dart';
import 'package:project_app/widgets/search.dart';
import 'package:project_app/providers/appointments_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIdx = 0;

  @override
  void initState() {
    super.initState();
    ref.read(userProviderProvider);
    refresh();
  }

  Future<void> refresh() async {
    await ref.read(appointmentsProvider.notifier).getAppointments(ref);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProviderProvider);
    final appointments = ref.watch(appointmentsProvider);

    final List<BottomNavigationBarItem> bottomNavItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Profile',
      ),
    ];

    final Map<String, Widget> screens = {
      "Home": RefreshIndicator(
          onRefresh: refresh,
          color: Colors.white,
          backgroundColor: Colors.blue,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Search(),
                ),
                CalendarScreen(
                  appointments: appointments,
                ),
                if (user.userDetails?.role == "Professor")
                  RequestsScreen(
                    appointments: appointments,
                    refresh: refresh,
                  ),
              ],
            ),
          )),
      "Profile": const ProfileScreen()
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(bottomNavItems[selectedIdx].label.toString()),
        centerTitle: false,
        actions: [
          ElevatedButton.icon(
            icon: const Icon(
              Icons.logout,
              color: Colors.purple,
              size: 30.0,
            ),
            label: const Text("Logout"),
            onPressed: () {
              ref.read(userProviderProvider.notifier).logout();
            },
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: screens[bottomNavItems[selectedIdx].label.toString()]),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        selectedItemColor: Colors.amber[800],
        currentIndex: selectedIdx,
        onTap: (idx) {
          setState(() {
            selectedIdx = idx;
          });
        },
      ),
    );
  }
}
