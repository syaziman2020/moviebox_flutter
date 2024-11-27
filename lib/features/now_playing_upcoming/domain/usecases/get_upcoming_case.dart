import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/response/failed_response.dart';
import '../../../../core/domain/entities/response/all_movie_response.dart';
import '../repositories/movie_repository.dart';

class GetUpcomingCase {
  final MovieRepository movieRepository;
  GetUpcomingCase(this.movieRepository);

  Future<Either<FailedResponse, AllMovieResponse?>> execute(int page) async {
    return await movieRepository.getUpcoming(page);
  }
}
