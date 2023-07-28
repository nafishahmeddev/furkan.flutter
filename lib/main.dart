import 'dart:io';
import 'package:flutter/material.dart';
import 'package:furkan_flutter/pages/splash.page.dart';
import 'package:furkan_flutter/theme/colors.dart';
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() {
  HttpOverrides.global =  MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ThemePrimaryColor),
        scaffoldBackgroundColor: const Color.fromARGB(255, 242, 234, 216),
        appBarTheme: AppBarTheme(
          //backgroundColor: ThemePrimaryColor,
          color: ThemePrimaryColor
        ),
        useMaterial3: true
      ),
      themeMode: ThemeMode.system,
      home: const SplashPage(),
    );
  }
}


