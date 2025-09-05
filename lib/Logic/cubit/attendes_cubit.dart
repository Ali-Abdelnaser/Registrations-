import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/Logic/cubit/attendes_state.dart';
import 'package:registration/data/models/attendee.dart';
import 'package:registration/data/repositories/attendee_repository.dart';

class BranchMembersCubit extends Cubit<BranchMembersState> {
  final AuthRepository repository;
  StreamSubscription<List<Attendee>>? _subscription;

  BranchMembersCubit(this.repository) : super(BranchMembersInitial());

  /// ✅ تحميل الأعضاء live
  void loadBranchMembers() {
    emit(BranchMembersLoading());
    try {
      _subscription?.cancel(); // يلغي أي استريم قديم
      _subscription = repository.streamBranchMembers().listen(
        (members) => emit(BranchMembersLoaded(members)),
        onError: (error) => emit(BranchMembersError(error.toString())),
      );
    } catch (e) {
      emit(BranchMembersError(e.toString()));
    }
  }

  Future<void> importFromExcel(String filePath) async {
    try {
      emit(ImportProgress(progress: 0, current: 0, total: 0));

      // 1. قراءة الملف
      final members = await repository.importMembersFromExcel(filePath);

      // 2. فلترة عشان نرمي أي صف ملوش id
      final validMembers = members
          .where((m) => m.id.trim().isNotEmpty)
          .toList();
      final total = validMembers.length;

      if (total == 0) {
        emit(BranchMembersError("⚠️ لا يوجد سجلات صالحة في الملف."));
        return;
      }

      // Counters
      int current = 0;
      int inserted = 0;
      int updated = 0;
      int skipped = members.length - validMembers.length;
      int failed = 0;

      // 3. لف على كل عضو
      for (final m in validMembers) {
        try {
          final result = await repository.upsertBranchMember(m.toMap());

          if (result != null && result.isNotEmpty) {
            inserted++;
          } else {
            updated++;
          }
        } catch (e) {
          failed++;
        } finally {
          current++;
          emit(
            ImportProgress(
              progress: current / total,
              current: current,
              total: total,
            ),
          );
        }
      }

      // 4. رجّع التقرير النهائي (هنا بس)
      emit(
        BranchMembersImportedReport(
          inserted: inserted,
          updated: updated,
          skipped: skipped,
          failed: failed,
          total: members.length,
        ),
      );

      // 👇 امسح دي، لأنها اللي كانت بتبوظ الـUI
      // emit(BranchMembersLoaded(validMembers));
    } catch (e) {
      emit(BranchMembersError("Import failed: $e"));
    }
  }

  /// ✅ Export to Excel
  Future<String?> exportToExcel(List<Attendee> members) async {
    try {
      final path = await repository.exportMembersToExcel(members);
      return path; // بيرجع مكان الملف اللي اتعمل
    } catch (e) {
      emit(BranchMembersError("Error exporting Excel: $e"));
      return null;
    }
  }

  Future<void> addMember({
    required String id,
    required String name,
    required String email,
    required String team,
  }) async {
    try {
      final success = await repository.addBranchMember({
        'id': id,
        'Name': name,
        'email': email,
        'Team': team,
        'attendance': false,
        'scannedAt': null,
      });

      if (!success) {
        emit(BranchMembersError("Failed to insert member"));
      } else {
        // تقدر تعمل emit لنجاح هنا لو عايز
      }
    } catch (e) {
      emit(BranchMembersError(e.toString()));
      rethrow; // 👈 دي مهمة عشان الـ UI يقدر يلتقط الغلط في onPressed
    }
  }

  /// ✅ بحث
  Future<void> searchMembers(String query) async {
    emit(BranchMembersLoading());
    try {
      final results = await repository.searchBranchMembers(query);
      emit(BranchMembersLoaded(results));
    } catch (e) {
      emit(BranchMembersError(e.toString()));
    }
  }

  /// ✅ تعديل
  Future<void> updateMember(String id, Map<String, dynamic> updates) async {
    try {
      await repository.updateBranchMember(id, updates);
      // مفيش داعي تبعت State جديد هنا، الاستريم هيجيب الداتا بعد التحديث
    } catch (e) {
      emit(BranchMembersError(e.toString()));
    }
  }

  /// ✅ مسح
  Future<void> resetAttendance(String id) async {
    try {
      await repository.updateBranchMember(id, {
        'attendance': false,
        'scannedAt': null, // ✅ هنخليها فاضية
      });
      // الاستريم هيعمل التحديث تلقائي
    } catch (e) {
      emit(BranchMembersError(e.toString()));
    }
  }

  /// ✅ مسح عضو
  Future<void> deleteMember(String id) async {
    try {
      await repository.deleteBranchMember(id);
      // الاستريم هيحدث البيانات تلقائي
    } catch (e) {
      emit(BranchMembersError("Error deleting member: $e"));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
