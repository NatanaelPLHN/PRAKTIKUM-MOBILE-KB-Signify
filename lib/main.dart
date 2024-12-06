import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pa_mobile_1/screens/bantuan_screen.dart';
import 'package:pa_mobile_1/screens/camera_screen.dart';
import 'package:pa_mobile_1/screens/home_screen.dart';
import 'package:pa_mobile_1/screens/login_screen.dart';
import 'package:pa_mobile_1/screens/onboarding_screen.dart';
import 'package:pa_mobile_1/screens/profile_screen.dart';
import 'package:pa_mobile_1/screens/register_screen.dart';
import 'package:pa_mobile_1/screens/settings_screen.dart';
import 'package:pa_mobile_1/screens/tentang_screen.dart';
import 'package:pa_mobile_1/theme/theme.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:pa_mobile_1/user_provider.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterVision vision;

  @override
  void initState() {
    super.initState();
    vision = FlutterVision(); // Ensure vision is initialized immediately
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _requestPermissions(); // Request permissions asynchronously
    // Any other asynchronous setup tasks can go here
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  @override
  void dispose() async {
    await vision.closeYoloModel(); // Clean up vision resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeProvider.themeNotifier,
      builder: (context, currentTheme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeProvider.lightTheme,
          darkTheme: ThemeProvider.darkTheme,
          themeMode: currentTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => const MyOnboardingScreen(),
            '/welcome': (context) => const MyWelcomeScreen(),
            '/login': (context) => const MyLoginScreen(),
            '/register': (context) => const MyRegisterScreen(),
            '/home': (context) => const MyHomeScreen(),
            '/camera': (context) => MyCameraScreen(vision: vision),
            '/settings': (context) => const MySettingsScreen(),
            '/scan': (context) => ScanImage(vision: vision),
            '/profile': (context) => const MyProfileScreen(),
            '/about': (context) => const MyAboutScreen(),
            '/help': (context) => const MyHelpScreen(),
          },
        );
      },
    );
  }
}