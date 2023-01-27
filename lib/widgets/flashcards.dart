import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language/cubit/hive_cubit.dart';
import 'package:language/main.dart';
import 'package:language/menu_organizer.dart';
import 'package:language/models/quiz_page_screen_agruments.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FlashCards extends StatefulWidget {
  const FlashCards({super.key});

  @override
  State<FlashCards> createState() => _FlashCardsState();
}

class _FlashCardsState extends State<FlashCards> {
  @override
  Widget build(BuildContext context) {
    context.read<HiveCubit>().readAllKnownWordsPercent();

    return ListView.builder(
      itemCount: MenuOrginizer.homePageMenu.length,
      itemBuilder: (context, index) {
        return _buildFlashCards(
            context, MenuOrginizer.homePageMenu[index], index < MenuOrginizer.homePageMenuColors.length ? index : index % MenuOrginizer.homePageMenuColors.length);
      },
    );
  }

  Widget _buildFlashCards(BuildContext context, Map<String, dynamic> mapMenu, int index) {
    Color color = MenuOrginizer.homePageMenuColors[index];
    String keyword = mapMenu["keyword"];
    String name = mapMenu["name"];

    return GestureDetector(
      onTap: () {
        navigatorKey.currentState?.pushNamed('quiz', arguments: QuizPageScreenArguments(keyword)).whenComplete(() => setState(() {}));
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 10.h, left: 15.w, right: 15.w, top: 10.h),
        elevation: 5,
        shadowColor: color,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: const [0.02, 0.02],
              colors: [color, Colors.white],
            ),
            borderRadius: BorderRadius.all(Radius.circular(5.0.w)),
          ),
          height: 100.h,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 15.w, bottom: 5.h, top: 5.h),
                  //color: Colors.amber,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        name,
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/flag_usa.png",
                            width: 30.w,
                            height: 30.h,
                          ),
                          Icon(
                            size: 20.w,
                            Icons.repeat_rounded,
                            color: Colors.grey,
                          ),
                          Image.asset(
                            "assets/images/flag_tr.png",
                            width: 30.w,
                            height: 30.h,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                //color: Colors.blue,
                width: 100.w,
                child: BlocBuilder<HiveCubit, HiveState>(
                  buildWhen: (previous, current) {
                    if (current is HiveReadKnownWordsPercentSuccess || current is HiveReading) {
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    if (state is HiveReadKnownWordsPercentSuccess) {
                      double percent = state.mapResult[keyword]!;
                      return CircularPercentIndicator(
                        radius: 40.0.w,
                        lineWidth: 10.0.w,
                        animation: true,
                        animationDuration: 1500,
                        percent: percent,
                        center: Text(
                          "${(percent * 100.0).toStringAsFixed(2)}%",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.5.w),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: color,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
