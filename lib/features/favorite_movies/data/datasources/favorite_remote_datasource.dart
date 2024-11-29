import 'package:dio/dio.dart';
import '../../../../core/data/models/all_movie_model.dart';
import '../../../../env.dart';
import '../models/add_favorite_request_model.dart';

import '../../../../core/data/models/failed_model.dart';
import '../models/add_favorite_model.dart';

abstract class FavoriteRemoteDatasource {
  Future<AddFavoriteModel> addFavorite(AddFavoriteRequestModel request);
  Future<AllMovieModel> getFavorites(int page);
}

class FavoriteRemoteDatasourceImplementation extends FavoriteRemoteDatasource {
  final Dio dio;
  FavoriteRemoteDatasourceImplementation({required this.dio});

  @override
  Future<AddFavoriteModel> addFavorite(AddFavoriteRequestModel request) async {
    try {
      final response = await dio.post(
        "${Env.url}/account/21653394/favorite",
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${Env.apiKey}',
            "Accept": "application/json",
          },
        ),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return AddFavoriteModel.fromJson(response.data);
      } else {
        throw FailedModel.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AllMovieModel> getFavorites(int page) async {
    try {
      final response = await dio.get(
        '${Env.url}/account/21653394/favorite/movies?page=$page',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Env.apiKey}'
          },
        ),
      );
      if (response.statusCode == 200) {
        return AllMovieModel.fromJson(response.data);
      } else {
        throw FailedModel.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
  }
}
