import 'package:dartz/dartz.dart';
import '../entities/response/failed_response.dart';
import '../entities/response/genre_response.dart';
import '../repositories/genre_repository.dart';

class GetGenreCase {
  final GenreRepository genreRepository;
  GetGenreCase(this.genreRepository);
  Future<Either<FailedResponse, List<GenreResponse?>>> execute() async {
    return await genreRepository.getGenres();
  }
}
