import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:furkan_flutter/pages/surah-list.page.dart';
import 'package:furkan_flutter/theme/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);




  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: ThemePrimaryColor,
      ),
      themeMode: ThemeMode.system,
      home: const SurahListPage(),
    );
  }
}

