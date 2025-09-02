import 'package:registration/data/models/attendee.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

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

  /// ✅ بحث بالاسم أو الإيميل
  Future<List<Attendee>> searchBranchMembers(String query) async {
    try {
      final response = await _supabase
          .from('Branch_Members')
          .select()
          .ilike('name', '%$query%'); // بيدور بالـ LIKE
      final data = response as List<dynamic>;
      return data.map((item) => Attendee.fromMap(item)).toList();
    } catch (e) {
      throw Exception("Search Branch Members Error: $e");
    }
  }

  /// ✅ تعديل بيانات عضو
  Future<Attendee?> getMemberById(String id) async {
    try {
      final Map<String, dynamic>? row = await _supabase
          .from('Branch_Members')
          .select()
          .eq('id', id)
          .maybeSingle(); // null لو مش لاقي

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

  /// ✅ مسح عضو
  Future<void> deleteBranchMember(String id) async {
    try {
      await _supabase.from('Branch_Members').delete().eq('id', id);
    } catch (e) {
      throw Exception("Delete Branch Member Error: $e");
    }
  }

  /// ✅ تحديث حالة الحضور
  Future<void> markAttendance(String id) async {
    await _supabase
        .from('Branch_Members')
        .update({
          'attendance': true,
          'scannedAt': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
  }
}
