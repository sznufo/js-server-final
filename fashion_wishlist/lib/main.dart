import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2501111 전호진 기말 대체 과제',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.pink),
      home: const HomeScreen(),
    );
  }
}
