import 'package:hive_flutter/hive_flutter.dart';
part 'favorite_local_movie.g.dart';

@HiveType(typeId: 4)
class FavoriteLocalMovie extends HiveObject {
  @HiveField(0)
  final int movieId;

  FavoriteLocalMovie({
    required this.movieId,
  });
}
