import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/Logic/cubit/attendes_cubit.dart';
import 'package:registration/core/constants/app_colors.dart';
import 'package:registration/presentation/widgets/custom_dialog.dart';
import 'package:registration/presentation/widgets/snakbar.dart';
import 'package:registration/presentation/widgets/text-filed.dart';
// استورد الويجت اللي عملته

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? id;
  String? email;
  String? team;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Member",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 14),
                Center(
                  child: Image.asset("assets/img/add-user.png", height: 300),
                ),
                CustomTextField(
                  hint: "Enter ID",
                  icon: Icons.badge,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Please enter ID" : null,
                  onChanged: (val) => id = val,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hint: "Enter Name",
                  icon: Icons.person,
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter name"
                      : null,
                  onChanged: (val) => name = val,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: "Enter Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter email"
                      : null,
                  onChanged: (val) => email = val,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: "Enter Team",
                  icon: Icons.group,
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter team"
                      : null,
                  onChanged: (val) => team = val,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.Blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await context
                                  .read<BranchMembersCubit>()
                                  .addMember(
                                    id: id!,
                                    name: name!,
                                    email: email!,
                                    team: team!,
                                  );

                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnakBar(
                                    text: "Member added successfully",
                                    textColor: AppColors.Blue,
                                    icon: Icons.check_circle,
                                    iconColor: Colors.green,
                                  ),
                                );

                                Navigator.pop(context);
                              }
                            } catch (e) {
                              if (e.toString().contains(
                                "Member already exists",
                              )) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => const CustomDialog(
                                    icon: Icons.warning_amber_rounded,
                                    color: Colors.orange,
                                    title: "Member Exists",
                                    message:
                                        "This member is already in the list.",
                                    buttonText: "OK",
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnakBar(
                                    text: "Error: $e",
                                    textColor: AppColors.red,
                                    icon: Icons.error,
                                    iconColor: AppColors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: const Text(
                          "Add Member",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: AppColors.Blue,
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, size: 30),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
