import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moviebox_flutter/core/data/datasources/genre_local_datasource.dart';
import 'package:moviebox_flutter/core/data/datasources/genre_remote_datasource.dart';
import 'package:moviebox_flutter/core/data/models/genre_model.dart';
import 'package:moviebox_flutter/core/data/repositories/genre_repository.dart';
import 'package:moviebox_flutter/core/domain/repositories/genre_repository.dart';
import 'package:moviebox_flutter/core/domain/usecases/get_genre_case.dart';
import 'package:moviebox_flutter/core/presentation/bloc/genre/genre_bloc.dart';
import 'package:moviebox_flutter/features/now_playing_upcoming/presentation/bloc/change_page/change_page_bloc.dart';
import 'package:moviebox_flutter/features/now_playing_upcoming/presentation/bloc/now_playing/now_playing_bloc.dart';

import 'core/data/models/all_movie_model.dart';
import 'features/now_playing_upcoming/data/datasources/movie_remote_datasource.dart';
import 'features/now_playing_upcoming/data/datasources/nowplaying_local_datasource.dart';
import 'features/now_playing_upcoming/data/datasources/upcoming_local_datasource.dart';
import 'features/now_playing_upcoming/data/repositories/movie_repository.dart';
import 'features/now_playing_upcoming/domain/repositories/movie_repository.dart';
import 'features/now_playing_upcoming/domain/usecases/get_now_playing_case.dart';
import 'features/now_playing_upcoming/domain/usecases/get_upcoming_case.dart';
import 'features/now_playing_upcoming/presentation/bloc/upcoming/upcoming_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External Dependencies
  final dio = Dio()
    ..options = BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    );
  sl.registerLazySingleton(() => dio);

  final connectivity = Connectivity();
  sl.registerLazySingleton(() => connectivity);

  // Local Storage - Hive Boxes
  final genreBox = await Hive.openBox<List<GenreModel>>('genre');
  final upcomingBox = await Hive.openBox<AllMovieModel>('upcoming_movies');
  final nowPlayingBox = await Hive.openBox<AllMovieModel>('now_playing_movies');

  // Data Sources Layer
  sl.registerLazySingleton<GenreRemoteDatasource>(
    () => GenreRemoteDatasourceImplementation(
      dio: sl<Dio>(),
    ),
  );
  sl.registerLazySingleton<MovieRemoteDatasource>(
    () => MovieRemoteDataSourceImplementation(
      dio: sl<Dio>(),
    ),
  );

  sl.registerLazySingleton<GenreLocalDatasource>(
    () => GenreLocalDatasourceImplementation(
      box: genreBox,
    ),
  );

  sl.registerLazySingleton<UpcomingLocalDatasource>(
    () => UpcomingLocalDatasourceImplementation(
      box: upcomingBox,
    ),
  );

  sl.registerLazySingleton<NowplayingLocalDatasource>(
    () => NowplayingLocalDatasourceImplementation(
      box: nowPlayingBox,
    ),
  );

  // Repository Layer
  sl.registerLazySingleton<GenreRepository>(
    () => GenreRepositoryImplementation(
      genreLocalDatasource: sl<GenreLocalDatasource>(),
      genreRemoteDatasource: sl<GenreRemoteDatasource>(),
      connectivity: sl<Connectivity>(),
    ),
  );
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImplementation(
      localUpcomingDatasource: sl<UpcomingLocalDatasource>(),
      localNowplayingDatasource: sl<NowplayingLocalDatasource>(),
      remoteDatasource: sl<MovieRemoteDatasource>(),
      connectivity: sl<Connectivity>(),
    ),
  );

  // Use Cases Layer
  sl.registerLazySingleton(() => GetGenreCase(sl<GenreRepository>()));
  sl.registerLazySingleton(() => GetUpcomingCase(
        sl<MovieRepository>(),
      ));

  sl.registerLazySingleton(() => GetNowPlayingCase(
        sl<MovieRepository>(),
      ));

  // Presentation Layer - Blocs
  sl.registerFactory(
    () => GenreBloc(
      getGenreCase: sl<GetGenreCase>(),
    ),
  );
  sl.registerFactory(
    () => NowPlayingBloc(
      getNowPlayingCase: sl<GetNowPlayingCase>(),
    ),
  );
  sl.registerFactory(
    () => UpcomingBloc(
      getUpcomingCase: sl<GetUpcomingCase>(),
    ),
  );

  sl.registerFactory(() => ChangePageBloc());
}
