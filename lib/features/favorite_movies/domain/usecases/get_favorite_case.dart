import 'package:dartz/dartz.dart';
import '../repositories/favorite_repository.dart';

import '../../../../core/domain/entities/response/all_movie_response.dart';
import '../../../../core/domain/entities/response/failed_response.dart';

class GetFavoriteCase {
  final FavoriteRepository favoriteRepository;
  GetFavoriteCase(this.favoriteRepository);

  Future<Either<FailedResponse, AllMovieResponse?>> execute(int page) async {
    return await favoriteRepository.getFavorites(page);
  }
}
