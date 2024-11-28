import 'package:dartz/dartz.dart';

import '../../../../core/domain/entities/response/all_movie_response.dart';
import '../../../../core/domain/entities/response/failed_response.dart';
import '../repositories/discover_repository.dart';

class GetSearchDiscoverCase {
  final DiscoverRepository discoverRepository;
  GetSearchDiscoverCase(this.discoverRepository);
  Future<Either<FailedResponse, AllMovieResponse>> execute(
      String search, int page) async {
    return await discoverRepository.getSearchDiscover(search, page);
  }
}
