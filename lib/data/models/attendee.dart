class Attendee {
  final String id;
  final String name;
  final String team;
  final String email;
  final bool attendance;
  final DateTime? scannedAt;

  Attendee({
    required this.id,
    required this.name,
    required this.email,
    required this.team,
    this.attendance = false,
    this.scannedAt,
  });

  factory Attendee.fromMap(Map<String, dynamic> map) {
    return Attendee(
      id: map['id'],
      name: map['Name'],
      email: map['email'],
      team: map['Team'],
      attendance: map['attendance'] ?? false,
      scannedAt: map['scannedAt'] != null
          ? DateTime.parse(map['scannedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Name': name,
      'Team': team,
      'email': email,
      'attendance': attendance,
      'scannedAt': scannedAt?.toIso8601String(),
    };
  }
}
