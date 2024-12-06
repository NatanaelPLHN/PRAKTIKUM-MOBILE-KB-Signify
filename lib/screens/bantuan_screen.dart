import 'package:flutter/material.dart';

class MyHelpScreen extends StatelessWidget {
  const MyHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildHelpCard(
              title: 'Cara Menggunakan Aplikasi',
              description: 'Panduan langkah demi langkah untuk memulai menggunakan aplikasi.',
              icon: Icons.book,
            ),
            _buildHelpCard(
              title: 'Masalah Login',
              description: 'Tips dan bantuan untuk menyelesaikan masalah login.',
              icon: Icons.login,
            ),
            _buildHelpCard(
              title: 'Mengelola Akun',
              description: 'Pelajari cara memperbarui detail akun Anda.',
              icon: Icons.person,
            ),
            _buildHelpCard(
              title: 'Hubungi Dukungan',
              description: 'Butuh bantuan lebih lanjut? Hubungi kami melalui email atau telepon.',
              icon: Icons.support_agent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.pink),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          
        },
      ),
    );
  }
}
