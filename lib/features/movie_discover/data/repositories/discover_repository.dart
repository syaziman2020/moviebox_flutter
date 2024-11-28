import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/response/all_movie_response.dart';
import '../../../../core/domain/entities/response/failed_response.dart';
import '../datasources/discover_remote_datasource.dart';
import '../../domain/repositories/discover_repository.dart';

import '../../../../core/data/models/failed_model.dart';

class DiscoverRepositoryImplementation extends DiscoverRepository {
  final Connectivity connectivity;
  final DiscoverRemoteDatasource discoverRemoteDatasource;
  DiscoverRepositoryImplementation(
      {required this.discoverRemoteDatasource, required this.connectivity});
  @override
  Future<Either<FailedResponse, AllMovieResponse>> getDiscoverSortBy(
      String sortBy, List<int> genres, int page) async {
    final connectivityResult = await connectivity.checkConnectivity();
    bool isOffline = connectivityResult.isEmpty ||
        connectivityResult.every((result) => result == ConnectivityResult.none);
    if (isOffline) {
      return const Left(
        FailedResponse(
          errorMessage: 'Connection is offline. Please connect to the internet',
        ),
      );
    } else {
      try {
        final remoteData = await discoverRemoteDatasource.getDiscoverSortBy(
            sortBy, genres, page);
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
  Future<Either<FailedResponse, AllMovieResponse>> getSearchDiscover(
      String search, int page) async {
    final connectivityResult = await connectivity.checkConnectivity();
    bool isOffline = connectivityResult.isEmpty ||
        connectivityResult.every((result) => result == ConnectivityResult.none);
    if (isOffline) {
      return const Left(
        FailedResponse(
          errorMessage: 'Connection is offline. Please connect to the internet',
        ),
      );
    } else {
      try {
        final remoteData =
            await discoverRemoteDatasource.getSearchDiscover(search, page);
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
}
