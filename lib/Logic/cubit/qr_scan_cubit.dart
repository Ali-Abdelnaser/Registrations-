import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/data/repositories/attendee_repository.dart';
import 'package:registration/data/models/attendee.dart';
import 'qr_scan_state.dart';

class QrScanCubit extends Cubit<QrScanState> {
  final AuthRepository repository;

  QrScanCubit(this.repository) : super(QrInitial());

  /// ✅ افحص الـ QR: موجود؟ متسجّل قبل؟ لسه؟
  Future<void> scanQr(String memberId) async {
    emit(QrLoading());
    try {
      final Attendee? attendee = await repository.getMemberById(memberId);

      if (attendee == null) {
        emit(QrError('Invalid QR: member not found'));
        return;
      }

      if (attendee.attended == true) {
        emit(QrAlreadyScanned(attendee));
      } else {
        emit(QrFound(attendee));
      }
    } catch (e) {
      emit(QrError(e.toString()));
    }
  }

  /// ✅ تأكيد الحضور وتسجيل وقت المسح
  Future<void> confirmAttendance(String memberId) async {
    emit(QrLoading());
    try {
      // نجيب العضو الأول
      final attendee = await repository.getMemberById(memberId);

      if (attendee == null) {
        emit(QrError('Member not found while confirming'));
        return;
      }

      // نعمل Update في Supabase
      await repository.updateBranchMember(memberId, {
        'attended': true, // ✅ تأكد إن اسم العمود زي ما في الجدول
        'scannedAt': DateTime.now().toUtc().toIso8601String(),
      });

      // نرجع نسخة جديدة بالـ attended = true
      final updated = await repository.getMemberById(memberId);
      if (updated == null) {
        emit(QrError('Member not found after update'));
        return;
      }

      emit(QrConfirmSuccess(updated));
    } catch (e) {
      emit(QrError(e.toString()));
    }
  }
}
