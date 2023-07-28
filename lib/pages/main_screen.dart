import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furkan_flutter/bloc/cubut/app_cubit.dart';
import 'package:furkan_flutter/pages/splash.page.dart';
import 'package:furkan_flutter/pages/surah-list.page.dart';

class MainScreen extends StatelessWidget{
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(builder: (context, state){
      if(state.isInitialized){
        return const SurahListPage();
      } else {
        return const SplashPage();
      }
    });
  }

}