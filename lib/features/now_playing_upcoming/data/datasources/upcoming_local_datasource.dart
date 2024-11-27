import 'package:hive/hive.dart';
import '../../../../core/data/models/all_movie_model.dart';

import '../../../../core/error/custom_exception.dart';

abstract class UpcomingLocalDatasource {
  Future<AllMovieModel?> getUpcoming(int page);
  Future<void> saveUpcoming(AllMovieModel data, int page);
  Future<void> clearCacheUpcoming();
  List<AllMovieModel> getAllStoredUpcomingPages();
  Future<bool> hasStoredData(int page);
}

class UpcomingLocalDatasourceImplementation extends UpcomingLocalDatasource {
  final Box<AllMovieModel> box;

  UpcomingLocalDatasourceImplementation({required this.box});

  String _getPageKey(int page) => 'getUpcoming_page_$page';

  @override
  Future<void> saveUpcoming(AllMovieModel data, int page) async {
    try {
      await box.put(_getPageKey(page), data);
    } catch (e) {
      throw CacheException('Failed to save upcoming movies data');
    }
  }

  @override
  Future<AllMovieModel?> getUpcoming(int page) async {
    try {
      return box.get(_getPageKey(page));
    } catch (e) {
      throw CacheException('Failed to get upcoming movies data');
    }
  }

  @override
  List<AllMovieModel> getAllStoredUpcomingPages() {
    try {
      final List<AllMovieModel> allPages = [];

      for (var key in box.keys) {
        if (key.toString().startsWith('getUpcoming_page_')) {
          final data = box.get(key);
          if (data != null) {
            allPages.add(data);
          }
        }
      }

      return allPages;
    } catch (e) {
      throw CacheException('Failed to get all stored pages');
    }
  }

  @override
  Future<void> clearCacheUpcoming() async {
    try {
      final keysToDelete = box.keys
          .where((key) => key.toString().startsWith('getUpcoming_page_'));

      for (var key in keysToDelete) {
        await box.delete(key);
      }
    } catch (e) {
      throw CacheException('Failed to clear cache');
    }
  }

  @override
  Future<bool> hasStoredData(int page) async {
    try {
      final data = box.get(_getPageKey(page));
      return data != null;
    } catch (e) {
      return false;
    }
  }
}
