import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'features/home/home_screen.dart';

void main() {
  // ProviderScope is required at the root for flutter_riverpod.
  // It holds the state of all providers used across the application.
  runApp(
    const ProviderScope(
      child: StateManagementApp(),
    ),
  );
}

class StateManagementApp extends StatelessWidget {
  const StateManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We use GetMaterialApp so that GetX features (like Get.snackbar and Get.dialog
    // without BuildContext) work out of the box, while remaining 100% compatible with
    // standard Flutter widgets and navigation.
    return GetMaterialApp(
      title: 'Flutter State Management Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
