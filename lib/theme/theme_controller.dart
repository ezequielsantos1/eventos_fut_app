import 'package:flutter/material.dart';

/// Notifier global que controla o tema do app (claro/escuro).
/// Qualquer widget pode ouvir ou alterar esse valor.
final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.light);

void toggleTheme() {
  themeModeNotifier.value = themeModeNotifier.value == ThemeMode.dark
      ? ThemeMode.light
      : ThemeMode.dark;
}

bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;
