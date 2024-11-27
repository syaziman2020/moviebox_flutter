import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moviebox_flutter/core/presentation/bloc/genre/genre_bloc.dart';
import 'package:moviebox_flutter/features/now_playing_upcoming/presentation/bloc/change_page/change_page_bloc.dart';
import 'package:moviebox_flutter/features/now_playing_upcoming/presentation/bloc/now_playing/now_playing_bloc.dart';
import 'core/constants/theme.dart';
import 'core/data/models/genre_model.dart';
import 'injection.dart';
import 'features/now_playing_upcoming/presentation/bloc/upcoming/upcoming_bloc.dart';
import 'features/now_playing_upcoming/presentation/pages/main_page.dart';

import 'core/data/models/all_movie_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //init hive
  await Hive.initFlutter();
  Hive.registerAdapter(GenreModelAdapter());
  Hive.registerAdapter(AllMovieModelAdapter());
  Hive.registerAdapter(MovieModelAdapter());

  //injection
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GenreBloc>()..add(GetGenresEvent()),
        ),
        BlocProvider(
          create: (context) => sl<NowPlayingBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<UpcomingBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<ChangePageBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: primaryColor,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          scaffoldBackgroundColor: primaryColor,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: primaryColor,
          ),
        ),
        home: MainPage(),
      ),
    );
  }
}
