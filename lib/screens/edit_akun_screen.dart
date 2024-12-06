import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({Key? key}) : super(key: key);

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController(); // Current password controller
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _updateAccount() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada user logged in.")),
      );
      return;
    }

    final String newUsername = _usernameController.text.trim();
    final String newPassword = _passwordController.text.trim();
    final String currentPassword = _currentPasswordController.text.trim(); // Get current password

    if (newUsername.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username tidak boleh kosong.")),
      );
      return;
    }

    try {
      // Update username in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'username': newUsername,
      });

      // If password is entered, reauthenticate and update password
      if (newPassword.isNotEmpty) {
        // Reauthenticate the user with current password
        final AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        // Perform reauthentication
        await user.reauthenticateWithCredential(credential);

        // After reauthentication, update the password
        await user.updatePassword(newPassword);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Akun berhasil diubah.")),
      );

      // navigate back to profile or login page
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating account: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Username Field
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silahkan masukkan username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Current Password Field
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password yang digunakan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silahkan masukkan password yang anda gunakan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // New Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password baru(Opsional)'),
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'Password muminimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),

              // Update Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updateAccount();
                    }
                  },
                  child: const Text('Update Akun', style: TextStyle(color: Colors.pink),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
