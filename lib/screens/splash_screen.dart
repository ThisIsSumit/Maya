import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:may_aegis/screens/home_screen.dart';
import 'package:may_aegis/screens/navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => NavigationScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.security,
              size: 100,
              color: Theme.of(context).primaryColor,
            ).animate()
              .fadeIn(duration: 600.ms)
              .scale(delay: 400.ms)
              .then()
              .shake(delay: 200.ms),
            const SizedBox(height: 20),
            Text(
              'Permission Manager',
              style: Theme.of(context).textTheme.headlineMedium,
            ).animate()
              .fadeIn(delay: 800.ms)
              .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}