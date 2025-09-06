import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:registration/Logic/cubit/event_cubit.dart';
import 'package:registration/Logic/cubit/event_state.dart';
import 'package:registration/data/models/event_participant.dart';
import 'package:registration/core/constants/app_colors.dart';
import 'package:registration/presentation/screens/Data%20Management/progress.dart';
import 'package:registration/presentation/screens/Event%20Management/ImportProgressPage.dart';
import 'package:registration/presentation/screens/Skeleton%20Loader/data_mangment_skeleton.dart';
import 'package:registration/presentation/widgets/snakbar.dart';

class EventDataManagementScreen extends StatefulWidget {
  const EventDataManagementScreen({super.key});

  @override
  State<EventDataManagementScreen> createState() =>
      _EventDataManagementScreenState();
}

class _EventDataManagementScreenState extends State<EventDataManagementScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<EventCubit>()
        .loadParticipants(); // ⬅️ تحميل أول ما تفتح الشاشة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Event Data Management",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          if (state is EventParticipantsLoading) {
            return const Center(child: DataManagementSkeleton());
          }
          if (state is EventError) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/img/error.png", height: 300),
                    const SizedBox(height: 16),

                    const Text(
                      "There was an error",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      onPressed: () {
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
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          List<EventParticipant> participants = [];
          if (state is EventParticipantsLoaded) {
            participants = state.participants;
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<EventCubit>().loadParticipants();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ✅ صورة فوق
                  Image.asset("assets/img/data.png", height: 300),
                  const SizedBox(height: 40),

                  // ✅ زرارين جنب بعض
                  Row(
                    children: [
                      Expanded(
                        child: _buildSquareButton(
                          context,
                          icon: Icons.upload_file,
                          label: "Import Excel",
                          color: AppColors.Blue,
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['xlsx', 'xls'],
                                );

                            if (result != null &&
                                result.files.single.path != null) {
                              final path = result.files.single.path!;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ImportEventProgressPage(filePath: path),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildSquareButton(
                          context,
                          icon: Icons.download,
                          label: "Export Excel",
                          color: Colors.green,
                          onTap: () async {
                            if (participants.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnakBar(
                                  icon: Icons.error,
                                  iconColor: Colors.red,
                                  text: "No data to export!",
                                  textColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            final path = await context
                                .read<EventCubit>()
                                .exportToExcel(participants);

                            if (path != null && context.mounted) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (ctx) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    backgroundColor: Colors.white,
                                    elevation: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(14),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withValues(
                                                alpha: .1,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 40,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            "Export Successful",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Your Excel file has been saved successfully.\n\nDo you want to open it now?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              height: 1.5,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx),
                                                  style: OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 14,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    "Later",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    Navigator.pop(ctx);
                                                    await OpenFilex.open(path);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 14,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    "Open",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  // ✅ Container تنبيه
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.orange,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      "Note: Only Excel files are supported.\nAccepted formats: ",
                                ),
                                TextSpan(
                                  text: ".xlsx",
                                  style: TextStyle(color: Colors.green),
                                ),
                                TextSpan(text: " or "),
                                TextSpan(
                                  text: ".xls",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSquareButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
        ),
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
