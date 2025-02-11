import 'package:flutter/material.dart';

class ColorsApp {
  static ColorsApp? _instance;

  ColorsApp._();

  static ColorsApp get instance {
    _instance ??= ColorsApp._();
    return _instance!;
  }

  Color get primary => const Color(0xFF1E88E5);
  Color get secondary => const Color(0xFF43A047);
  Color get background => const Color(0xFFF5F5F5);
  Color get textDark => const Color(0xFF212121);
  Color get textLight => const Color(0xFF757575);
}

extension ColorsAppExtensions on BuildContext {
  ColorsApp get colors => ColorsApp.instance;
}
