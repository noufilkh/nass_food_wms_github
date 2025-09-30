import 'package:flutter/material.dart';

class AppTheme {
  static const MaterialColor primaryColor = Colors.deepOrange;
  static const MaterialColor accentColor = Colors.amber;
  static const Color textColor = Colors.black87;
  static const Color backgroundColor = Colors.white;
  static const Color errorColor = Colors.red;
  static const Color gridsavebuttoncolor = Color.fromARGB(255, 174, 126, 3);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    hintColor: Colors.grey,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
    ),
    //AppBarTheme
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(color: backgroundColor, size: 26),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    //elevatedButtonTheme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        textStyle: const TextStyle(
          fontSize: 18,
          color: backgroundColor,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),
    //inputDecorationTheme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: accentColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      prefixIconColor: primaryColor,
      suffixIconColor: primaryColor.shade400,
      labelStyle: TextStyle(
        color: const Color.fromARGB(255, 165, 165, 164),
        fontSize: 13,
      ),
      floatingLabelStyle: TextStyle(color: primaryColor),
    ),

    listTileTheme: ListTileThemeData(
      titleTextStyle: TextStyle(color: primaryColor),
      subtitleTextStyle: TextStyle(color: Color.fromARGB(255, 174, 126, 3)),
      iconColor: primaryColor,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      bodyMedium: TextStyle(fontSize: 12.0, color: primaryColor),
      labelLarge: TextStyle(
        fontSize: 14.0,
        color: primaryColor,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        fontSize: 13.0,
        color: Color.fromARGB(255, 174, 126, 3),
      ),
      titleSmall: TextStyle(
        fontSize: 12.0,
        color: primaryColor,
        fontWeight: FontWeight.bold,
      ),

      labelSmall: TextStyle(
        fontSize: 12.0,
        color: Color.fromARGB(255, 152, 150, 150),
      ),
      //Used for textformfield
      titleMedium: TextStyle(
        fontSize: 15.0,
        color: Color.fromARGB(255, 152, 150, 150),
      ),
    ),
    cardTheme: CardThemeData(
      color: Color.fromARGB(255, 244, 243, 243),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: accentColor.shade100,
          width: 1.0, // Border thickness
        ),
        borderRadius: BorderRadius.circular(12), // Optional rounded corners
      ),
    ),
    iconTheme: const IconThemeData(color: accentColor, size: 24.0),

    // Define other theme properties like iconTheme, inputDecorationTheme, etc.
  );

  // You can also define a dark theme if needed
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.indigo,
    hintColor: Colors.grey[600],
    scaffoldBackgroundColor: Colors.grey[900],
    colorScheme: ColorScheme.dark(
      primary: Colors.indigo,
      secondary: Colors.tealAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.indigo,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(fontSize: 16.0, color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),
  );
}
