import 'package:flutter/material.dart';
import 'package:furkan_flutter/pages/splash.page.dart';
import 'package:furkan_flutter/theme/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: ThemePrimaryColor,
        scaffoldBackgroundColor: const Color.fromARGB(255, 242, 234, 216),
        useMaterial3: true
      ),
      themeMode: ThemeMode.system,
      home: const SplashPage(),
    );
  }
}


