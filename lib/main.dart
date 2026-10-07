import 'package:flutter/material.dart';
import 'data/property_data.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const RealEstateApp());
}

/// Root widget of the Real Estate Property Finder application.
class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Estate Property Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: HomeScreen(properties: sampleProperties),
    );
  }
}
