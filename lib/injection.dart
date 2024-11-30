import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/movie_detail/data/datasources/detail_local_datasource.dart';
import 'features/movie_detail/data/datasources/detail_remote_datasource.dart';
import 'features/movie_detail/data/models/detail_model.dart';
import 'features/movie_detail/data/repositories/detail_repository.dart';
import 'features/movie_detail/domain/repositories/detail_repository.dart';
import 'features/movie_detail/domain/usecases/get_detail_case.dart';
import 'features/movie_detail/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'features/movie_discover/data/datasources/discover_remote_datasource.dart';
import 'features/movie_discover/data/repositories/discover_repository.dart';
import 'features/movie_discover/domain/usecases/get_discover_sortby_case.dart';
import 'features/movie_discover/domain/usecases/get_search_discover_case.dart';
import 'features/movie_discover/presentation/bloc/discover/discover_bloc.dart';
import 'core/data/datasources/genre_local_datasource.dart';
import 'core/data/datasources/genre_remote_datasource.dart';
import 'core/data/models/genre_model.dart';
import 'core/data/repositories/genre_repository.dart';
import 'core/domain/repositories/genre_repository.dart';
import 'core/domain/usecases/get_genre_case.dart';
import 'core/presentation/bloc/genre/genre_bloc.dart';
import 'features/favorite_movies/data/datasources/favorite_local_datasource.dart';
import 'features/favorite_movies/data/datasources/favorite_remote_datasource.dart';
import 'features/favorite_movies/data/repositories/favorite_repository.dart';
import 'features/favorite_movies/domain/repositories/favorite_repository.dart';
import 'features/favorite_movies/domain/usecases/add_favorite_case.dart';
import 'features/favorite_movies/domain/usecases/get_favorite_case.dart';
import 'features/favorite_movies/presentation/bloc/add_favorite/add_favorite_bloc.dart';
import 'features/favorite_movies/presentation/bloc/get_favorites/get_favorites_bloc.dart';
import 'features/favorite_movies/presentation/bloc/status_favorite/status_favorite_bloc.dart';
import 'features/movie_discover/domain/repositories/discover_repository.dart';
import 'features/now_playing_upcoming/presentation/bloc/change_page/change_page_bloc.dart';
import 'features/now_playing_upcoming/presentation/bloc/now_playing/now_playing_bloc.dart';

import 'core/data/models/all_movie_model.dart';
import 'features/favorite_movies/data/datasources/add_favorite_local_datasource.dart';
import 'features/favorite_movies/data/models/favorite_local_movie.dart';
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
      connectTimeout: const Duration(seconds: 7),
      receiveTimeout: const Duration(seconds: 7),
    );
  sl.registerLazySingleton(() => dio);

  final connectivity = Connectivity();
  sl.registerLazySingleton(() => connectivity);

  // Local Storage - Hive Boxes
  final genreBox = await Hive.openBox('genre');
  final upcomingBox = await Hive.openBox<AllMovieModel>('upcoming_movies');
  final nowPlayingBox = await Hive.openBox<AllMovieModel>('now_playing_movies');
  final getFavoritesBox = await Hive.openBox<AllMovieModel>('favorites_movies');
  final statusFavoritesBox =
      await Hive.openBox<FavoriteLocalMovie>('status_favorites');
  final detailBox = await Hive.openBox<DetailModel>('detail_movies');

  // Data Sources Layer
  //remote datasource
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
  sl.registerLazySingleton<FavoriteRemoteDatasource>(
    () => FavoriteRemoteDatasourceImplementation(
      dio: sl<Dio>(),
    ),
  );
  sl.registerLazySingleton<DetailRemoteDatasource>(
    () => DetailRemoteDatasourceImplementation(
      dio: sl<Dio>(),
    ),
  );
  sl.registerLazySingleton<DiscoverRemoteDatasource>(
    () => DiscoverRemoteDatasourceImplementation(
      dio: sl<Dio>(),
    ),
  );

  //local datasource
  sl.registerLazySingleton<GenreLocalDatasource>(
    () => GenreLocalDatasourceImplementation(
      box: genreBox,
    ),
  );
  sl.registerLazySingleton<FavoriteLocalDatasource>(
    () => FavoriteLocalDatasourceImplementation(
      box: getFavoritesBox,
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
  sl.registerLazySingleton<DetailLocalDatasource>(
    () => DetailLocalDatasourceImplementation(
      box: detailBox,
    ),
  );
  sl.registerLazySingleton(
    () => AddFavoriteLocalDatasource(box: statusFavoritesBox),
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
  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImplementation(
      addFavoriteLocalDatasource: sl<AddFavoriteLocalDatasource>(),
      favoriteLocalDatasource: sl<FavoriteLocalDatasource>(),
      favoriteRemoteDatasource: sl<FavoriteRemoteDatasource>(),
      connectivity: sl<Connectivity>(),
    ),
  );
  sl.registerLazySingleton<DetailRepository>(
    () => DetailRepositoryImplementation(
      detailLocalDatasource: sl<DetailLocalDatasource>(),
      detailRemoteDatasource: sl<DetailRemoteDatasource>(),
      connectivity: sl<Connectivity>(),
    ),
  );
  sl.registerLazySingleton<DiscoverRepository>(
    () => DiscoverRepositoryImplementation(
      discoverRemoteDatasource: sl<DiscoverRemoteDatasource>(),
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
  sl.registerLazySingleton(
    () => GetFavoriteCase(
      sl<FavoriteRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => AddFavoriteCase(
      sl<FavoriteRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetDetailCase(
      sl<DetailRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetDiscoverSortbyCase(
      sl<DiscoverRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetSearchDiscoverCase(
      sl<DiscoverRepository>(),
    ),
  );

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

  sl.registerFactory(
    () => GetFavoritesBloc(
      getFavoriteCase: sl<GetFavoriteCase>(),
    ),
  );
  sl.registerFactory(
    () => StatusFavoriteBloc(
      addFavoriteLocalDatasource: sl<AddFavoriteLocalDatasource>(),
    ),
  );
  sl.registerFactory(
    () => AddFavoriteBloc(
      addFavoriteCase: sl<AddFavoriteCase>(),
    ),
  );
  sl.registerFactory(
    () => MovieDetailBloc(
      getDetailCase: sl<GetDetailCase>(),
    ),
  );
  sl.registerFactory(
    () => DiscoverBloc(
      getSearchDiscoverCase: sl<GetSearchDiscoverCase>(),
      getDiscoverSortbyCase: sl<GetDiscoverSortbyCase>(),
    ),
  );
}
