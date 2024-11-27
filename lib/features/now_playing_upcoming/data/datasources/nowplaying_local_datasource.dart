import 'package:hive/hive.dart';
import '../../../../core/data/models/all_movie_model.dart';

import '../../../../core/error/custom_exception.dart';

abstract class NowplayingLocalDatasource {
  Future<AllMovieModel?> getNowPlaying(int page);
  Future<void> saveNowPlaying(AllMovieModel data, int page);
  Future<void> clearCacheNowplaying();
  List<AllMovieModel> getAllStoredNowplayingPages();
  Future<bool> hasStoredDataPlaying(int page);
}

class NowplayingLocalDatasourceImplementation
    extends NowplayingLocalDatasource {
  final Box<AllMovieModel> box;

  NowplayingLocalDatasourceImplementation({required this.box});

  String _getPageKey(int page) => 'getNowPlaying_page_$page';

  @override
  Future<void> saveNowPlaying(AllMovieModel data, int page) async {
    try {
      await box.put(_getPageKey(page), data);
    } catch (e) {
      throw CacheException('Failed to save now playing movies data');
    }
  }

  @override
  Future<AllMovieModel?> getNowPlaying(int page) async {
    try {
      return box.get(_getPageKey(page));
    } catch (e) {
      throw CacheException('Failed to get now playing movies data');
    }
  }

  @override
  List<AllMovieModel> getAllStoredNowplayingPages() {
    try {
      final List<AllMovieModel> allPages = [];

      for (var key in box.keys) {
        if (key.toString().startsWith('getNowPlaying_page_')) {
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
  Future<void> clearCacheNowplaying() async {
    try {
      final keysToDelete = box.keys
          .where((key) => key.toString().startsWith('getNowPlaying_page_'));

      for (var key in keysToDelete) {
        await box.delete(key);
      }
    } catch (e) {
      throw CacheException('Failed to clear cache');
    }
  }

  @override
  Future<bool> hasStoredDataPlaying(int page) async {
    try {
      final data = box.get(_getPageKey(page));
      return data != null;
    } catch (e) {
      return false;
    }
  }
}
