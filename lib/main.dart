import 'package:flutter/material.dart';
import 'package:may_aegis/screens/splash_screen.dart';

void main() {
  runApp(const MayAegis());
}

class MayAegis extends StatelessWidget {
  const MayAegis({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'May Aegis',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromRGBO(65, 7, 56, 1)),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
