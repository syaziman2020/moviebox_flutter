import 'package:dio/dio.dart';
import '../models/genre_model.dart';

import '../../constants/env.dart';
import '../models/failed_model.dart';

abstract class GenreRemoteDatasource {
  Future<List<GenreModel>> getGenres();
}

class GenreRemoteDatasourceImplementation extends GenreRemoteDatasource {
  final Dio dio;
  GenreRemoteDatasourceImplementation({required this.dio});
  @override
  Future<List<GenreModel>> getGenres() async {
    try {
      final response = await dio.get(
        "${Env.url}/genre/movie/list",
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Env.apiKey}'
          },
        ),
      );

      if (response.statusCode == 200) {
        return GenreModel.fromJsonList(response.data["genres"]);
      } else {
        throw FailedModel.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
  }
}
