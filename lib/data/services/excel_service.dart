import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:registration/data/models/attendee.dart';

class ExcelService {
  /// Export members to Excel in Downloads/Documents folder
  static Future<String> exportToExcel(List<Attendee> members) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Attendance'];

      // headers
      sheet.appendRow([
        TextCellValue('ID'),
        TextCellValue('Name'),
        TextCellValue('Email'),
        TextCellValue('Team'),
        TextCellValue('Attendance'),
        TextCellValue('ScannedAt'),
      ]);

      // rows
      for (var m in members) {
        sheet.appendRow([
          TextCellValue(m.id),
          TextCellValue(m.name),
          TextCellValue(m.email),
          TextCellValue(m.team),
          TextCellValue(m.attendance == true ? "true" : "false"),
          TextCellValue(m.scannedAt?.toIso8601String() ?? ""),
        ]);
      }

      // get save path
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/Download");
        if (!directory.existsSync()) {
          directory = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getDownloadsDirectory(); // Windows/Mac/Linux
      }

      final path = "${directory!.path}/attendance.xlsx";

      // save file
      final fileBytes = excel.encode();
      if (fileBytes != null) {
        final file = File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
      }

      return path;
    } catch (e) {
      throw Exception("Export Excel Error: $e");
    }
  }

  static Future<List<Attendee>> importFromExcel(String filePath) async {
    try {
      final bytes = File(filePath).readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      final List<Attendee> members = [];

      for (final table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;

        for (int i = 1; i < sheet.rows.length; i++) {
          final row = sheet.rows[i];
          if (row.isEmpty || row[0] == null) continue;

          final id = row[0]?.value?.toString() ?? "";
          final name = row.length > 1 ? row[1]?.value?.toString() ?? "" : "";
          final email = row.length > 2 ? row[2]?.value?.toString() ?? "" : "";
          final team = row.length > 3 ? row[3]?.value?.toString() ?? "" : "";

          // ✅ معالجة الحضور
          String rawAttendance = row.length > 4 && row[4]?.value != null
              ? row[4]!.value.toString()
              : "false";
          final attendance = rawAttendance.toLowerCase() == "true";

          // ✅ الاسكان هيكون null لحد ما يتعمل اسكان
          final DateTime? scannedAt = null;

          members.add(
            Attendee(
              id: id,
              name: name,
              email: email,
              team: team,
              attendance: attendance,
              scannedAt: scannedAt,
            ),
          );
        }
      }

      return members;
    } catch (e) {
      throw Exception("Import From Excel Error: $e");
    }
  }
}
