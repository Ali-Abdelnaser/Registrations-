import 'package:registration/data/models/event_participant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// احضار كل البارتيسبنتس
  Future<List<EventParticipant>> getParticipants() async {
    try {
      final response = await _supabase.from('Event').select();

      final data = response as List<dynamic>;
      return data.map((e) => EventParticipant.fromMap(e)).toList();
    } catch (e) {
      throw Exception("Fetch Participants Error: $e");
    }
  }

  /// Stream للبارتيسبنتس (لو محتاج لايف ابديتس)
  Stream<List<EventParticipant>> streamParticipants() {
    return _supabase
        .from('Event')
        .stream(primaryKey: ['id'])
        .map((data) {
      return data.map((e) => EventParticipant.fromMap(e)).toList();
    });
  }

  /// البحث بالاسم أو الإيميل
  Future<List<EventParticipant>> searchParticipants(String query) async {
    try {
      final response = await _supabase
          .from('Event')
          .select()
          .or("name.ilike.%$query%,email.ilike.%$query%");

      final data = response as List<dynamic>;
      return data.map((e) => EventParticipant.fromMap(e)).toList();
    } catch (e) {
      throw Exception("Search Participants Error: $e");
    }
  }

  /// جلب شخص واحد بالـ ID (لما يتعمل سكان)
  Future<EventParticipant?> getParticipantById(String id) async {
    try {
      final Map<String, dynamic>? row =
          await _supabase.from('Event').select().eq('id', id).maybeSingle();
      if (row == null) return null;
      return EventParticipant.fromMap(row);
    } catch (e) {
      throw Exception('Fetch Participant By ID Error: $e');
    }
  }

  /// تحديث حضور الشخص بعد السكان
  Future<void> markAttendance(String id) async {
    try {
      await _supabase.from('Event').update({
        'attendance': true,
        'scannedAt': DateTime.now().toIso8601String(),
      }).eq('id', id);
    } catch (e) {
      throw Exception("Mark Attendance Error: $e");
    }
  }

  /// upsert (لو عاوز تضيف أو تحدث حسب الـ id)
  Future<dynamic> upsertParticipant(Map<String, dynamic> data) async {
    try {
      final response =
          await _supabase.from('Event').upsert(data).select();
      return response;
    } catch (e) {
      throw Exception("Upsert Participant Error: $e");
    }
  }
}
