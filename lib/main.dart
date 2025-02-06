import 'package:flutter/material.dart';
import 'package:may_aegis/screens/splash_screen.dart';

void main() {
  runApp(const MayAegis());
}

class MayAegis extends StatelessWidget {
  const MayAegis({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'May Aegis',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
