import 'package:hive_flutter/hive_flutter.dart';

import '../models/favorite_local_movie.dart';

class AddFavoriteLocalDatasource {
  Box<FavoriteLocalMovie> box;
  AddFavoriteLocalDatasource({required this.box});

  Future<void> addToFavorites(int movieId) async {
    final favorite = FavoriteLocalMovie(
      movieId: movieId,
    );

    await box.put(movieId.toString(), favorite);
  }

  Future<void> removeFromFavorites(int movieId) async {
    await box.delete(movieId.toString());
  }

  bool isFavorite(int movieId) {
    final result = box.containsKey(movieId.toString());
    return result;
  }

  List<FavoriteLocalMovie> getAllFavorites() {
    return box.values.toList();
  }
}
