import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_app/models/api_call.model.dart';
import 'package:project_app/models/appointment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appointments_provider.g.dart';

@riverpod
class Appointments extends _$Appointments {
  @override
  List<AppointmentModel> build() {
    return [];
  }

  Future<void> getAppointments(WidgetRef wRef) async {
    ApiCall appointmentsCall = ApiCall(
        request: Request(base: "appointments", endpoint: "getAll", ref: wRef));
    List<dynamic> res = await appointmentsCall.call();
    List<AppointmentModel> appointments =
        res.map((e) => AppointmentModel.fromJson(e)).toList();
    state = appointments;
    ref.notifyListeners();
  }
}
