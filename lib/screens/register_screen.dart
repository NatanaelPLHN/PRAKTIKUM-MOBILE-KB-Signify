import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pa_mobile_1/auth.dart'; // Import the authentication service

class MyRegisterScreen extends StatefulWidget {
  const MyRegisterScreen({super.key});

  @override
  State<MyRegisterScreen> createState() => _MyRegisterScreenState();
}

class _MyRegisterScreenState extends State<MyRegisterScreen> {
  bool _agreeToTerms = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg1.jpeg"),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        child: _buildRegisterForm(),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      height: 500,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(15),
        color: Colors.black.withOpacity(0.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Center(child: Text("Register", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
                const Spacer(),
                _buildTextField("Username", Icons.account_circle_rounded, controller: _usernameController),
                const Spacer(),
                _buildTextField("Email", Icons.mail, controller: _emailController),
                const Spacer(),
                _buildTextField("Password", Icons.lock, obscureText: true, controller: _passwordController),
                const Spacer(),
                _buildAgreeToTermsCheckbox(),
                const Spacer(),
                _buildRegisterButton(),
                const Spacer(),
                _buildRegisterLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {bool obscureText = false, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        Container(
          height: 35,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white)),
          ),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            obscureText: obscureText,
            decoration: InputDecoration(
              suffixIcon: Icon(icon, color: Colors.white),
              fillColor: Colors.white,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgreeToTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          checkColor: Colors.white,
          activeColor: const Color.fromARGB(255, 27, 35, 51),
          onChanged: (bool? value) {
            setState(() {
              _agreeToTerms = value ?? false;
            });
          },
        ),
        const SizedBox(width: 10),
        const Expanded(child: Text("Saya setuju dengan syarat dan ketentuan", style: TextStyle(color: Colors.white))),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return GestureDetector(
      onTap: () async {
        if (_agreeToTerms) {
          String username = _usernameController.text;
          String email = _emailController.text;
          String password = _passwordController.text;

          var user = await _authService.registerWithEmailPassword(email, password, username);
          if (user != null) {
            // Show success alert with SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registrasi berhasil!', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate to home screen
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registrasi gagal')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Anda harus setuju dengan S&K')),
          );
        }
      },
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: const Text("Register", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: const Text('Sudah punya akun? Masuk', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
