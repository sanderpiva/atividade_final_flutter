import 'package:finalexemplo/app/core/colors_extension.dart';
import 'package:finalexemplo/app/pages/combustivel_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Radar do Combustível',
      theme: ThemeData(
        primaryColor: ColorsApp.instance.primary,
        scaffoldBackgroundColor: ColorsApp.instance.background,
      ),
      home: const CombustivelApp(),
    );
  }
}
