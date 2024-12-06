import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pa_mobile_1/theme/theme.dart';
import 'package:pa_mobile_1/auth.dart';

class MySettingsScreen extends StatefulWidget {
  const MySettingsScreen({super.key});

  @override
  State<MySettingsScreen> createState() => _MySettingsScreenState();
}

class _MySettingsScreenState extends State<MySettingsScreen> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "default-uid";
  String? username; // Variabel untuk nama pengguna
  String? profilePictureUrl; // Variabel untuk URL gambar profil

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          username = data?['username'] ?? 'User Tidak Diketahui';
          profilePictureUrl = data?['profilePictureUrl'];
        });
      }
    } catch (e) {
      debugPrint("Error fetch profil user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profil Section
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profilePictureUrl != null
                      ? NetworkImage(profilePictureUrl!)
                      : const AssetImage('assets/profile.png') as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                  username ?? 'Nama Pengguna Tidak Diketahui',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Theme Toggle Card
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.brightness_6, color: Colors.pink),
                title: const Text('Tema'),
                trailing: Switch(
                  value: ThemeProvider.themeNotifier.value == ThemeMode.dark,
                  activeColor: Colors.pink,
                  onChanged: (value) {
                    setState(() {
                      ThemeProvider.toggleTheme();
                    });
                  },
                ),
              ),
            ),

            
            _buildSettingsCard(
              context,
              icon: Icons.notifications,
              text: "Notifikasi",
              onTap: () {
                // Navigate to the Notifications screen
              },
            ),
            _buildSettingsCard(
              context,
              icon: Icons.lock,
              text: "Privasi",
              onTap: () {
                // Navigate to the Privacy screen
              },
            ),
            _buildSettingsCard(
              context,
              icon: Icons.help,
              text: "Bantuan",
              onTap: () {
                Navigator.pushNamed(context, '/help');
              },
            ),
            _buildSettingsCard(
              context,
              icon: Icons.info,
              text: "Tentang",
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
            _buildSettingsCard(
              context,
              icon: Icons.logout_outlined,
              text: "Logout",
              onTap: () async {
                try {
                  // Call the logout function
                  await AuthenticationService().signOut();

                  // Navigate to the login scree
                  Navigator.pushReplacementNamed(context, '/login');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error logging out: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to Create a Settings Card
  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.pink),
        title: Text(text),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
