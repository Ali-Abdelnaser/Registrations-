import 'package:equatable/equatable.dart';
import 'package:registration/data/models/event_participant.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

/// ✅ الحالة الافتراضية
class EventInitial extends EventState {}

/// ✅ حالة الاسكان
class EventScanning extends EventState {}

/// ✅ الشخص اتجاب من الداتا
class EventParticipantFound extends EventState {
  final EventParticipant participant;

  const EventParticipantFound(this.participant);

  @override
  List<Object?> get props => [participant];
}

/// ✅ الشخص مش موجود في الداتا
class EventParticipantNotFound extends EventState {
  final String scannedId;

  const EventParticipantNotFound(this.scannedId);

  @override
  List<Object?> get props => [scannedId];
}

/// ✅ الشخص متعلم حضور قبل كدا
class EventAlreadyCheckedIn extends EventState {
  final EventParticipant participant;

  const EventAlreadyCheckedIn(this.participant);

  @override
  List<Object?> get props => [participant];
}

/// ✅ الحضور اتسجل بنجاح
class EventCheckInSuccess extends EventState {
  final EventParticipant participant;

  const EventCheckInSuccess(this.participant);

  @override
  List<Object?> get props => [participant];
}

/// ✅ لو حصل error
class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object?> get props => [message];
}

//
// -------------------------
// 🔽 Data Management States
// -------------------------
//

/// ✅ تحميل كل المشاركين
class EventParticipantsLoading extends EventState {}

class EventParticipantsLoaded extends EventState {
  final List<EventParticipant> participants;

  const EventParticipantsLoaded(this.participants);

  @override
  List<Object?> get props => [participants];

  List<EventParticipant> get attended =>
      participants.where((p) => p.attendance == true).toList();

  List<EventParticipant> get all => participants;
}


/// ✅ في حالة رفع ملف اكسل (Import)
class EventImporting extends EventState {}

/// ✅ ريبورت بعد الاستيراد
class EventImportedReport extends EventState {
  final int inserted;
  final int updated;
  final int skipped;
  final int failed;
  final int total;

  const EventImportedReport({
    required this.inserted,
    required this.updated,
    required this.skipped,
    required this.failed,
    required this.total,
  });

  @override
  List<Object?> get props => [inserted, updated, skipped, failed, total];
}

/// ✅ في حالة تصدير ملف اكسل (Export)
class EventExporting extends EventState {}

class EventExportSuccess extends EventState {
  final String filePath;

  const EventExportSuccess(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

/// ✅ في حالة رفع باتش (bulk insert / upsert)
class EventBatchUploading extends EventState {
  final int uploaded;
  final int total;

  const EventBatchUploading(this.uploaded, this.total);

  @override
  List<Object?> get props => [uploaded, total];
}
class ImportPreparing extends EventState {}

class EventBatchUploadSuccess extends EventState {}
/// ✅ حالة تقدم الاستيراد (progress)
class ImportProgress extends EventState {
  final int current;
  final int total;
  final double progress;

  const ImportProgress({
    required this.current,
    required this.total,
  }) : progress = total > 0 ? current / total : 0;

  @override
  List<Object?> get props => [current, total, progress];
}
