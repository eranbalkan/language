import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
part 'text_to_speech_state.dart';

class TextToSpeechCubit extends Cubit<TextToSpeechState> {
  TextToSpeechCubit() : super(TextToSpeechInitial());

  final FlutterTts flutterTts = FlutterTts();
  Future<void> playTextToSpeech(String text, String language) async {
    String speechLanguage = "en-US";
    if (language == "tr") {
      speechLanguage = "tr-TR";
    }

    try {
      emit(PlayingState());
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.setLanguage(speechLanguage);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(text);
      emit(StopedState());
    } catch (e) {
      debugPrint("playTextToSpeech HATA-> ${e.toString()}");
    }
  }
}
