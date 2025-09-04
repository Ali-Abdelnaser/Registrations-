import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/Logic/cubit/attendes_cubit.dart';
import 'package:registration/Logic/cubit/attendes_state.dart';
import 'package:intl/intl.dart';
import 'package:registration/core/constants/app_colors.dart';
import 'package:registration/presentation/screens/Skeleton%20Loader/home_skeleton.dart';

class ScannedParticipantsScreen extends StatefulWidget {
  const ScannedParticipantsScreen({super.key});

  @override
  State<ScannedParticipantsScreen> createState() =>
      _ScannedParticipantsScreenState();
}

class _ScannedParticipantsScreenState extends State<ScannedParticipantsScreen> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BranchMembersCubit>().loadBranchMembers();
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return "Not scanned yet";

    try {
      DateTime dateTime;

      if (timestamp is DateTime) {
        dateTime = timestamp;
      } else if (timestamp is String) {
        dateTime = DateTime.parse(timestamp);
      } else {
        return "Invalid date";
      }

      return DateFormat('dd MMM yyyy • hh:mm a').format(dateTime);
    } catch (e) {
      return "Invalid date";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchMembersCubit, BranchMembersState>(
      builder: (context, state) {
        if (state is BranchMembersLoading) {
          return Center(child: HomePageSkeleton());
        }

        if (state is BranchMembersError) {
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
                        context.read<BranchMembersCubit>().loadBranchMembers();
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

        if (state is BranchMembersLoaded) {
          // ✅ فلترة الحاضرين بس
          final attendees = state.members
              .where((m) => m.attendance == true)
              .where(
                (m) =>
                    m.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                    m.email.toLowerCase().contains(searchQuery.toLowerCase()),
              )
              .toList();
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  // 🔍 Search
                  TextField(
                    controller: _searchController,
                    onChanged: (q) =>
                        setState(() => searchQuery = q.toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Search by name or email...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
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
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: AppColors.Blue,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  // 📋 Participants List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<BranchMembersCubit>().loadBranchMembers();
                      },
                      child: attendees.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Image.asset(
                                    "assets/img/search.png",
                                    height: 350,
                                  ),
                                ),

                                const Text(
                                  "Member Was Absent From The Event",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: AppColors.Blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: attendees.length + 1,
                              itemBuilder: (context, index) {
                                if (index == attendees.length) {
                                  return const SizedBox(height: 120);
                                }
                                final person = attendees[index];
                                return Card(
                                  color: AppColors.Blue,
                                  margin: const EdgeInsets.all(6),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      person.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    subtitle: Text(
                                      _formatTimestamp(person.scannedAt),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<BranchMembersCubit>()
                                            .resetAttendance(person.id);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(child: HomePageSkeleton());
      },
    );
  }
}
