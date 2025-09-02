class Attendee {
  final String id;
  final String name;
  final String team;
  final String email;
  final bool attended;
  final DateTime? scanTime;

  Attendee({
    required this.id,
    required this.name,
    required this.email,
    required this.team,
    this.attended = false,
    this.scanTime,
  });

  factory Attendee.fromMap(Map<String, dynamic> map) {
    return Attendee(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      team: map['team'],
      attended: map['attended'] ?? false,
      scanTime: map['scan_time'] != null
          ? DateTime.parse(map['scan_time'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'team': team,
      'attended': attended,
      'scan_time': scanTime?.toIso8601String(),
    };
  }
}
