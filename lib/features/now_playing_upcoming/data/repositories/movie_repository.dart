import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/response/all_movie_response.dart';
import '../../../../core/domain/entities/response/failed_response.dart';
import '../datasources/movie_remote_datasource.dart';
import '../datasources/nowplaying_local_datasource.dart';
import '../../domain/repositories/movie_repository.dart';

import '../../../../core/data/models/failed_model.dart';
import '../../../../core/error/custom_exception.dart';
import '../datasources/upcoming_local_datasource.dart';

class MovieRepositoryImplementation extends MovieRepository {
  final UpcomingLocalDatasource localUpcomingDatasource;
  final NowplayingLocalDatasource localNowplayingDatasource;
  final MovieRemoteDatasource remoteDatasource;
  final Connectivity connectivity;

  MovieRepositoryImplementation({
    required this.localUpcomingDatasource,
    required this.localNowplayingDatasource,
    required this.remoteDatasource,
    required this.connectivity,
  });

  @override
  Future<Either<FailedResponse, AllMovieResponse?>> getUpcoming(
      int page) async {
    final connectivityResult = await connectivity.checkConnectivity();
    bool isOffline = connectivityResult.isEmpty ||
        connectivityResult.every((result) => result == ConnectivityResult.none);
    if (isOffline) {
      try {
        final localData = await localUpcomingDatasource.getUpcoming(page);
        return Right(localData);
      } on CacheException catch (e) {
        return Left(
          FailedResponse(
            errorMessage: e.message,
          ),
        );
      } catch (e) {
        return const Left(
          FailedResponse(
            errorMessage: 'An unexpected error occurred',
          ),
        );
      }
    } else {
      try {
        final remoteData = await remoteDatasource.getUpcoming(page);
        await localUpcomingDatasource.saveUpcoming(remoteData, page);
        return Right(remoteData);
      } on FailedModel catch (e) {
        return Left(
          FailedResponse(
            errorMessage: e.errorMessage,
          ),
        );
      } catch (e) {
        return const Left(
          FailedResponse(
            errorMessage: 'An unexpected error occurred',
          ),
        );
      }
    }
  }

  @override
  Future<Either<FailedResponse, AllMovieResponse?>> getNowPlaying(
      int page) async {
    final connectivityResult = await connectivity.checkConnectivity();
    bool isOffline = connectivityResult.isEmpty ||
        connectivityResult.every((result) => result == ConnectivityResult.none);

    if (isOffline) {
      try {
        final localData = await localNowplayingDatasource.getNowPlaying(page);
        return Right(localData);
      } on CacheException catch (e) {
        return Left(
          FailedResponse(
            errorMessage: e.message,
          ),
        );
      } catch (e) {
        return const Left(
          FailedResponse(
            errorMessage: 'Failed to access local data',
          ),
        );
      }
    } else {
      try {
        final remoteData = await remoteDatasource.getNowPlaying(page);
        await localNowplayingDatasource.saveNowPlaying(remoteData, page);
        return Right(remoteData);
      } on FailedModel catch (e) {
        return Left(
          FailedResponse(
            errorMessage: e.errorMessage,
          ),
        );
      }
    }
  }
}
