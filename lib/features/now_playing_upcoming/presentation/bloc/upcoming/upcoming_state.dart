part of 'upcoming_bloc.dart';

sealed class UpcomingState extends Equatable {
  const UpcomingState();

  @override
  List<Object> get props => [];
}

final class UpcomingInitial extends UpcomingState {}

class MovieLoadingUpcoming extends UpcomingState {}

class MovieErrorUpcoming extends UpcomingState {
  final String message;

  const MovieErrorUpcoming(this.message);

  @override
  List<Object> get props => [message];
}

class UpcomingMovieLoaded extends UpcomingState {
  final List<MovieResponse> movies;
  final bool hasReachedMax;
  final int currentPage;
  final int totalPages;

  const UpcomingMovieLoaded({
    required this.movies,
    required this.hasReachedMax,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object> get props => [movies, hasReachedMax, currentPage, totalPages];

  UpcomingMovieLoaded copyWith({
    List<MovieResponse>? movies,
    bool? hasReachedMax,
    int? currentPage,
    int? totalPages,
  }) {
    return UpcomingMovieLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
