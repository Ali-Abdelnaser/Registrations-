import 'package:registration/data/models/attendee.dart';
import 'package:registration/data/services/excel_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// ------------------- Auth ------------------- ///
  Future<Attendee?> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user != null) {
        return Attendee(
          id: user.id,
          email: user.email ?? '',
          name: user.userMetadata?['name'] ?? '',
          team: '',
        );
      }
      return null;
    } catch (e) {
      throw Exception("SignIn Error: $e");
    }
  }

  /// ------------------- CRUD ------------------- ///
  Future<List<Attendee>> getBranchMembers() async {
    try {
      final response = await _supabase.from('Branch_Members').select();
      final data = response as List<dynamic>;
      return data.map((item) => Attendee.fromMap(item)).toList();
    } catch (e) {
      throw Exception("Fetch Branch Members Error: $e");
    }
  }

  Stream<List<Attendee>> streamBranchMembers() {
    return _supabase
        .from('Branch_Members')
        .stream(primaryKey: ['id'])
        .order('id')
        .map((data) {
          return data.map((item) => Attendee.fromMap(item)).toList();
        });
  }

  Future<List<Attendee>> searchBranchMembers(String query) async {
    try {
      final response = await _supabase
          .from('Branch_Members')
          .select()
          .ilike('name', '%$query%');
      final data = response as List<dynamic>;
      return data.map((item) => Attendee.fromMap(item)).toList();
    } catch (e) {
      throw Exception("Search Branch Members Error: $e");
    }
  }

  Future<Attendee?> getMemberById(String id) async {
    try {
      final Map<String, dynamic>? row = await _supabase
          .from('Branch_Members')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (row == null) return null;
      return Attendee.fromMap(row);
    } catch (e) {
      throw Exception('Fetch Member By ID Error: $e');
    }
  }

  Future<void> updateBranchMember(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _supabase.from('Branch_Members').update(updates).eq('id', id);
    } catch (e) {
      throw Exception("Update Branch Member Error: $e");
    }
  }

  Future<void> deleteBranchMember(String id) async {
    try {
      await _supabase.from('Branch_Members').delete().eq('id', id);
    } catch (e) {
      throw Exception("Delete Branch Member Error: $e");
    }
  }

  Future<void> deleteAllMembers() async {
    try {
      await _supabase.from('Branch_Members').delete().neq('id', '');
    } catch (e) {
      throw Exception("Delete All Members Error: $e");
    }
  }

  Future<bool> addBranchMember(Map<String, dynamic> data) async {
    try {
      await _supabase.from('Branch_Members').insert(data);
      return true;
    } catch (e) {
      if (e.toString().contains("duplicate") ||
          e.toString().contains("conflict")) {
        throw Exception("Member already exists");
      }
      throw Exception("Insert failed: $e");
    }
  }

  Future<void> addMembersBatch(
    List<Attendee> members, {
    int chunkSize = 300,
  }) async {
    try {
      for (var i = 0; i < members.length; i += chunkSize) {
        final slice = members
            .skip(i)
            .take(chunkSize)
            .map((m) => m.toMap())
            .toList();
        await _supabase.from('Branch_Members').insert(slice);
      }
    } catch (e) {
      throw Exception("Add Members Batch Error: $e");
    }
  }

  Future<void> markAttendance(String id) async {
    await _supabase
        .from('Branch_Members')
        .update({
          'attendance': true,
          'scannedAt': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
  }

  Future<dynamic> upsertBranchMember(Map<String, dynamic> data) async {
    try {
      final response = await _supabase
          .from('Branch_Members')
          .upsert(data) // ✅ insert لو جديد، update لو موجود
          .select(); // عشان يرجع الصف بعد العملية

      return response; // بيرجع List<Map<String,dynamic>>
    } catch (e) {
      throw Exception("Upsert Branch Member Error: $e");
    }
  }

  /// ------------------- Excel ------------------- ///

  Future<String> exportMembersToExcel(List<Attendee> members) async {
    return await ExcelService.exportToExcel(members);
  }

  Future<List<Attendee>> importMembersFromExcel(String filePath) async {
    return await ExcelService.importFromExcel(filePath);
  }
}
