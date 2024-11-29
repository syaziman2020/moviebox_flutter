import 'package:dio/dio.dart';
import '../../../../env.dart';
import '../../../../core/data/models/failed_model.dart';
import '../../../../core/data/models/all_movie_model.dart';

abstract class MovieRemoteDatasource {
  Future<AllMovieModel> getNowPlaying(int page);
  Future<AllMovieModel> getUpcoming(int page);
}

class MovieRemoteDataSourceImplementation implements MovieRemoteDatasource {
  final Dio dio;
  MovieRemoteDataSourceImplementation({required this.dio});
  @override
  Future<AllMovieModel> getNowPlaying(int page) async {
    try {
      final response = await dio.get(
        "${Env.url}/movie/now_playing?page=$page",
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
  Future<AllMovieModel> getUpcoming(int page) async {
    try {
      final response = await dio.get(
        "${Env.url}/movie/upcoming?page=$page",
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
