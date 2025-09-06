import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:registration/data/models/event_participant.dart';

class ExcelServiceEvent {
  /// Export Event Participants

  /// Export Event Participants
  static Future<String> exportToExcel(
    List<EventParticipant> participants,
  ) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Event'];

      // ✅ headers
      sheet.appendRow([
        TextCellValue('ID'),
        TextCellValue('Name'),
        TextCellValue('Email'),
        TextCellValue('Attendance'),
        TextCellValue('ScannedAt'),
      ]);

      // ✅ rows
      for (var p in participants) {
        sheet.appendRow([
          TextCellValue(p.id),
          TextCellValue(p.name),
          TextCellValue(p.email),
          TextCellValue(p.attendance ? "true" : "false"),
          TextCellValue(p.scannedAt?.toIso8601String() ?? ""),
        ]);
      }

      // ✅ احفظ الملف في الـ App Sandbox (Documents)
      final dir = await getApplicationDocumentsDirectory();
      final path = "${dir.path}/event_participants.xlsx";

      final fileBytes = excel.encode();
      if (fileBytes != null) {
        final file = File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
      }

      return path;
    } catch (e) {
      throw Exception("Export Event Excel Error: $e");
    }
  }

  /// Import Event Participants
  static Future<List<EventParticipant>> importFromExcel(String filePath) async {
    try {
      final bytes = File(filePath).readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      final List<EventParticipant> participants = [];

      for (final table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;

        for (int i = 1; i < sheet.rows.length; i++) {
          final row = sheet.rows[i];
          if (row.isEmpty || row[0] == null) continue;

          final id = row[0]?.value?.toString() ?? "";
          final name = row.length > 1 ? row[1]?.value?.toString() ?? "" : "";
          final email = row.length > 2 ? row[2]?.value?.toString() ?? "" : "";

          String rawAttendance = row.length > 3 && row[3]?.value != null
              ? row[3]!.value.toString()
              : "false";
          final attendance = rawAttendance.toLowerCase() == "true";

          final DateTime? scannedAt = null;

          participants.add(
            EventParticipant(
              id: id,
              name: name,
              email: email,
              attendance: attendance,
              scannedAt: scannedAt,
            ),
          );
        }
      }

      return participants;
    } catch (e) {
      throw Exception("Import Event Excel Error: $e");
    }
  }
}
