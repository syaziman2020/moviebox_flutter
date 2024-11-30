import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/data/models/failed_model.dart';
import '../../../../core/domain/entities/response/failed_response.dart';
import '../../../../core/error/custom_exception.dart';
import '../../domain/entities/response/genre_response.dart';
import '../../domain/repositories/genre_repository.dart';
import '../datasources/genre_local_datasource.dart';
import '../datasources/genre_remote_datasource.dart';

class GenreRepositoryImplementation extends GenreRepository {
  final GenreLocalDatasource genreLocalDatasource;
  final GenreRemoteDatasource genreRemoteDatasource;
  final Connectivity connectivity;

  GenreRepositoryImplementation({
    required this.genreLocalDatasource,
    required this.genreRemoteDatasource,
    required this.connectivity,
  });

  @override
  Future<Either<FailedResponse, List<GenreResponse?>>> getGenres() async {
    final connectivityResult = await connectivity.checkConnectivity();
    bool isOffline = connectivityResult.isEmpty ||
        connectivityResult.every((result) => result == ConnectivityResult.none);

    try {
      if (isOffline) {
        try {
          final localData = await genreLocalDatasource.getGenres();
          if (localData.isNotEmpty) {
            return Right(localData);
          }

          return const Left(
            FailedResponse(
              errorMessage: 'No local data available',
            ),
          );
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
          final remoteData = await genreRemoteDatasource.getGenres();
          await genreLocalDatasource.saveGenres(remoteData);
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
    } on CacheException catch (e) {
      return Left(FailedResponse(errorMessage: e.message));
    } on FailedModel catch (e) {
      return Left(FailedResponse(errorMessage: e.errorMessage));
    } catch (e) {
      return const Left(
        FailedResponse(errorMessage: 'An unexpected error occurred'),
      );
    }
  }
}
