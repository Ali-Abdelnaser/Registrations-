import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/Logic/cubit/attendes_cubit.dart';
import 'package:registration/Logic/cubit/attendes_state.dart';
import 'package:registration/data/models/attendee.dart';

class ScannedParticipantsScreen extends StatefulWidget {
  const ScannedParticipantsScreen({Key? key}) : super(key: key);

  @override
  State<ScannedParticipantsScreen> createState() => _ScannedParticipantsScreenState();
}

class _ScannedParticipantsScreenState extends State<ScannedParticipantsScreen> {
  List<Attendee> _allMembers = [];
  List<Attendee> _filteredMembers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // تحميل البيانات أول ما الشاشة تفتح
    context.read<BranchMembersCubit>().loadBranchMembers();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMembers = _allMembers
          .where((member) =>
              member.name.toLowerCase().contains(query) ||
              member.email.toLowerCase().contains(query))
          .toList();
    });
  }

  void _deleteMember(String id) {
    context.read<BranchMembersCubit>().deleteMember(id as int);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanned Participants"),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search participants...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Participants list
          Expanded(
            child: BlocBuilder<BranchMembersCubit, BranchMembersState>(
              builder: (context, state) {
                if (state is BranchMembersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BranchMembersLoaded) {
                  _allMembers = state.members;
                  // لو مفيش بحث مستخدم
                  if (_searchController.text.isEmpty) {
                    _filteredMembers = _allMembers;
                  }
                  if (_filteredMembers.isEmpty) {
                    return const Center(child: Text("No participants found."));
                  }
                  return ListView.builder(
                    itemCount: _filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = _filteredMembers[index];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(member.name),
                        subtitle: Text(member.email),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMember(member.id),
                        ),
                      );
                    },
                  );
                } else if (state is BranchMembersError) {
                  return Center(child: Text("Error: ${state.message}"));
                }
                return const Center(child: Text("No data available"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
