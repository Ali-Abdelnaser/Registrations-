// import 'dart:typed_data';
// import 'package:excel/excel.dart';
// import 'package:file_saver/file_saver.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';

// Future<void> exportParticipantsAsExcel(
//   BuildContext context,
//   List<Map<String, dynamic>> participants,
// ) async {
//   // اطلب صلاحية التخزين
//   var status = await Permission.storage.request();
//   if (!status.isGranted) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("❌ Storage permission denied!"),
//         backgroundColor: Colors.red,
//       ),
//     );
//     return;
//   }

//   // أنشئ ملف Excel
//   final excel = Excel.createExcel();
//   final sheet = excel['Participants'];

//   // Header
//   sheet.appendRow([
//     TextCellValue('ID'),
//     TextCellValue('Name'),
//     TextCellValue('Email'),
//     TextCellValue('Team'),
//     TextCellValue('Attendance'),
//   ]);

//   // البيانات
//   for (var p in participants) {
//     sheet.appendRow([
//       TextCellValue(p['id']?.toString() ?? ''),
//       TextCellValue(p['name']?.toString() ?? ''),
//       TextCellValue(p['email']?.toString() ?? ''),
//       TextCellValue(p['team']?.toString() ?? ''),
//       TextCellValue(p['attendance'] == true ? '✔' : '✖'),
//     ]);
//   }

//   // تحويل لبايتس
//   final List<int>? fileBytes = excel.encode();
//   if (fileBytes == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("❌ Failed to generate Excel file!"),
//         backgroundColor: Colors.red,
//       ),
//     );
//     return;
//   }

//   final Uint8List bytes = Uint8List.fromList(fileBytes);

//   // اسم الملف
//   final String timestamp = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   final String fileName = 'participants_$timestamp.xlsx';

//   // حفظ الملف
//   await FileSaver.instance.saveFile(
//     name: fileName,
//     bytes: bytes,
//     mimeType: MimeType.microsoftExcel,
//   );

//   // حوار نجاح
//   showDialog(
//     context: context,
//     builder: (ctx) => AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
//       content: Text(
//         "Excel file saved successfully as $fileName",
//         textAlign: TextAlign.center,
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(ctx),
//           child: const Text("OK"),
//         ),
//       ],
//     ),
//   );
// }
