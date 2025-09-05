import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/Logic/cubit/attendes_cubit.dart';
import 'package:registration/Logic/cubit/attendes_state.dart';
import 'package:registration/core/constants/app_colors.dart';
import 'package:registration/presentation/screens/Skeleton%20Loader/data_mangment_skeleton.dart';

class ImportProgressPage extends StatefulWidget {
  final String filePath;

  const ImportProgressPage({super.key, required this.filePath});

  @override
  State<ImportProgressPage> createState() => _ImportProgressPageState();
}

class _ImportProgressPageState extends State<ImportProgressPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BranchMembersCubit>().importFromExcel(widget.filePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Importing Data",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocConsumer<BranchMembersCubit, BranchMembersState>(
        listenWhen: (previous, current) =>
            current is BranchMembersImportedReport ||
            current is BranchMembersError,
        listener: (context, state) {
          if (state is BranchMembersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error: ${state.message}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        buildWhen: (previous, current) {
          // ✅ خلي البناء يحصل بس أول مرة أو في النهاية
          return current is ImportProgress ||
              current is BranchMembersImportedReport ||
              current is BranchMembersError;
        },
        builder: (context, state) {
          if (state is ImportProgress) {
            return _buildProgress(state);
          } else if (state is BranchMembersImportedReport) {
            return _buildReport(state);
          } else if (state is BranchMembersError) {
            return _buildError(state.message);
          }
          return const DataManagementSkeleton();
        },
      ),
    );
  }

  Widget _buildProgress(ImportProgress state) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: state.progress),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, _) {
          final percent = (value * 100).clamp(0, 100).toStringAsFixed(0);
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/img/Progress.png", height: 250),
                const SizedBox(height: 20),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: value,
                    color: AppColors.Blue,
                    strokeWidth: 4,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "$percent%",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${state.current} / ${state.total} records",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.Blue,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReport(BranchMembersImportedReport state) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/img/success.png", height: 250),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        "Inserted: ${state.inserted}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.update, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        "Updated: ${state.updated}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.skip_next, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        "Skipped: ${state.skipped}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        "Failed: ${state.failed}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: Colors.black54),
                  Row(
                    children: [
                      const Icon(Icons.list_alt, color: Colors.black87),
                      const SizedBox(width: 8),
                      Text(
                        "Total Processed: ${state.total}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Go to Data Management",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/img/error.png", height: 180),
          const SizedBox(height: 20),
          Text(
            "Error: $message",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              context.read<BranchMembersCubit>().importFromExcel(
                widget.filePath,
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.Blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
