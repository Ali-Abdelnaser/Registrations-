import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:registration/Logic/cubit/attendes_cubit.dart';
import 'package:registration/Logic/cubit/attendes_state.dart';
import 'package:registration/data/models/attendee.dart';
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
    'Assistant',
    'Business',
    'Media',
  ];
  
  final Map<String, Color> colors = {
    'HR': Color.fromARGB(179, 1, 68, 126),
    'Logistics': Colors.green,
    'Assistant': Colors.orange,
    'Business': Colors.purple,
    'Media': Colors.red,
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
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BranchMembersError) {
              return Center(
                child: Text(
                  "Error: ${state.message}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is BranchMembersLoaded) {
              final members = state.members;

              // حساب الحضور والغياب
              Map<String, double> attendedCounts = {
                for (var team in teams) team: 0.0,
              };
              Map<String, int> totalCounts = {for (var team in teams) team: 0};

              for (Attendee attendee in members) {
                final team = attendee.team.trim();
                if (teams.contains(team)) {
                  totalCounts[team] = (totalCounts[team] ?? 0) + 1;
                  // نفترض أن عندك attendance في الموديل
                  if (attendee.attended == true) {
                    attendedCounts[team] = (attendedCounts[team] ?? 0) + 1.0;
                  }
                }
              }

              final totalAttendance = attendedCounts.values
                  .fold(0.0, (a, b) => a + b)
                  .toInt();
              final totalParticipants = totalCounts.values.fold(
                0,
                (a, b) => a + b,
              );

              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<BranchMembersCubit>().loadBranchMembers(),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            // AppNavigator.fade(context, CustomBottomAppBar());
                          },
                        ),
                        const Spacer(flex: 1),
                        Center(
                          child: Text(
                            'Total Participants: $totalParticipants   ',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),

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

                    // Export Button (Excel)
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // await exportParticipantsAsExcel(
                          //   context,
                          //   members.map((m) => m.toMap()).toList(),
                          // );
                        },
                        icon: const Icon(
                          Icons.file_download_outlined,
                          size: 25,
                        ),
                        label: const Text(
                          'Download Attendance ',
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

                    // Cards per team
                    ...teams.map((team) {
                      final attended = attendedCounts[team]?.toInt() ?? 0;
                      final total = totalCounts[team] ?? 0;
                      final absent = total - attended;

                      return GestureDetector(
                        onTap: () {
                          AppNavigator.fade(
                            context,
                            TeamAbsentsScreen(
                              teamName: team,
                              allParticipants: members
                                  .map((m) => m.toMap())
                                  .toList(),
                            ),
                            replace: false,
                          );
                        },
                        child: Card(
                          color: const Color.fromARGB(207, 211, 210, 210),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$team: $attended Attended',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: colors[team],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Total in $team: $total | Absent: $absent',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
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

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
