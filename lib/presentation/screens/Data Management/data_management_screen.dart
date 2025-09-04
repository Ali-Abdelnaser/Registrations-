import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:registration/Logic/cubit/attendes_cubit.dart';
import 'package:registration/Logic/cubit/attendes_state.dart';
import 'package:registration/data/models/attendee.dart';
import 'package:registration/core/constants/app_colors.dart';
import 'package:registration/presentation/screens/Skeleton%20Loader/data_mangment_skeleton.dart';

class DataManagementScreen extends StatelessWidget {
  const DataManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Data Management",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<BranchMembersCubit, BranchMembersState>(
        builder: (context, state) {
          if (state is BranchMembersLoading) {
            return const Center(child: DataManagementSkeleton());
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

          List<Attendee> members = [];
          if (state is BranchMembersLoaded) {
            members = state.members;
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<BranchMembersCubit>().loadBranchMembers();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ✅ صورة فوق
                  Image.asset(
                    "assets/img/data.png", // مسار الصورة بتاعتك
                    height: 300,
                  ),
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
                              context
                                  .read<BranchMembersCubit>()
                                  .importFromExcel(path);
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
                            if (members.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("No data to export!"),
                                ),
                              );
                              return;
                            }

                            final path = await context
                                .read<BranchMembersCubit>()
                                .exportToExcel(members);

                            if (path != null && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Excel exported successfully:\n$path",
                                  ),
                                ),
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
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blueGrey,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      "Note: Only Excel files are supported.\nAccepted formats: ",
                                ),
                                TextSpan(
                                  text: ".xlsx",
                                  style: const TextStyle(color: Colors.green),
                                ),
                                const TextSpan(text: " or "),
                                TextSpan(
                                  text: ".xls",
                                  style: const TextStyle(color: Colors.green),
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
