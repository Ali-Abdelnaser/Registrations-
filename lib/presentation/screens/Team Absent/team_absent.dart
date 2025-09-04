import 'package:flutter/material.dart';
import 'package:registration/presentation/screens/scan/qr_scan.dart';
import 'package:registration/presentation/widgets/navigator.dart';

class TeamallParticipantsScreen extends StatelessWidget {
  final String teamName;
  final List<Map<String, dynamic>> allParticipants;

  const TeamallParticipantsScreen({
    super.key,
    required this.teamName,
    required this.allParticipants,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          'Absent from $teamName',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: allParticipants.isEmpty
          ? const Center(
              child: Text(
                '🎉 All members attended!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: allParticipants.length,
              itemBuilder: (context, index) {
                final person = allParticipants[index];

                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: FractionallySizedBox(
                          heightFactor: 0.6,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Text(
                                    "Member Information",
                                    style: TextStyle(
                                      color: Color(0xff016da6),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _infoRow(
                                  "ID",
                                  person['id'],
                                  Icons.assignment_ind,
                                ),
                                _infoRow("Name", person['Name'], Icons.person),
                                _infoRow("Email", person['email'], Icons.email),
                                _infoRow("Team", person['Team'], Icons.groups),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: const Color(0xff016da6),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: IconButton(
                        onPressed: () {
                          AppNavigator.fade(
                            context,
                            const QRViewScreen(),
                            replace: false,
                          );
                        },
                        icon: const Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        person['Name'] ?? 'No Name',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      subtitle: Text(
                        person['email'] ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.warning_amber,
                        color: Colors.yellowAccent,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _infoRow(String title, String? value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xff016da6)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          leading: Icon(icon, color: const Color(0xff016da6), size: 28),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            value ?? '',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
