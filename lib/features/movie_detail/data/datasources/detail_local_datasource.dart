import 'package:hive_flutter/hive_flutter.dart';
import '../models/detail_model.dart';

import '../../../../core/error/custom_exception.dart';

abstract class DetailLocalDatasource {
  Future<DetailModel?> getMovieDetail(int movieId);
  Future<void> saveMovieDetail(DetailModel data);
  Future<void> clearCacheDetail(int movieId);
  List<DetailModel> getAllStoredDetails();
  Future<bool> hasStoredDetail(int movieId);
}

class DetailLocalDatasourceImplementation extends DetailLocalDatasource {
  final Box<DetailModel> box;

  DetailLocalDatasourceImplementation({required this.box});

  String _getDetailKey(int movieId) => 'movie_detail_$movieId';

  @override
  Future<void> saveMovieDetail(DetailModel data) async {
    try {
      await box.put(_getDetailKey(data.id), data);
    } catch (e) {
      throw CacheException('Failed to save movie detail data');
    }
  }

  @override
  Future<DetailModel?> getMovieDetail(int movieId) async {
    try {
      return box.get(_getDetailKey(movieId));
    } catch (e) {
      throw CacheException('Failed to get movie detail data');
    }
  }

  @override
  List<DetailModel> getAllStoredDetails() {
    try {
      final List<DetailModel> allDetails = [];

      for (var key in box.keys) {
        if (key.toString().startsWith('movie_detail_')) {
          final data = box.get(key);
          if (data != null) {
            allDetails.add(data);
          }
        }
      }

      return allDetails;
    } catch (e) {
      throw CacheException('Failed to get all stored details');
    }
  }

  @override
  Future<void> clearCacheDetail(int movieId) async {
    try {
      await box.delete(_getDetailKey(movieId));
    } catch (e) {
      throw CacheException('Failed to clear cache for movie detail');
    }
  }

  @override
  Future<bool> hasStoredDetail(int movieId) async {
    try {
      final data = box.get(_getDetailKey(movieId));
      return data != null;
    } catch (e) {
      return false;
    }
  }
}
