import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/response/all_movie_response.dart';
import '../../../../core/domain/entities/response/failed_response.dart';
import '../entities/request/add_favorite_request.dart';
import '../entities/response/add_favorite_response.dart';

abstract class FavoriteRepository {
  Future<Either<FailedResponse, AddFavoriteResponse?>> addFavorite(
      AddFavoriteRequest request);
  Future<Either<FailedResponse, AllMovieResponse?>> getFavorites(int page);
}
