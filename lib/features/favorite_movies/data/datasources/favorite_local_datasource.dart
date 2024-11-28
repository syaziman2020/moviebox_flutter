import 'package:hive/hive.dart';
import '../../../../core/data/models/all_movie_model.dart';

import '../../../../core/error/custom_exception.dart';

abstract class FavoriteLocalDatasource {
  Future<AllMovieModel?> getFavorites(int page);
  Future<void> saveFavorites(AllMovieModel data, int page);
  Future<void> clearCacheFavorites();
  List<AllMovieModel> getAllStoredFavoritesPages();
  Future<bool> hasStoredData(int page);
}

class FavoriteLocalDatasourceImplementation extends FavoriteLocalDatasource {
  final Box<AllMovieModel> box;

  FavoriteLocalDatasourceImplementation({required this.box});

  String _getPageKey(int page) => 'getFavorite_page_$page';

  @override
  Future<void> saveFavorites(AllMovieModel data, int page) async {
    try {
      await box.put(_getPageKey(page), data);
    } catch (e) {
      throw CacheException('Failed to save favorite movies data');
    }
  }

  @override
  Future<AllMovieModel?> getFavorites(int page) async {
    try {
      return box.get(_getPageKey(page));
    } catch (e) {
      throw CacheException('Failed to get favorite movies data');
    }
  }

  @override
  List<AllMovieModel> getAllStoredFavoritesPages() {
    try {
      final List<AllMovieModel> allPages = [];

      for (var key in box.keys) {
        if (key.toString().startsWith('getFavorite_page_')) {
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
  Future<void> clearCacheFavorites() async {
    try {
      final keysToDelete = box.keys
          .where((key) => key.toString().startsWith('getFavorite_page_'));

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
