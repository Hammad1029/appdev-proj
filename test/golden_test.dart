import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:project_app/screens/login.dart';

void main() {
  group('GoldenTests', () {
    testGoldens(
      'My home page',
      (tester) async {
        final builder = DeviceBuilder()
          ..addScenario(
            widget: const LoginScreen(),
          );

        await tester.pumpDeviceBuilder(builder);

        await screenMatchesGolden(tester, 'my_home_page');
      },
    );
  });
}
