import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/Logic/cubit/event_cubit.dart';
import 'package:registration/Logic/cubit/event_state.dart';
import 'package:registration/core/constants/app_colors.dart';

class AttendedScreen extends StatefulWidget {
  const AttendedScreen({super.key});

  @override
  State<AttendedScreen> createState() => _AttendedScreenState();
}

class _AttendedScreenState extends State<AttendedScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<EventCubit>().loadParticipants();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventState>(
      builder: (context, state) {
        if (state is EventParticipantsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EventError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // صورة
                    Center(
                      child: Image.asset("assets/img/error.png", height: 300),
                    ),
                    const SizedBox(height: 16),

                    // رسالة الخطأ
                    const Text(
                      "There was an error",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // التفاصيل (اختياري لو عايز تعرض state.message)
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // زرار ريفريش
                    ElevatedButton.icon(
                      onPressed: () {
                        // إعادة تحميل الداتا
                        context.read<EventCubit>().loadParticipants();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.Blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is EventParticipantsLoaded) {
          final attended = state.attended.where((p) {
            return p.name.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "Attended Members",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              scrolledUnderElevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: Column(
              children: [
                // 🔍 Search bar
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (q) => setState(() => searchQuery = q),
                    decoration: InputDecoration(
                      hintText: 'Search by name...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.Blue,
                      ),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: AppColors.Blue,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // 📊 Container الإحصائيات
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.Blue.withValues(alpha: .05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.Blue.withValues(alpha: .2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        "Total",
                        state.all.length.toString(),
                        Colors.black,
                      ),
                      _buildStat(
                        "Attended",
                        state.attended.length.toString(),
                        Colors.green,
                      ),
                    ],
                  ),
                ),

                // 📋 قائمة الحضور
                Expanded(
                  child: attended.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/img/search.png", height: 250),
                            const SizedBox(height: 12),
                            const Text(
                              "No attendees found",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.Blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: attended.length,
                          itemBuilder: (context, index) {
                            final person = attended[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              shadowColor: AppColors.Blue.withValues(
                                alpha: 0.3,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.Blue.withValues(alpha: 0.7),
                                      Colors.white,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.Blue,
                                    child: Text(
                                      person.name[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    person.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Check-in: ${_formatDate(person.scannedAt)}",
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.hour}:${date.minute.toString().padLeft(2, '0')} - ${date.day}/${date.month}/${date.year}";
  }
}
