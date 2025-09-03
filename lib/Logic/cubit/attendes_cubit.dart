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

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
