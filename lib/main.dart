import 'package:flutter/material.dart';
import 'package:may_aegis/screens/splash_screen.dart';


void main() {
  runApp(const PermissionManagerApp());
}

class PermissionManagerApp extends StatelessWidget {
  const PermissionManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Permission Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}









