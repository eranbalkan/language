part of 'text_to_speech_cubit.dart';

@immutable
abstract class TextToSpeechState {}

class TextToSpeechInitial extends TextToSpeechState {}

class PlayingState extends TextToSpeechState {}

class StopedState extends TextToSpeechState {}
