import 'package:flutter/material.dart';
import 'package:tracer/screens/tracer_home_screen.dart';

void main() {
  runApp(const TracerApp());
}


class TracerApp extends StatelessWidget {
  const TracerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Tracer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0F1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFF00E5FF),
          surface: Color(0xFF151829),
        ),
      ),
      home: const TracerHomeScreen(),
    );
  }
}
