import 'package:flutter/material.dart';
import 'package:internet_cafe_flutter/screen/navigation_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Internet Cafe App',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 147, 229, 250),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 0, 0, 0),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 9, 20, 59),
      ),
      home: const NavigationScreen(), // Set the home to StockScreen
    );
  }
}
