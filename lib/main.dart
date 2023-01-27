import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:language/cubit/hive_cubit.dart';
import 'package:language/cubit/local_cubit.dart';
import 'package:language/cubit/text_to_speech_cubit.dart';
import 'package:language/locator.dart';
import 'package:language/models/quiz_page_screen_agruments.dart';
import 'package:language/models/word.dart';
import 'package:language/widgets/homepage.dart';
import 'package:language/widgets/learning.dart';
import 'package:language/widgets/quizpage.dart';
import 'package:language/widgets/settings.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// flutter packages pub run build_runner build
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  setupLocator();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter('words_app');
  Hive.registerAdapter(WordAdapter());
  await Hive.openBox<Word>('words');
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocalCubit()),
        BlocProvider(create: (context) => HiveCubit()),
        BlocProvider(create: (context) => TextToSpeechCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(412, 846),
        builder: (context, child) => MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.deviceLocale,
          /*theme: ThemeData(
              textTheme: GoogleFonts.playfairDisplayTextTheme(Theme.of(context).textTheme),
              ),*/
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
          navigatorKey: navigatorKey,
          initialRoute: 'home',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case 'home':
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const HomePage(),
                );
              case 'quiz':
                QuizPageScreenArguments screenArguments = settings.arguments as QuizPageScreenArguments;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => QuizPage(id: screenArguments.id),
                );
              case 'learning':
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const MyLearning(),
                );
              case 'settings':
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const SettingsPage(),
                );
              default:
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const HomePage(),
                );
            }
          },
        ),
      ),
    );
  }
}
