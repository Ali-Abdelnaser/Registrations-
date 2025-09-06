import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/data/models/event_participant.dart';
import 'package:registration/data/repositories/event_repository.dart';
import 'package:registration/data/services/excel_service_event.dart';
import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final EventRepository repository;

  EventCubit(this.repository) : super(EventInitial());

  // -----------------------
  // ✅ Scan + Confirm
  // -----------------------

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

  // -----------------------
  // ✅ Data Management
  // -----------------------

  /// تحميل كل المشاركين
  Future<void> loadParticipants() async {
    try {
      emit(EventParticipantsLoading());
      final participants = await repository.getParticipants();
      emit(EventParticipantsLoaded(participants));
    } catch (e) {
      emit(EventError("Load Participants Error: $e"));
    }
  }

  /// رفع باتش (bulk insert/upsert)
  // Future<void> uploadBatch(
  //   List<EventParticipant> participants, {
  //   int chunkSize = 300,
  // }) async {
  //   try {
  //     for (var i = 0; i < participants.length; i += chunkSize) {
  //       final slice = participants
  //           .skip(i)
  //           .take(chunkSize)
  //           .map((p) => p.toMap())
  //           .toList();

  //       emit(EventBatchUploading(i + slice.length, participants.length));

  //       await repository.upsertParticipant(
  //         slice.first,
  //       ); // TODO: لو عندك upsertBatch خليها هنا
  //     }

  //     emit(EventBatchUploadSuccess());
  //   } catch (e) {
  //     emit(EventError("Batch Upload Error: $e"));
  //   }
  // }

  /// استيراد من Excel
  Future<void> importFromExcel(String filePath, {int chunkSize = 100}) async {
  try {
    // 1️⃣ Preparing
    emit(ImportPreparing());

    // 2️⃣ امسح الجدول كله
    await repository.clearAllParticipants();
    print("✅ Cleared all participants");

    // 3️⃣ اقرأ من الاكسيل
    final imported = await ExcelServiceEvent.importFromExcel(filePath);
    print("📥 Imported from excel: ${imported.length} rows");

    int inserted = 0;
    int failed = 0;
    final total = imported.length;

    if (total == 0) {
      print("⚠️ Excel file is empty or not parsed correctly");
    }

    // 4️⃣ أول Progress فعلي
    emit(ImportProgress(current: 0, total: total));

    // 5️⃣ اعمل upsert بالباتش
    for (var i = 0; i < total; i += chunkSize) {
      var slice = imported.skip(i).take(chunkSize).map((p) => p.toMap()).toList();
      slice = _removeDuplicates(slice);

      print("👉 Processing batch ${i ~/ chunkSize + 1}, size: ${slice.length}");

      try {
        await repository.upsertParticipants(slice);
        print("✅ Upserted batch with ${slice.length} rows");
        inserted += slice.length;
      } catch (e) {
        print("❌ Upsert Error: $e");
        failed += slice.length;
      }

      emit(ImportProgress(current: (i + slice.length), total: total));
    }

    // 6️⃣ تقرير بعد الانتهاء
    emit(EventImportedReport(
      inserted: inserted,
      updated: 0,
      skipped: 0,
      failed: failed,
      total: total,
    ));

    print("📊 Import Finished -> Inserted/Updated: $inserted, Failed: $failed, Total: $total");
  } catch (e) {
    print("💥 Import Error: $e");
    emit(EventError("Import Error: $e"));
  }
}


  /// 🧹 Helper لإزالة الـ duplicates حسب الـ id
  List<Map<String, dynamic>> _removeDuplicates(
    List<Map<String, dynamic>> data,
  ) {
    final seen = <String>{};
    final result = <Map<String, dynamic>>[];

    for (var row in data) {
      final id = row['id'] as String;
      if (!seen.contains(id)) {
        seen.add(id);
        result.add(row);
      }
    }
    return result;
  }

  /// تصدير لملف Excel (هنحتاج ExcelService)
  Future<String?> exportToExcel(List<EventParticipant> participants) async {
    try {
      emit(EventExporting());

      final filePath = await ExcelServiceEvent.exportToExcel(participants);

      emit(EventExportSuccess(filePath));
      return filePath; // ✅ نرجع المسار
    } catch (e) {
      emit(EventError("Export Error: $e"));
      return null;
    }
  }
}
