import 'package:get_it/get_it.dart';
import 'package:language/repository/hive_repository.dart';
import 'package:language/repository/local_repository.dart';
import 'package:language/services/hive_services.dart';
import 'package:language/services/local_services.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //Services
  locator.registerLazySingleton(() => LocalServices());
  locator.registerLazySingleton(() => HiveService());

  //Repositories
  locator.registerLazySingleton(() => LocalRepository());
  locator.registerLazySingleton(() => HiveRepository());
}
