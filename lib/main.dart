// main.dart
import 'package:flutter/material.dart';
import 'screens/convertPage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: ConverterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}