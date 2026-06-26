import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'theme/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EventosEsportivosApp());
}

class EventosEsportivosApp extends StatelessWidget {
  const EventosEsportivosApp({super.key});

  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1565C0),
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF1565C0),
      secondary: const Color(0xFFF9A825),
      surface: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFF1B2430),
    ),
    scaffoldBackgroundColor: const Color(0xFFF4F6FA),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF4F6FA),
      foregroundColor: Color(0xFF1B2430),
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: const Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: const Color(0xFF1B2430).withOpacity(0.06)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFFFFFF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFF1B2430).withOpacity(0.1)),
      ),
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1565C0),
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF2979FF),
      secondary: const Color(0xFFF9A825),
      surface: const Color(0xFF0F1E35),
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF0B1120),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0B1120),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: const Color(0xFF0F1E35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF0F1E35),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                mode == ThemeMode.dark ? Brightness.light : Brightness.dark,
            systemNavigationBarColor: mode == ThemeMode.dark
                ? const Color(0xFF0B1120)
                : const Color(0xFFF4F6FA),
            systemNavigationBarIconBrightness:
                mode == ThemeMode.dark ? Brightness.light : Brightness.dark,
          ),
        );
        return MaterialApp(
          title: 'Championships App',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: _lightTheme,
          darkTheme: _darkTheme,
          home:  HomeScreen(),
        );
      },
    );
  }
}
