import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language/cubit/hive_cubit.dart';
import 'package:language/cubit/text_to_speech_cubit.dart';
import 'package:language/custom_snack_bar.dart';
import 'package:language/models/word.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, context.read<HiveCubit>().readAllKnownWords());
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    /*if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }*/
    context.read<HiveCubit>().readAllKnownWordsByQueryFilter(query);
    return BlocBuilder<HiveCubit, HiveState>(
      builder: (context, hiveState) {
        if (hiveState is HiveReading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (hiveState is HiveReadKnownWordsSuccess) {
          List<Word> list = hiveState.lstWord;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    Word currentWord = list[index];
                    return Dismissible(
                      secondaryBackground: Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.delete, color: Colors.white),
                              const Text('movetotrash', style: TextStyle(color: Colors.white)).tr(),
                            ],
                          ),
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("deleteConfirmation").tr(),
                              content: const Text("deleteConfirmationQuestionText").tr(),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text("delete").tr(),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("cancel").tr(),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) async {
                        await context.read<HiveCubit>().removeWord(currentWord);
                        await context.read<HiveCubit>().readAllKnownWords();
                        CustomSnackBar(context, Text("${currentWord.sourceText} " + "deleted".tr()));
                      },
                      background: Container(color: Colors.red),
                      key: Key(currentWord.id.toString()),
                      child: Card(
                        child: ExpansionTile(
                          title: Text(currentWord.sourceText, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(currentWord.targetText),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10.w),
                                child: GestureDetector(
                                  onTap: () async {
                                    context.read<TextToSpeechCubit>().playTextToSpeech(currentWord.sourceText, currentWord.sourceLanguage);
                                  },
                                  child: const Icon(
                                    Icons.volume_up,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("deleteConfirmation").tr(),
                                        content: const Text("deleteConfirmationQuestionText").tr(),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () async {
                                                await context.read<HiveCubit>().removeWord(currentWord);
                                                await context.read<HiveCubit>().readAllKnownWords();
                                                CustomSnackBar(context, Text("${currentWord.sourceText} " + "deleted".tr()));
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text("delete").tr()),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text("cancel").tr(),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h, bottom: 5.h),
                              width: double.infinity,
                              color: Colors.grey.shade200,
                              child: Text(currentWord.notes == null ? "" : currentWord.notes!.toString()),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: list.length,
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
