import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/approutes.dart';
import 'package:food_wms/screens/splash_screen.dart';
import 'package:window_manager/window_manager.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    await windowManager.setMinimumSize(const Size(512, 900));
    await windowManager.setMaximumSize(const Size(512, 900)); // Lock size
    await windowManager.setSize(const Size(512, 900)); // Set initial size
    await windowManager.center(); // Optional: center window
  }

  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nass Food WMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      //routes: {'/home': (context) => const HomeScreen()},
      routes: AppRoutes.routes,
    );
  }
}
