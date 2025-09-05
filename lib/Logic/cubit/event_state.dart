import 'package:equatable/equatable.dart';
import 'package:registration/data/models/event_participant.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventScanning extends EventState {}

/// الشخص اتجاب من الداتا
class EventParticipantFound extends EventState {
  final EventParticipant participant;

  const EventParticipantFound(this.participant);

  @override
  List<Object?> get props => [participant];
}

/// الشخص مش موجود في الداتا
class EventParticipantNotFound extends EventState {
  final String scannedId;

  const EventParticipantNotFound(this.scannedId);

  @override
  List<Object?> get props => [scannedId];
}

/// الشخص متعلم حضور قبل كدا
class EventAlreadyCheckedIn extends EventState {
  final EventParticipant participant;

  const EventAlreadyCheckedIn(this.participant);

  @override
  List<Object?> get props => [participant];
}

/// الحضور اتسجل بنجاح
class EventCheckInSuccess extends EventState {
  final EventParticipant participant;

  const EventCheckInSuccess(this.participant);

  @override
  List<Object?> get props => [participant];
}

/// لو حصل error
class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object?> get props => [message];
}
