import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'settings_page.dart';
import 'theme_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ffi loader if necessary
  sqfliteFfiInit();

  // Change the default factory to FFI
  databaseFactory = databaseFactoryFfi;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Notes App',
          theme: ThemeData.light(), // Light theme
          darkTheme: ThemeData.dark(), // Dark theme
          themeMode: themeProvider.themeMode, // Toggle between light and dark
          debugShowCheckedModeBanner: false, // Disable the debug banner
          home: LoginPage(),
          routes: {
            '/settings': (context) => SettingsPage(),
          },
        );
      },
    );
  }
}
