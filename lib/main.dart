import 'dart:io';
import 'package:flutter/material.dart';
import 'package:furkan_flutter/bloc/cubut/app_cubit.dart';
import 'package:furkan_flutter/pages/main_screen.dart';
import 'package:furkan_flutter/pages/splash.page.dart';
import 'package:furkan_flutter/theme/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return BlocProvider(
      create: (_) => AppCubit(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: ThemePrimaryColor),
              //scaffoldBackgroundColor: const Color.fromARGB(255, 242, 234, 216),
              appBarTheme: AppBarTheme(
                  color: ThemePrimaryColor,
              ),
              useMaterial3: true,
              textTheme: GoogleFonts.rubikTextTheme()
          ),
          themeMode: ThemeMode.system,
          home: const MainScreen()
      ),
    );
  }
}


