import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration/Logic/cubit/attendes_cubit.dart';
import 'package:registration/Logic/cubit/attendes_state.dart';
import 'package:registration/presentation/widgets/navigator.dart';
import 'package:registration/presentation/screens/Home%20Page/home_page.dart';

class ScannedParticipantsScreen extends StatefulWidget {
  const ScannedParticipantsScreen({super.key});

  @override
  State<ScannedParticipantsScreen> createState() =>
      _ScannedParticipantsScreenState();
}

class _ScannedParticipantsScreenState extends State<ScannedParticipantsScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<BranchMembersCubit>().loadBranchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchMembersCubit, BranchMembersState>(
      builder: (context, state) {
        if (state is BranchMembersLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is BranchMembersError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                "Error: ${state.message}",
                style: const TextStyle(color: Colors.red),
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

          if (attendees.isEmpty) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Text(
                  'No attended participants found.',
                  style: TextStyle(
                    color: Color(0xff016da6),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  // 🔍 Search
                  TextField(
                    onChanged: (q) =>
                        setState(() => searchQuery = q.toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Search by name or email...',
                      hintStyle: const TextStyle(color: Color(0xff016da6)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xff016da6),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Color(0xff016da6),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xff016da6),
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xff016da6),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  // 📋 Participants List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<BranchMembersCubit>().loadBranchMembers();
                      },
                      child: ListView.builder(
                        itemCount: attendees.length + 1,
                        itemBuilder: (context, index) {
                          if (index == attendees.length) {
                            return const SizedBox(height: 120);
                          }
                          final person = attendees[index];
                          return Card(
                            color: const Color(0xff016da6),
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
                                person.email,
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
                                      .deleteMember(person.id);
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

        return const SizedBox.shrink();
      },
    );
  }
}
