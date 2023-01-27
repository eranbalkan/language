import 'package:language/locator.dart';
import 'package:language/models/word.dart';
import 'package:language/repository/hive_repository.dart';
import 'package:language/services/local_services.dart';

class LocalRepository {
  LocalServices localServices = locator<LocalServices>();

  Future<List<Word>> readWordListFromLocal(String key) async {
    List<Word> words = await localServices.readWordsFromLocalByKeyword(key);
    return words;
  }
}
