import 'package:equatable/equatable.dart';

class AllMovieResponse extends Equatable {
  final int page;
  final List<MovieResponse> movies;
  final int totalPages;

  const AllMovieResponse({
    required this.page,
    required this.movies,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [page, movies, totalPages];
}

class MovieResponse extends Equatable {
  final int id;
  final String posterUrl;
  final List<int> genre;
  final String title;
  final double voteAvg;
  final int popularity;

  const MovieResponse(
      {required this.id,
      required this.posterUrl,
      required this.genre,
      required this.title,
      required this.voteAvg,
      required this.popularity});

  @override
  List<Object?> get props => [id, posterUrl, title, voteAvg, popularity];
}
