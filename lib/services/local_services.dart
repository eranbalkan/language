import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:language/models/word.dart';

class LocalServices {
  Future<List<Word>> readWordsFromLocalByKeyword(String key) async {
    try {
      var stringValue = await rootBundle.loadString("assets/data/$key.json");
      var jsonValue = json.decode(stringValue);
      List<Word> words = List<Word>.from(jsonValue.map((model) => Word.fromMap(model)));
      words.shuffle();
      return words;
    } catch (e) {
      debugPrint("KELİMELER LOCALDEN OKUNURKEN HATA: ${e.toString()}");
      return [];
    }
  }
}
