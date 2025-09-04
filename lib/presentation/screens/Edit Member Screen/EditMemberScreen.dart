import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/Logic/cubit/attendes_cubit.dart';
import 'package:registration/Logic/cubit/attendes_state.dart';
import 'package:registration/core/constants/app_colors.dart';
import 'package:registration/data/models/attendee.dart';
import 'package:registration/presentation/widgets/text-filed.dart';

class EditMemberScreen extends StatefulWidget {
  final Attendee member;

  const EditMemberScreen({super.key, required this.member});

  @override
  State<EditMemberScreen> createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _idController;

  late String _team;
  bool _attendance = false;

  final List<String> teams = const [
    'HR',
    'Logistics',
    'Event Management',
    'Marketing',
    'PR',
    'FR',
    'Media',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _emailController = TextEditingController(text: widget.member.email);
    _idController = TextEditingController(text: widget.member.id);
    _team = widget.member.team;
    _attendance = widget.member.attendance;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _saveMember() {
    if (!_formKey.currentState!.validate()) return;

    final updates = {
      'id': _idController.text.trim(),
      'Name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'Team': _team,
      'attendance': _attendance,
      'scannedAt': _attendance ? DateTime.now().toIso8601String() : null,
    };

    context.read<BranchMembersCubit>().updateMember(widget.member.id, updates);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchMembersCubit, BranchMembersState>(
      listener: (context, state) {
        if (state is BranchMembersLoaded) {
          // ✅ بمجرد ما الاستريم يجيب البيانات الجديدة
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Member updated successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (state is BranchMembersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: const Text(
            "Edit Member",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.white,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(child: Image.asset("assets/img/form.png", height: 300)),
                CustomTextField(
                  controller: _idController,
                  hint: "ID",
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter an ID" : null,
                  icon: Icons.badge,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _nameController,
                  hint: "Name",
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter a name" : null,
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  hint: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter an email" : null,
                  icon: Icons.email,
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                _buildTeamDropdown(),
                const SizedBox(height: 16),
                _buildAttendanceSwitch(),
                const SizedBox(height: 24),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamDropdown() {
    return DropdownButtonFormField<String>(
      value: _team.isNotEmpty ? _team : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        hintText: "Select Team",
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.Blue, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(16),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.Blue,
      ),
      items: teams
          .map(
            (team) => DropdownMenuItem(
              value: team,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.Blue.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.group,
                      size: 20,
                      color: AppColors.Blue,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    team,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) setState(() => _team = value);
      },
    );
  }

  Widget _buildAttendanceSwitch() {
    return Card(
      color: Colors.grey[50],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SwitchListTile(
        title: const Text(
          "Attendance",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          "Mark if the member attended",
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        value: _attendance,
        activeColor: Colors.white, // الدائرة لما On
        activeTrackColor: AppColors.Blue, // الخلفية لما On
        inactiveThumbColor: Colors.grey.shade400, // الدائرة لما Off
        inactiveTrackColor: Colors.grey.shade300, // الخلفية لما Off
        onChanged: (val) => setState(() => _attendance = val),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
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
              onPressed: () {
                _saveMember();
              },
              child: const Text(
                "Update Member",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    );
  }
}
