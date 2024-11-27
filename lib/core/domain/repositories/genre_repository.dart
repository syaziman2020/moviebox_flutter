import 'package:dartz/dartz.dart';
import '../entities/response/failed_response.dart';
import '../entities/response/genre_response.dart';

abstract class GenreRepository {
  Future<Either<FailedResponse, List<GenreResponse?>>> getGenres();
}
