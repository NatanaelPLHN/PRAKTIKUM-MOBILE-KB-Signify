import 'package:flutter/material.dart';

class ThemeProvider {
  // ValueNotifier untuk memantau perubahan tema
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.pink,
    colorScheme: const ColorScheme.light(
      secondary: Colors.black,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.pink,
    colorScheme: const ColorScheme.dark(
      secondary: Colors.white,
    ),
  );

  // Fungsi untuk toggle tema
  static void toggleTheme() {
    themeNotifier.value =
        themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
