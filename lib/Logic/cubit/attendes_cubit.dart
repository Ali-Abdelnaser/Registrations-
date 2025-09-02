import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/Logic/cubit/attendes_state.dart';
import 'package:registration/data/models/attendee.dart';
import 'package:registration/data/repositories/attendee_repository.dart';

class BranchMembersCubit extends Cubit<BranchMembersState> {
  final AuthRepository repository;
  Stream<List<Attendee>>? _stream;

  BranchMembersCubit(this.repository) : super(BranchMembersInitial());

  /// ✅ تحميل الأعضاء live
  void loadBranchMembers() {
    emit(BranchMembersLoading());
    try {
      _stream = repository.streamBranchMembers();
      _stream!.listen(
        (members) => emit(BranchMembersLoaded(members)),
        onError: (error) => emit(BranchMembersError(error.toString())),
      );
    } catch (e) {
      emit(BranchMembersError(e.toString()));
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
  Future<void> updateMember(int id, Map<String, dynamic> updates) async {
    try {
      await repository.updateBranchMember(id, updates);
      emit(BranchMemberUpdated());
    } catch (e) {
      emit(BranchMembersError(e.toString()));
    }
  }

  /// ✅ مسح
  Future<void> deleteMember(int id) async {
    try {
      await repository.deleteBranchMember(id);
      emit(BranchMemberDeleted());
    } catch (e) {
      emit(BranchMembersError(e.toString()));
    }
  }
}
