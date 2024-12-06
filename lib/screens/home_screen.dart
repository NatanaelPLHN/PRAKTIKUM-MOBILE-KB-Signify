import 'package:carousel_slider/carousel_slider.dart';
import 'package:pa_mobile_1/screens/profile_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile_1/screens/article_screen.dart';
import 'package:pa_mobile_1/screens/learn_screen.dart';
import 'package:pa_mobile_1/screens/settings_screen.dart';
class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  int currentTab = 0; // to keep track of active tab index

  final List<Widget> screens = [
    // const Center(child: Text('Home Page')),
    const HomeScreen(),
    const MyLearnScreen(),
    const MyProfileScreen(),
    const MySettingsScreen(),
  ];

  // Function to request camera permission
  Future<void> _handleCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isDenied || status.isRestricted) {
      // Request camera permission
      final newStatus = await Permission.camera.request();

      if (newStatus.isGranted) {
        Navigator.pushNamed(context, '/camera'); // Navigate to camera page
      } else if (newStatus.isPermanentlyDenied) {
        _showPermissionSettingsDialog(context); // Show settings dialog if permission is permanently denied
      } else {
        _showPermissionDeniedDialog(context); // Show denied dialog
      }
    } else if (status.isGranted) {
      Navigator.pushNamed(context, '/camera'); // Navigate to camera page
    } else if (status.isPermanentlyDenied) {
      _showPermissionSettingsDialog(context); // Show settings dialog if permission is permanently denied
    }
  }

  // Function to show permission denied dialog
  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text(
          'Kamera tidak dapat digunakan tanpa akses. Silakan izinkan akses ke kamera di pengaturan smartphone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.pink),),
          ),
        ],
      ),
    );
  }

  // Function to show permission settings dialog
  void _showPermissionSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Permanently Denied'),
        content: const Text(
          'Akses kamera telah ditolak secara permanen. Silakan buka pengaturan aplikasi untuk memberikan akses.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Batal', style: TextStyle(color: Colors.pink),),
          ),
          TextButton(
            onPressed: () {
              openAppSettings(); // Open app settings
              Navigator.pop(context);
            },
            child: const Text('Pengaturan', style: TextStyle(color: Colors.pink),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50, // Menyesuaikan tinggi appbar
        flexibleSpace: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 34, left: 10),
              child: Image.asset(
                'assets/logo2.png',
                width: 100,
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: currentTab,
        children: screens,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        shape: const CircleBorder(),
        child: Icon(Icons.camera_alt_rounded,
            color: isDarkTheme ? Colors.black : Colors.white),
        onPressed: () =>  _handleCameraPermission(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color: isDarkTheme
            ? const Color.fromARGB(255, 26, 26, 26)
            : const Color.fromARGB(255, 238, 238, 238),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTabItem(0, Icons.home, 'Home'),
              _buildTabItem(1, Icons.my_library_books, 'Learn'),
              const Spacer(),
              _buildTabItem(2, Icons.account_circle, 'Profile'),
              _buildTabItem(3, Icons.settings, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  /// Membuat tab item untuk bottom navigation bar
  Widget _buildTabItem(int index, IconData icon, String label) {
    return MaterialButton(
      minWidth: 80,
      onPressed: () {
        setState(() {
          currentTab = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: currentTab == index ? Colors.pink : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: currentTab == index ? Colors.pink : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// Halaman Home Page
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Selamat Datang di Signify",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Deteksi Bahasa Isyarat dalam Waktu Nyata. Mulai eksplorasi dunia bahasa isyarat sekarang!",
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Carousel Section
            CarouselSlider(
              items: [
                _buildCarouselItem('assets/img/gambar1.png'),
                _buildCarouselItem('assets/img/gambar2.png'),
                _buildCarouselItem('assets/img/gambar3.png'),
              ],
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: true,
                autoPlayInterval: const Duration(seconds: 3),
              ),
            ),
            const SizedBox(height: 20),
            // Cards Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCard(
                    context,
                    imagePath: 'assets/img/gambar5.png',
                    title: 'Mengapa Deteksi Bahasa Isyarat Penting?',
                    content:
                        'Bahasa isyarat adalah salah satu bentuk komunikasi visual yang digunakan oleh komunitas tunarungu dan orang-orang dengan kesulitan berbicara. '
                        'Dengan teknologi seperti aplikasi pendeteksi bahasa isyarat, masyarakat tunarungu dapat lebih mudah berkomunikasi dengan orang lain. '
                        'Teknologi ini mendukung pendidikan, meningkatkan kesadaran, dan menciptakan aksesibilitas untuk dunia yang lebih inklusif.',
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    context,
                    imagePath: 'assets/img/gambar4.png',
                    title: 'Mengenal Teknologi di Balik Deteksi Bahasa Isyarat',
                    content:
                        'Teknologi pendeteksi bahasa isyarat memanfaatkan kecerdasan buatan, computer vision, dan model pembelajaran mesin untuk menganalisis gerakan tangan. '
                        'Algoritma ini dirancang untuk mengenali pola gerakan dan mencocokkannya dengan database bahasa isyarat yang sudah ada. '
                        'Dengan kemajuan teknologi ini, komunikasi antara komunitas tunarungu dan masyarakat umum menjadi lebih mudah dan cepat.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a carousel item
  Widget _buildCarouselItem(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }

  // Function to build a card
  Widget _buildCard(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String content,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              imagePath,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul artikel
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Potong deskripsi hanya untuk preview
                Text(
                  content.length > 100
                      ? "${content.substring(0, 60)}..." // Ambil hanya 100 karakter pertama
                      : content, // Tampilkan semua jika kurang dari 100
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyArticleScreen(
                            title: title,
                            content: content,
                            imagePath: imagePath,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Lihat Selengkapnya", style: TextStyle(color: Colors.pink),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
