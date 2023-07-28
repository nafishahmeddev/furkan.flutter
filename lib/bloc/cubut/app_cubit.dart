import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:furkan_flutter/models/surah.model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AppState{
  List<Surah>? surahs;
  bool isInitialized = false;
}
class AppCubit extends Cubit<AppState>{
  AppCubit() : super(AppState());
  void setSurahs(List<Surah> surahs) async {
    state.surahs = surahs;
    state.isInitialized = true;
    emit(state);
  }
}