import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/response/failed_response.dart';
import '../../../../core/domain/entities/response/all_movie_response.dart';

abstract class MovieRepository {
  Future<Either<FailedResponse, AllMovieResponse?>> getNowPlaying(int page);
  Future<Either<FailedResponse, AllMovieResponse?>> getUpcoming(int page);
}
