import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/data/models/event_participant.dart';
import 'package:registration/data/repositories/event_repository.dart';
import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final EventRepository repository;

  EventCubit(this.repository) : super(EventInitial());

  /// لما نبدأ الاسكان
  Future<void> scanParticipant(String scannedId) async {
    try {
      emit(EventScanning());

      final participant = await repository.getParticipantById(scannedId);

      if (participant == null) {
        emit(EventParticipantNotFound(scannedId));
        return;
      }

      if (participant.attendance) {
        emit(EventAlreadyCheckedIn(participant));
      } else {
        emit(EventParticipantFound(participant));
      }
    } catch (e) {
      emit(EventError("Scan Error: $e"));
    }
  }

  /// لما يعمل confirm
  Future<void> confirmAttendance(EventParticipant participant) async {
    try {
      await repository.markAttendance(participant.id);

      final updated = participant.copyWith(
        attendance: true,
        scannedAt: DateTime.now(),
      );

      emit(EventCheckInSuccess(updated));
    } catch (e) {
      emit(EventError("Confirm Attendance Error: $e"));
    }
  }

  /// reset state (لو رجعت للشاشة الرئيسية)
  void reset() {
    emit(EventInitial());
  }
}
