import 'package:registration/data/models/attendee.dart';

abstract class QrScanState {}

class QrInitial extends QrScanState {}
class QrLoading extends QrScanState {}

// لما نلاقي الشخص (لسه ماعملش Confirm)
class QrFound extends QrScanState {
  final Attendee attendee;
  QrFound(this.attendee);

  // ✅ علشان الـ UI اللي بينادي state.member يشتغل
  Attendee get member => attendee;
}

// لو الشخص مسجّل حضور قبل كده
class QrAlreadyScanned extends QrScanState {
  final Attendee attendee;
  QrAlreadyScanned(this.attendee);

  // ✅ alias
  Attendee get member => attendee;
}

// لما الحضور يتأكد بنجاح
class QrConfirmSuccess extends QrScanState {
  final Attendee attendee;
  QrConfirmSuccess(this.attendee);

  // ✅ alias
  Attendee get member => attendee;
}

// أي Error
class QrError extends QrScanState {
  final String message;
  QrError(this.message);
}
