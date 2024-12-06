import 'package:flutter/material.dart';

class MyAboutScreen extends StatelessWidget {
  const MyAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo Section
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/logo2.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Aplikasi Deteksi Bahasa Isyarat',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Versi 1.0.0',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Description Section
              const Text(
                'Aplikasi Deteksi Bahasa Isyarat dirancang untuk membantu komunikasi antara '
                'pengguna bahasa isyarat dan masyarakat umum. Dengan teknologi deteksi gambar '
                'dan kecerdasan buatan (AI), aplikasi ini dapat mengenali berbagai gerakan '
                'isyarat tangan dan menerjemahkannya ke dalam teks atau suara.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Features Section
              _buildSectionHeader('Fitur Utama'),
              const SizedBox(height: 10),
              _buildFeatureItem(Icons.camera_alt, 'Deteksi Gerakan Tangan'),
              _buildFeatureItem(Icons.accessibility, 'Antarmuka Ramah Pengguna'),
              const SizedBox(height: 20),

              // Team Section
              _buildSectionHeader('Tim Kami'),
              const SizedBox(height: 10),
              const Text(
                'Muhammad ifandi - 2209106006',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Aldi Solihin - 2209106012',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Bimasakti Cahyo Utomo - 2209106021',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Natanael Primus L. H. N. - 2209106029',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Mission Section
              _buildSectionHeader('Misi Kami'),
              const SizedBox(height: 10),
              const Text(
                'Kami bertujuan untuk menjembatani kesenjangan komunikasi antara komunitas '
                'pengguna bahasa isyarat dan masyarakat luas dengan menyediakan solusi '
                'inovatif yang inklusif dan mudah digunakan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Contact Us Section
              _buildSectionHeader('Hubungi Kami'),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.email, color: Colors.pink),
                  title: const Text('Email'),
                  subtitle: const Text('support@signify.com'),
                  onTap: () {                    
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.phone, color: Colors.pink),
                  title: const Text('Telepon'),
                  subtitle: const Text('+62 123 456 789'),
                  onTap: () {                    
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
