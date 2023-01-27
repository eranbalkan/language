import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:language/locator.dart';
import 'package:language/models/word.dart';
import 'package:language/repository/hive_repository.dart';
part 'hive_state.dart';

class HiveCubit extends Cubit<HiveState> {
  HiveCubit() : super(HiveInitial());

  HiveRepository hiveRepository = locator<HiveRepository>();
  Future<void> addWord(Word word) async {
    bool isOk = await hiveRepository.addWord(word);
    if (isOk) {
      emit(HiveWordExists());
    } else {
      emit(HiveWordNotExists());
    }
  }

  Future<void> removeWord(Word word) async {
    bool isOk = await hiveRepository.removeWord(word);
    if (isOk) {
      emit(HiveWordNotExists());
    } else {
      emit(HiveWordExists());
    }
  }

  Future<void> controlWordExists(Word word) async {
    List<Word> lstWord = await hiveRepository.readAllKnownWords();
    bool isExists = lstWord.any((element) => element.id == word.id);
    if (isExists) {
      emit(HiveWordExists());
    } else {
      emit(HiveWordNotExists());
    }
  }

  Future<void> readAllKnownWords() async {
    emit(HiveReading());
    List<Word> lstWord = await hiveRepository.readAllKnownWords();
    if (lstWord.isNotEmpty) {
      emit(HiveReadKnownWordsSuccess(lstWord: lstWord));
    } else {
      emit(HiveReadKnownWordsFail());
    }
  }

  Future<void> readAllKnownWordsPercent() async {
    emit(HiveReading());
    Map<String, double> mapResult = await hiveRepository.readAllKnownWordsPercent();
    if (mapResult.isNotEmpty) {
      emit(HiveReadKnownWordsPercentSuccess(mapResult: mapResult));
    } else {
      emit(HiveReadKnownWordsFail());
    }
  }

  Future<void> readAllKnownWordsByQueryFilter(String query) async {
    emit(HiveReading());
    List<Word> lstWord = await hiveRepository.readAllKnownWords();
    if (lstWord.isNotEmpty) {
      lstWord = lstWord.where((element) => element.sourceText.toLowerCase().contains(query.toLowerCase())).toList();
      emit(HiveReadKnownWordsSuccess(lstWord: lstWord));
    } else {
      emit(HiveReadKnownWordsFail());
    }
  }
}
