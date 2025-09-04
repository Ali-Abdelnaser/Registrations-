import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:registration/Logic/cubit/attendes_cubit.dart';
import 'package:registration/Logic/cubit/attendes_state.dart';
import 'package:registration/core/constants/app_colors.dart';
import 'package:registration/data/models/attendee.dart';
import 'package:registration/presentation/screens/Skeleton%20Loader/DashboardSkeleton.dart';
import 'package:registration/presentation/screens/Team%20Absent/team_absent.dart';

import 'package:registration/presentation/widgets/navigator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> teams = [
    'HR',
    'Logistics',
    'Event Management',
    'Marketing',
    'PR',
    'FR',
    'Media',
  ];

  final Map<String, Color> colors = {
    'HR': const Color.fromARGB(255, 55, 110, 165), // Soft Blue
    'Logistics': const Color(0xFF8ABF88), // Soft Green
    'Event Management': const Color(0xFFF4A261), // Warm Orange
    'PR': const Color(0xFF9D6B99), // Muted Purple
    'Marketing': const Color(0xFF4D96FF), // Sky Blue
    'FR': const Color(0xFF7C99AC), // Cool Gray-Blue
    'Media': const Color(0xFFE76F51), // Soft Red/Coral
  };

  @override
  void initState() {
    super.initState();
    context.read<BranchMembersCubit>().loadBranchMembers();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenPadding = screenWidth * 0.05;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding, vertical: 30),
        child: BlocBuilder<BranchMembersCubit, BranchMembersState>(
          builder: (context, state) {
            if (state is BranchMembersLoading ||
                state is BranchMembersInitial) {
              return Center(child: DashboardSkeleton());
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
                          child: Image.asset(
                            "assets/img/error.png",
                            height: 300,
                          ),
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
                            context
                                .read<BranchMembersCubit>()
                                .loadBranchMembers();
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
              final members = state.members;

              /// اجمالي عدد المشاركين
              final totalParticipants = members.length;

              /// احصائيات حسب الفريق
              Map<String, double> attendedCounts = {
                for (var team in teams) team: 0.0,
              };
              Map<String, int> totalCounts = {for (var team in teams) team: 0};

              for (Attendee attendee in members) {
                final team = attendee.team.trim();
                if (teams.contains(team)) {
                  totalCounts[team] = (totalCounts[team] ?? 0) + 1;
                  if (attendee.attendance == true) {
                    attendedCounts[team] = (attendedCounts[team] ?? 0) + 1.0;
                  }
                }
              }

              final totalAttendance = attendedCounts.values
                  .fold(0.0, (a, b) => a + b)
                  .toInt();

              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<BranchMembersCubit>().loadBranchMembers(),
                child: ListView(
                  children: [
                    // الهيدر
                    Center(
                      child: Text(
                        'Total Participants: $totalParticipants',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // الحضور والغياب الكلي
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Attended: $totalAttendance',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' | Absent: ${totalParticipants - totalAttendance}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(221, 255, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // دايرة الحضور
                    PieChart(
                      dataMap: attendedCounts,
                      colorList: teams.map((t) => colors[t]!).toList(),
                      chartRadius: screenWidth / 1.5,
                      legendOptions: const LegendOptions(
                        showLegends: false,
                        legendPosition: LegendPosition.bottom,
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValuesInPercentage: true,
                        showChartValues: true,
                      ),
                      chartType: ChartType.disc,
                    ),

                    const SizedBox(height: 24),

                    // زرار تحميل
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // final list = members.map((m) => m.toMap()).toList();
                          // await exportParticipantsAsExcel(context, list);
                        },
                        icon: const Icon(
                          Icons.file_download_outlined,
                          size: 25,
                        ),
                        label: const Text(
                          'Download Attendance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff016da6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    ...teams.map((team) {
                      final attended = attendedCounts[team]?.toInt() ?? 0;
                      final total = totalCounts[team] ?? 0;
                      final absent = total - attended;

                      return GestureDetector(
                        onTap: () {
                          final absents = members
                              .where(
                                (m) =>
                                    m.attendance == false &&
                                    m.team.trim() == team,
                              )
                              .map((m) => m.toMap())
                              .toList();

                          AppNavigator.fade(
                            context,
                            TeamallParticipantsScreen(
                              teamName: team,
                              allParticipants: absents,
                            ),
                            replace: false,
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: LinearGradient(
                                colors: [
                                  colors[team]!.withOpacity(0.2),
                                  Colors.white,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            child: Row(
                              children: [
                                // أيقونة الفريق
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: colors[team],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.group,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // تفاصيل الأرقام
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        team,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: colors[team],
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          _buildStat(
                                            "Attended",
                                            attended,
                                            Colors.green,
                                          ),
                                          const SizedBox(width: 16),
                                          _buildStat(
                                            "Absent",
                                            absent,
                                            Colors.red,
                                          ),
                                          const SizedBox(width: 16),
                                          _buildStat(
                                            "Total",
                                            total,
                                            Colors.black87,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }

            return const DashboardSkeleton();
          },
        ),
      ),
    );
  }
}

Widget _buildStat(String label, int value, Color color) {
  return Row(
    children: [
      Icon(Icons.circle, size: 10, color: color),
      const SizedBox(width: 4),
      Text(
        "$label: $value",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    ],
  );
}
