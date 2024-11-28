part of 'discover_bloc.dart';

sealed class DiscoverState extends Equatable {
  const DiscoverState();

  @override
  List<Object> get props => [];
}

final class DiscoverInitial extends DiscoverState {}

final class DiscoverLoading extends DiscoverState {}

final class DiscoverError extends DiscoverState {
  final String error;

  const DiscoverError({required this.error});

  @override
  List<Object> get props => [error];
}

final class DiscoverLoaded extends DiscoverState {
  final List<MovieResponse> movies;
  final bool hasReachedMax;
  final int currentPage;
  final int totalPages;

  const DiscoverLoaded({
    required this.movies,
    required this.hasReachedMax,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object> get props => [movies, hasReachedMax, currentPage, totalPages];
  DiscoverLoaded copyWith({
    List<MovieResponse>? movies,
    bool? hasReachedMax,
    int? currentPage,
    int? totalPages,
  }) {
    return DiscoverLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
