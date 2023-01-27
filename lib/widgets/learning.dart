import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language/cubit/hive_cubit.dart';
import 'package:language/cubit/text_to_speech_cubit.dart';
import 'package:language/custom_snack_bar.dart';
import 'package:language/models/word.dart';
import 'package:language/theme.dart';
import 'package:language/widgets/appbar.dart';
import 'package:language/widgets/drawer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyLearning extends StatefulWidget {
  const MyLearning({super.key});

  @override
  State<MyLearning> createState() => _MyLearningState();
}

class _MyLearningState extends State<MyLearning> {
  @override
  Widget build(BuildContext context) {
    context.read<HiveCubit>().readAllKnownWords();

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(isSearchAvailable: true, title: "My Learning"),
      body: BlocBuilder<HiveCubit, HiveState>(
        builder: (context, hiveState) {
          if (hiveState is HiveReading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (hiveState is HiveReadKnownWordsSuccess) {
            List<Word> list = hiveState.lstWord;
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                  width: 100.w,
                  child: CircularPercentIndicator(
                    radius: 40.0.w,
                    lineWidth: 10.0.w,
                    animation: false,
                    percent: 1,
                    center: Text(
                      list.length.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0.w),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: CustomTheme.areaBgColor.withAlpha(70),
                  ),
                ),
                Text(
                  "wordsLearned",
                  style: TextStyle(
                    fontSize: 20.w,
                    fontWeight: FontWeight.bold,
                  ),
                ).tr(),
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
                                actions: <Widget>[
                                  TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("delete").tr()),
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
      ),
    );
  }
}
