part of 'hive_cubit.dart';

@immutable
abstract class HiveState {}

class HiveInitial extends HiveState {}

class HiveWordExists extends HiveState {}

class HiveWordNotExists extends HiveState {}

class HiveReading extends HiveState {}

class HiveReadKnownWordsSuccess extends HiveState {
  final List<Word> lstWord;

  HiveReadKnownWordsSuccess({required this.lstWord});
}

class HiveReadKnownWordsFail extends HiveState {}

class HiveReadKnownWordsPercentSuccess extends HiveState {
  final Map<String, double> mapResult;

  HiveReadKnownWordsPercentSuccess({required this.mapResult});
}
