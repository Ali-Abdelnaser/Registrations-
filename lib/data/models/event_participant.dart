import 'package:equatable/equatable.dart';

class EventParticipant extends Equatable {
  final String id;
  final String name;
  final String email;
  final bool attendance;
  final DateTime? scannedAt;

  const EventParticipant({
    required this.id,
    required this.name,
    required this.email,
    this.attendance = false,
    this.scannedAt,
  });

  factory EventParticipant.fromMap(Map<String, dynamic> map) {
    return EventParticipant(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] ?? '',
      attendance: map['attendance'] ?? false,
      scannedAt: map['scannedAt'] != null
          ? DateTime.tryParse(map['scannedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'attendance': attendance,
      'scannedAt': scannedAt?.toIso8601String(),
    };
  }

  EventParticipant copyWith({
    String? id,
    String? name,
    String? email,
    bool? attendance,
    DateTime? scannedAt,
  }) {
    return EventParticipant(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      attendance: attendance ?? this.attendance,
      scannedAt: scannedAt ?? this.scannedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, email, attendance, scannedAt];
}
