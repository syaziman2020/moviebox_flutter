import 'package:hive/hive.dart';
import '../../domain/entities/response/all_movie_response.dart';

part 'all_movie_model.g.dart';

@HiveType(typeId: 1)
class AllMovieModel extends AllMovieResponse {
  @HiveField(0)
  final int page;

  @HiveField(1)
  final List<MovieModel> results;

  @HiveField(2)
  final int totalPages;

  const AllMovieModel({
    required this.page,
    required this.results,
    required this.totalPages,
  }) : super(
          page: page,
          movies: results,
          totalPages: totalPages,
        );

  factory AllMovieModel.fromJson(Map<String, dynamic> json) => AllMovieModel(
        page: json["page"],
        results: List<MovieModel>.from(
            json["results"].map((x) => MovieModel.fromJson(x))),
        totalPages: json["total_pages"],
      );
}

@HiveType(typeId: 2)
class MovieModel extends MovieResponse {
  @HiveField(0)
  final List<int> genreIds;

  @HiveField(1)
  final int id;

  @HiveField(2)
  final int popularity;

  @HiveField(3)
  final String posterPath;

  @HiveField(4)
  final String title;

  @HiveField(5)
  final double voteAverage;

  const MovieModel({
    required this.genreIds,
    required this.id,
    required this.popularity,
    required this.posterPath,
    required this.title,
    required this.voteAverage,
  }) : super(
          id: id,
          posterUrl: posterPath,
          genre: genreIds,
          title: title,
          voteAvg: voteAverage,
          popularity: popularity,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        popularity: json["popularity"]?.toDouble().toInt(),
        posterPath: json["poster_path"] ?? "",
        title: json["title"],
        voteAverage: json["vote_average"]?.toDouble() ?? 0.0,
      );
}
