import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/response/all_movie_response.dart';
import '../../../../core/domain/entities/response/failed_response.dart';
import '../datasources/add_favorite_local_datasource.dart';
import '../datasources/favorite_local_datasource.dart';
import '../datasources/favorite_remote_datasource.dart';
import '../models/favorite_local_movie.dart';
import '../../domain/entities/request/add_favorite_request.dart';
import '../../domain/entities/response/add_favorite_response.dart';
import '../../domain/repositories/favorite_repository.dart';

import '../../../../core/data/models/failed_model.dart';
import '../../../../core/error/custom_exception.dart';
import '../models/add_favorite_request_model.dart';

class FavoriteRepositoryImplementation extends FavoriteRepository {
  final Connectivity connectivity;
  final AddFavoriteLocalDatasource addFavoriteLocalDatasource;
  final FavoriteRemoteDatasource favoriteRemoteDatasource;
  final FavoriteLocalDatasource favoriteLocalDatasource;
  FavoriteRepositoryImplementation(
      {required this.connectivity,
      required this.addFavoriteLocalDatasource,
      required this.favoriteRemoteDatasource,
      required this.favoriteLocalDatasource});

  @override
  Future<Either<FailedResponse, AddFavoriteResponse>> addFavorite(
      AddFavoriteRequest request) async {
    final connectivityResult = await connectivity.checkConnectivity();
    bool isOffline = connectivityResult.isEmpty ||
        connectivityResult.every((result) => result == ConnectivityResult.none);
    if (isOffline) {
      return const Left(
        FailedResponse(
          errorMessage:
              "Connection is offline. Please connect to the internet to add favorites",
        ),
      );
    } else {
      try {
        final requestModel = AddFavoriteRequestModel(
          mediaId: request.id,
          mediaType: request.mediaType,
          favorite: request.isFavorite,
        );
        final remoteData =
            await favoriteRemoteDatasource.addFavorite(requestModel);
        if (requestModel.favorite) {
          await addFavoriteLocalDatasource.addToFavorites(request.id);
        } else {
          await addFavoriteLocalDatasource.removeFromFavorites(request.id);
        }

        return Right(remoteData);
      } on FailedModel catch (e) {
        return Left(
          FailedResponse(
            errorMessage: e.errorMessage,
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
            errorMessage: 'Failed to access local data',
          ),
        );
      }
    }
  }

  @override
  Future<Either<FailedResponse, AllMovieResponse?>> getFavorites(
      int page) async {
    final connectivityResult = await connectivity.checkConnectivity();
    bool isOffline = connectivityResult.isEmpty ||
        connectivityResult.every((result) => result == ConnectivityResult.none);

    if (isOffline) {
      try {
        final localData = await favoriteLocalDatasource.getFavorites(page);
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
        final remoteData = await favoriteRemoteDatasource.getFavorites(page);
        await favoriteLocalDatasource.saveFavorites(remoteData, page);
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
