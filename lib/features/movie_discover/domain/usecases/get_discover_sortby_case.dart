import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/response/all_movie_response.dart';
import '../../../../core/domain/entities/response/failed_response.dart';
import '../repositories/discover_repository.dart';

class GetDiscoverSortbyCase {
  final DiscoverRepository discoverRepository;
  GetDiscoverSortbyCase(this.discoverRepository);
  Future<Either<FailedResponse, AllMovieResponse>> execute(
      String sortBy, List<int> genres, int page) async {
    return await discoverRepository.getDiscoverSortBy(sortBy, genres, page);
  }
}
