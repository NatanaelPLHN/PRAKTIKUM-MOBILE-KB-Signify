import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pa_mobile_1/screens/edit_akun_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "default-uid";

  Future<Map<String, dynamic>?> _fetchUserProfile() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      debugPrint("Error fetch profil user : $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>( 
        future: _fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading profil."));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Tidak ada profil tersedia."));
          }

          final profile = snapshot.data!;
          final String username = profile['username'] ?? "User Tidak Diketahui";
          final String email = profile['email'] ?? "Email Tidak Diketahui";
          final String? profilePictureUrl = profile['profilePictureUrl'];

          return Stack(
            children: [              
              // Positioned.fill(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //         colors: [const Color.fromARGB(255, 180, 180, 180), const Color.fromARGB(255, 255, 255, 255)],
              //         begin: Alignment.topLeft,
              //         end: Alignment.bottomRight,
              //       ),
              //     ),
              //   ),
              // ),
              
              // Profile Content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Section with Elevated Card and Shadow Effect
                      Card(
                        elevation: 5, // Add shadow for depth
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Profile Picture
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: profilePictureUrl != null
                                    ? NetworkImage(profilePictureUrl)
                                    : const AssetImage('assets/profile.png') as ImageProvider,
                              ),
                              const SizedBox(height: 15),
                              // Username
                              Text(
                                username,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              // Email
                              Text(
                                email,
                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the EditAccountScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditAccountScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Rounded corners
                          ),
                        ),
                        child: const Text(
                          "Edit Profil",
                          style: TextStyle(
                            color: Colors.pink, // Text color
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
