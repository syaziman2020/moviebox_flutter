part of 'now_playing_bloc.dart';

sealed class NowPlayingState extends Equatable {
  const NowPlayingState();

  @override
  List<Object> get props => [];
}

final class NowPlayingInitial extends NowPlayingState {}

class MovieLoadingNowPlaying extends NowPlayingState {}

class MovieErrorNowPlaying extends NowPlayingState {
  final String message;

  const MovieErrorNowPlaying(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingMovieLoaded extends NowPlayingState {
  final List<MovieResponse> movies;
  final bool hasReachedMax;
  final int currentPage;
  final int totalPages;

  const NowPlayingMovieLoaded({
    required this.movies,
    required this.hasReachedMax,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object> get props => [movies, hasReachedMax, currentPage, totalPages];

  NowPlayingMovieLoaded copyWith({
    List<MovieResponse>? movies,
    bool? hasReachedMax,
    int? currentPage,
    int? totalPages,
  }) {
    return NowPlayingMovieLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
