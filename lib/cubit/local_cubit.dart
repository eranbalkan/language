import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language/locator.dart';
import 'package:language/models/word.dart';
import 'package:language/repository/hive_repository.dart';
import 'package:language/repository/local_repository.dart';

part 'local_state.dart';

class LocalCubit extends Cubit<LocalState> {
  LocalCubit() : super(LocalInitial());

  LocalRepository localRepository = locator<LocalRepository>();
  HiveRepository hiveRepository = locator<HiveRepository>();

  Future<void> readWordsWithoutKnownWordsByKeyword(String key) async {
    List<Word> words = await localRepository.readWordListFromLocal(key);
    List<Word> knownWords = await hiveRepository.readAllKnownWords();
    List<int> knownWordsIds = knownWords.map((element) => element.id).toList();
    List<Word> filteredLst = words.where((value) => !knownWordsIds.contains(value.id)).toList();
    if (filteredLst.isNotEmpty) {
      emit(LocalWordsReadSuccess(filteredLst, 0));
    } else {
      emit(LocalWordsReadFail());
    }
  }

  Future<void> getNextWord(List<Word> lstWord, int counter) async {
    counter = counter + 1;
    emit(LocalWordsReadSuccess(lstWord, counter));
  }

  Future<void> getPreviousWord(List<Word> lstWord, int counter) async {
    counter = counter - 1;
    emit(LocalWordsReadSuccess(lstWord, counter));
  }
}
