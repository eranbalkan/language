import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language/cubit/hive_cubit.dart';
import 'package:language/cubit/local_cubit.dart';
import 'package:language/cubit/text_to_speech_cubit.dart';
import 'package:language/models/word.dart';
import 'package:language/theme.dart';
import 'package:language/widgets/appbar.dart';
import 'package:flip_card/flip_card.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.id});
  final String id;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  TextEditingController textEditingControllerNotes = TextEditingController();
  int i = 0;
  String activeWord = "";
  String activeWordLanguage = "";
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalCubit, LocalState>(
      builder: (context, state) {
        if (state is LocalWordsReadSuccess) {
          List<Word> words = state.words;
          i = state.counter;
          Word currentWord = words[i];
          textEditingControllerNotes.text = currentWord.notes == null ? "" : currentWord.notes.toString();
          context.read<HiveCubit>().controlWordExists(currentWord);

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(isSearchAvailable: false),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: CustomTheme.bgColor,
              ),
              child: Stack(children: [
                Card(
                  elevation: 10,
                  margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 30.h, bottom: 30.h),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        //color: Colors.blue,
                        padding: EdgeInsets.only(top: 70.h, bottom: 10.h),
                        child: FlipCard(
                          fill: Fill.fillBack,
                          direction: FlipDirection.HORIZONTAL,
                          front: _createWordContainer(currentWord, "source"),
                          back: _createWordContainer(currentWord, "target"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: Divider(
                          thickness: 2.5.h,
                        ),
                      ),
                      const ListTile(
                        title: Text(
                          "Sample sentences",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          "Notes",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: TextField(
                          maxLength: 500,
                          decoration: const InputDecoration(
                            //border: OutlineInputBorder(bor),
                            hintStyle: TextStyle(fontStyle: FontStyle.italic),
                            hintText: 'Leave a note',
                          ),
                          controller: textEditingControllerNotes,
                        ),
                      ),
                      SizedBox(
                        height: 80.h,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5.w, 15.h, 5.w, 0.h),
                        padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
                        height: 100.h,
                        width: double.infinity,
                        //color: Colors.amber,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                fixedSize: Size(100.w, 50.h),
                              ),
                              onPressed: () async {
                                if (i > 0) {
                                  await context.read<LocalCubit>().getPreviousWord(words, i);
                                }
                              },
                              child: const Icon(Icons.navigate_before),
                            ),
                            BlocBuilder<HiveCubit, HiveState>(
                              builder: (context, hiveState) {
                                if (hiveState is HiveWordExists) {
                                  return SizedBox(
                                    height: 70.0.w,
                                    width: 70.0.w,
                                    child: FittedBox(
                                      child: FloatingActionButton(
                                        heroTag: "btnRemove",
                                        backgroundColor: Colors.greenAccent,
                                        onPressed: () async {
                                          await context.read<HiveCubit>().removeWord(currentWord);
                                        },
                                        child: const Icon(Icons.remove_circle),
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    height: 70.0.w,
                                    width: 70.0.w,
                                    child: FittedBox(
                                      child: FloatingActionButton(
                                        heroTag: "btnAdd",
                                        backgroundColor: Colors.grey,
                                        onPressed: () async {
                                          currentWord.notes = textEditingControllerNotes.text.trim();
                                          await context.read<HiveCubit>().addWord(currentWord);
                                        },
                                        child: const Icon(Icons.add_circle),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                fixedSize: Size(100.w, 50.h),
                              ),
                              onPressed: () async {
                                if (i < words.length - 1) {
                                  await context.read<LocalCubit>().getNextWord(words, i);
                                }
                              },
                              child: const Icon(Icons.navigate_next),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 320.w,
                  top: 40.h,
                  child: BlocBuilder<TextToSpeechCubit, TextToSpeechState>(
                    builder: (context, ttsState) {
                      if (ttsState is PlayingState) {
                        return FloatingActionButton(
                          heroTag: "btnVolumeOn",
                          backgroundColor: Colors.grey.shade100,
                          child: const Icon(
                            Icons.volume_up,
                            color: Colors.grey,
                          ),
                          onPressed: () {},
                        );
                      } else {
                        return FloatingActionButton(
                          heroTag: "btnVolumeOff",
                          backgroundColor: Colors.grey.shade100,
                          child: const Icon(
                            Icons.volume_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            context.read<TextToSpeechCubit>().playTextToSpeech(activeWord, activeWordLanguage);
                          },
                        );
                      }
                    },
                  ),
                )
              ]),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Container _createWordContainer(Word word, String active) {
    if (active == "source") {
      activeWord = word.sourceText;
      activeWordLanguage = word.sourceLanguage;
    } else {
      activeWord = word.targetText;
      activeWordLanguage = word.targetLanguage;
    }

    return Container(
      width: 180.w,
      height: 180.w,
      decoration: BoxDecoration(
        border: Border.all(color: CustomTheme.areaBgColor),
        color: Colors.purple.shade200,
        borderRadius: BorderRadius.all(Radius.circular(8.0.w)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            activeWord,
            style: TextStyle(
              //backgroundColor: Colors.amber,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: getWordFontSize(activeWord.length),
            ),
          ),
        ],
      ),
    );
  }

  double getWordFontSize(int wordLength) {
    if (wordLength < 10) {
      return 30.w;
    } else if (wordLength >= 10 && wordLength < 15) {
      return 23.w;
    } else if (wordLength >= 15 && wordLength < 20) {
      return 20.w;
    } else if (wordLength >= 20 && wordLength < 25) {
      return 15.w;
    }
    return 10.w;
  }

  void init() async {
    await context.read<LocalCubit>().readWordsWithoutKnownWordsByKeyword(widget.id);
  }
}
