import 'package:dio/dio.dart';
import '../../../../core/data/models/all_movie_model.dart';
import '../../../../core/data/models/failed_model.dart';
import '../../../../env.dart';

abstract class DiscoverRemoteDatasource {
  Future<AllMovieModel> getSearchDiscover(String search, int page);
  Future<AllMovieModel> getDiscoverSortBy(
      String sortBy, List<int> genres, int page);
}

class DiscoverRemoteDatasourceImplementation extends DiscoverRemoteDatasource {
  final Dio dio;
  DiscoverRemoteDatasourceImplementation({required this.dio});
  @override
  Future<AllMovieModel> getDiscoverSortBy(
      String sortBy, List<int> genres, int page) async {
    try {
      String resultGenre = (genres.isEmpty) ? '' : genres.join(',');
      final response = await dio.get(
        "${Env.url}/discover/movie?sort_by=$sortBy&with_genres=$resultGenre&page=$page",
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

  @override
  Future<AllMovieModel> getSearchDiscover(String search, int page) async {
    try {
      final response = await dio.get(
        "${Env.url}/search/movie?query=$search&page=$page",
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
