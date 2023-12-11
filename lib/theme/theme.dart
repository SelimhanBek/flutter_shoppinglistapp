import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglistapp/theme/palette.dart';

final themeProvider = NotifierProvider<AppTheme, ThemeMode>(AppTheme.new);

class AppTheme extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  /// Change theme mode
  changeAppTheme({required ThemeMode mode}) {
    state = mode;
  }

  /// Elevated Button Shape
  MaterialStateProperty<OutlinedBorder?>? elevatedButtonShape({
    double radius = 18.0,
    bool isBorder = false,
  }) {
    return MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: isBorder ? const BorderSide() : BorderSide.none,
      ),
    );
  }

  /// Dark theme properties
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    scaffoldBackgroundColor: AppPalette.nightPrimary,
    //cardColor: const Color.fromARGB(255, 190, 190, 190),
    appBarTheme: const AppBarTheme(
      toolbarHeight: 60,
      centerTitle: false,
      backgroundColor: AppPalette.nightPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        textStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'Manrope',
        ),
        backgroundColor: Colors.white,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.white,
      ),
    ),
  );

  /// Light theme properties
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    scaffoldBackgroundColor: AppPalette.dayPrimary,
    //cardColor: const Color.fromARGB(255, 115, 115, 115),
    appBarTheme: const AppBarTheme(
      toolbarHeight: 60,
      centerTitle: false,
      backgroundColor: AppPalette.dayPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        textStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.black,
      ),
    ),
    useMaterial3: true,
  );
}
