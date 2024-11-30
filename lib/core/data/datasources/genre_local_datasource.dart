import 'package:hive/hive.dart';
import '../models/genre_model.dart';

import '../../error/custom_exception.dart';

abstract class GenreLocalDatasource {
  Future<List<GenreModel?>> getGenres();
  Future<void> saveGenres(List<GenreModel> genres);
  Future<void> clearGenres();
}

class GenreLocalDatasourceImplementation extends GenreLocalDatasource {
  final Box box;
  static const String _genresKey = 'genres';

  GenreLocalDatasourceImplementation({required this.box});

  @override
  Future<List<GenreModel?>> getGenres() async {
    try {
      dynamic rawData = box.get(_genresKey);
      if (rawData == null) return [];

      List<dynamic> dynamicList = List<dynamic>.from(rawData);
      return dynamicList.map((item) {
        try {
          if (item is GenreModel) {
            return item;
          } else if (item is Map<String, dynamic>) {
            return GenreModel.fromJson(item);
          }
          return null;
        } catch (e) {
          return null;
        }
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveGenres(List<GenreModel> genres) async {
    try {
      await box.put(_genresKey, genres);
    } catch (e) {
      throw CacheException('Failed to save genres to local storage');
    }
  }

  @override
  Future<void> clearGenres() async {
    try {
      await box.delete(_genresKey);
    } catch (e) {
      throw CacheException('Failed to clear genres from local storage');
    }
  }
}
