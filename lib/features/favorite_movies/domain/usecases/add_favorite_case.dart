import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/response/failed_response.dart';
import '../entities/request/add_favorite_request.dart';
import '../entities/response/add_favorite_response.dart';
import '../repositories/favorite_repository.dart';

class AddFavoriteCase {
  final FavoriteRepository favoriteRepository;
  AddFavoriteCase(this.favoriteRepository);

  Future<Either<FailedResponse, AddFavoriteResponse?>> execute(
      AddFavoriteRequest request) async {
    return await favoriteRepository.addFavorite(request);
  }
}
