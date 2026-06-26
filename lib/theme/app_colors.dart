import 'package:flutter/material.dart';
import 'theme_controller.dart';

/// Cores que mudam dinamicamente de acordo com o tema ativo.
/// Use no lugar dos hex fixos para que o app reaja ao toggle claro/escuro.
class AppColors {
  static Color get bg =>
      isDarkMode ? const Color(0xFF0B1120) : const Color(0xFFF4F6FA);

  static Color get surface =>
      isDarkMode ? const Color(0xFF0F1E35) : const Color(0xFFFFFFFF);

  static Color get text =>
      isDarkMode ? Colors.white : const Color(0xFF1B2430);
}
