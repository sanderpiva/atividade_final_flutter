import 'package:flutter/material.dart';

class TextStyles {
  static TextStyles? _instance;

  TextStyles._();
  static TextStyles get instance {
    _instance ??= TextStyles._();
    return _instance!;
  }

  TextStyle get textRegular => const TextStyle(fontWeight: FontWeight.normal, fontSize: 16);
  TextStyle get textMedium => const TextStyle(fontWeight: FontWeight.w500, fontSize: 18);
  TextStyle get textBold => const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  TextStyle get textTitle => const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black);
}

extension TextStylesExtensions on BuildContext {
  TextStyles get textStyles => TextStyles.instance;
}
