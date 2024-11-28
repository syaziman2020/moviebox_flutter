import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/response/all_movie_response.dart';
import '../../../../core/domain/entities/response/failed_response.dart';

abstract class DiscoverRepository {
  Future<Either<FailedResponse, AllMovieResponse>> getSearchDiscover(
      String search, int page);
  Future<Either<FailedResponse, AllMovieResponse>> getDiscoverSortBy(
      String sortBy, List<int> genres, int page);
}
