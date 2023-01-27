import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:language/models/word.dart';

class HiveService {
  Future<bool> addWord(Word word) async {
    try {
      var box = Hive.box<Word>('words');
      box.put(word.id, word);
      return Future.value(true);
    } catch (e) {
      debugPrint("HIVE'E KELİME EKLERKEN HATA: ${e.toString()}");
      return Future.value(false);
    }
  }

  Future<bool> removeWord(Word word) async {
    try {
      var box = Hive.box<Word>('words');
      box.delete(word.id);
      return Future.value(true);
    } catch (e) {
      debugPrint("HIVE'E KELİME EKLERKEN HATA: ${e.toString()}");
      return Future.value(false);
    }
  }

  Future<List<Word>> readAllKnownWords() async {
    try {
      var box = Hive.box<Word>('words');
      return Future.value(box.values.toList());
    } catch (e) {
      debugPrint("HIVE'DEN OKUNURKEN HATA: ${e.toString()}");
      return Future.value([]);
    }
  }

  Future<double> calculatePercent(List<Word> lstWord) async {
    double percent = 0;
    try {
      var box = Hive.box<Word>('words');
      List<Word> list = box.values.toList();
      List<int> lstIds = lstWord.map((element) => element.id).toList();
      var minId = lstIds.reduce(min);
      var maxId = lstIds.reduce(max);

      var cnt = list.where((element) => element.id >= minId && element.id <= maxId).length;
      percent = cnt / lstWord.length;
      return Future.value(percent);
    } catch (e) {
      debugPrint("calculatePercent HIVE'DEN OKUNURKEN HATA: ${e.toString()}");
      return Future.value(percent);
    }
  }
}
