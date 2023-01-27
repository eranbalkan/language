// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'local_cubit.dart';

@immutable
abstract class LocalState {}

class LocalInitial extends LocalState {}

class LocalWordsReadSuccess extends LocalState {
  final List<Word> words;
  final int counter;
  LocalWordsReadSuccess(
    this.words,
    this.counter,
  );
}

class LocalWordsReadFail extends LocalState {}
