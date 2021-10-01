import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplenote/UI/constants/constants.dart';
import 'package:simplenote/UI/screens/home.dart';
import 'package:simplenote/UI/style/style.dart';
import 'package:simplenote/core/bloc/my_bloc_observer.dart';
import 'package:simplenote/core/bloc/note_cubit/note_cubit.dart';
import 'package:simplenote/core/bloc/note_states/note_states.dart';
import 'package:simplenote/core/helper/cache_data.dart';
import 'package:simplenote/core/helper/db_helper.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheData.init();
  await DatabaseHelper.database();
  if (CacheData.getBool('isDark') != null) {
    kIsDark = CacheData.getBool('isDark')!;
  }
  if (CacheData.getBool('isNotFirst') != null) {
    isNotFirst = CacheData.getBool('isNotFirst')!;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteCubit>(
        create: (context) => NoteCubit()
          ..getNotes()
          ..changeTheme(fromShared: kIsDark),
        child: BlocConsumer<NoteCubit, NoteStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = NoteCubit.get(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
              theme: cubit.isDark ? darkMode : lightMode,
              home: isNotFirst
                  ? Home()
                  : AnimatedSplashScreen(
                      splash: kIcon,
                      animationDuration: Duration(seconds: 2),
                      splashTransition: SplashTransition.rotationTransition,
                      nextScreen: Builder(builder: (context) {
                        CacheData.setBool('isNotFirst', true);
                        return Home();
                      }),
                    ),
            );
          },
        ));
  }
}
