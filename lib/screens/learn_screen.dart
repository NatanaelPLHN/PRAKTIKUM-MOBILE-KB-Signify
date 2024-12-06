import 'package:flutter/material.dart';

class MyLearnScreen extends StatelessWidget {
  const MyLearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Introduction Section
              const Text(
                'Selamat datang di pembelajaran bahasa isyarat !',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pelajari dasar-dasar bahasa isyarat dan mulailah berkomunikasi dengan mudah. '
                'Di bagian ini, Anda akan menemukan alat bantu visual dan penjelasan singkat tentang isyarat tangan yang umum.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),

              // Section for Learning Cards
              GridView.count(
                crossAxisCount: 2, // 2 cards per row
                shrinkWrap: true,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildLearnCard(
                    context,
                    title: 'A - American Sign Language',
                    subtitle: 'Learn how to sign the letter "A".',
                    circleText: 'A',
                    imagePath: 'assets/img/0.jpg',
                  ),
                  _buildLearnCard(
                    context,
                    title: 'B - American Sign Language',
                    subtitle: 'Learn how to sign the letter "B".',
                    circleText: 'B',
                    imagePath: 'assets/img/1.jpg',
                  ),
                  _buildLearnCard(
                    context,
                    title: 'C - American Sign Language',
                    subtitle: 'Learn how to sign the letter "C".',
                    circleText: 'C',
                    imagePath: 'assets/img/2.jpg',
                  ),
                  _buildLearnCard(
                    context,
                    title: 'D - American Sign Language',
                    subtitle: 'Learn how to sign the letter "D".',
                    circleText: 'D',
                    imagePath: 'assets/img/3.jpg',
                  ),
                  _buildLearnCard(
                    context,
                    title: 'E - American Sign Language',
                    subtitle: 'Learn how to sign the letter "E".',
                    circleText: 'E',
                    imagePath: 'assets/img/4.jpg',
                  ),
                  _buildLearnCard(
                    context,
                    title: 'F - American Sign Language',
                    subtitle: 'Learn how to sign the letter "F".',
                    circleText: 'F',
                    imagePath: 'assets/img/5.jpg',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create a learning card
  Widget _buildLearnCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String circleText,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () {
        _showPopupCard(
          context,
          title: title,
          subtitle: subtitle,
          circleText: circleText,
          imagePath: imagePath,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),
            // Circle with text
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    circleText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            // Text content
            Positioned(
              bottom: 15,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the popup card
  void _showPopupCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String circleText,
    required String imagePath,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: AspectRatio(
            aspectRatio: 3 / 4, // 4:3 aspect ratio
            child: Stack(
              children: [
                // Background image
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Circle with text
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        circleText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                // Title and Subtitle
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                // Close Button
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
