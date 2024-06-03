class OfficeHours {
  String? day;
  String? slot;

  OfficeHours({required this.day, required this.slot});

  OfficeHours.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    slot = json['slot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['slot'] = slot;
    return data;
  }
}
