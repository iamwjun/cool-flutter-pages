import 'package:cool_pages/core/theme/app_theme.dart';
import 'package:cool_pages/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const QuantumLoaderApp());
}

class QuantumLoaderApp extends StatelessWidget {
  const QuantumLoaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'cool_pages',
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
