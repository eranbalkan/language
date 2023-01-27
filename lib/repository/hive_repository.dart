import 'package:language/locator.dart';
import 'package:language/menu_organizer.dart';
import 'package:language/models/word.dart';
import 'package:language/repository/local_repository.dart';
import 'package:language/services/hive_services.dart';

class HiveRepository {
  HiveService hiveService = locator<HiveService>();
  LocalRepository localRepository = locator<LocalRepository>();

  Future<bool> addWord(Word word) async {
    bool isOk = await hiveService.addWord(word);
    return Future.value(isOk);
  }

  Future<bool> removeWord(Word word) async {
    bool isOk = await hiveService.removeWord(word);
    return Future.value(isOk);
  }

  Future<List<Word>> readAllKnownWords() async {
    List<Word> lstWord = await hiveService.readAllKnownWords();
    return Future.value(lstWord);
  }

  Future<Map<String, double>> readAllKnownWordsPercent() async {
    Map<String, double> resultMap = {};
    for (var menuItem in MenuOrginizer.homePageMenu) {
      List<Word> list = await localRepository.readWordListFromLocal(menuItem["keyword"]);
      double percent = await hiveService.calculatePercent(list);
      resultMap[menuItem["keyword"]] = percent;
    }
    return Future.value(resultMap);
  }
}
