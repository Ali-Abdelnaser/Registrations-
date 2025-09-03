class Attendee {
  final String id;
  final String name;
  final String team;
  final String email;
  final bool attendance;
  final DateTime? scanTime;

  Attendee({
    required this.id,
    required this.name,
    required this.email,
    required this.team,
    this.attendance = false,
    this.scanTime,
  });

  factory Attendee.fromMap(Map<String, dynamic> map) {
    return Attendee(
      id: map['id'],
      name: map['Name'],
      email: map['email'],
      team: map['Team'],
      attendance: map['attendance'] ?? false,
      scanTime: map['scan_time'] != null
          ? DateTime.parse(map['scan_time'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Name': name,
      'Team': team,
      'attendance': attendance,
      'scan_time': scanTime?.toIso8601String(),
    };
  }
}
