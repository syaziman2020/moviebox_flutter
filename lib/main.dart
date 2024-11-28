import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/presentation/bloc/genre/genre_bloc.dart';
import 'features/favorite_movies/data/models/favorite_local_movie.dart';
import 'features/favorite_movies/presentation/bloc/add_favorite/add_favorite_bloc.dart';
import 'features/favorite_movies/presentation/bloc/get_favorites/get_favorites_bloc.dart';
import 'features/favorite_movies/presentation/bloc/status_favorite/status_favorite_bloc.dart';
import 'features/now_playing_upcoming/presentation/bloc/change_page/change_page_bloc.dart';
import 'features/now_playing_upcoming/presentation/bloc/now_playing/now_playing_bloc.dart';
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
  Hive.registerAdapter(FavoriteLocalMovieAdapter());

  //injection
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        BlocProvider(
          create: (context) => sl<GetFavoritesBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<StatusFavoriteBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<AddFavoriteBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
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
