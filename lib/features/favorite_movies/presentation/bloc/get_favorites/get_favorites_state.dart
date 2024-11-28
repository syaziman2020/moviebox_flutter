part of 'get_favorites_bloc.dart';

sealed class GetFavoritesState extends Equatable {
  const GetFavoritesState();

  @override
  List<Object> get props => [];
}

final class GetFavoritesInitial extends GetFavoritesState {}

final class GetFavoritesLoading extends GetFavoritesState {}

final class GetFavoritesError extends GetFavoritesState {
  final String errorMessage;

  const GetFavoritesError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class GetFavoritesLoaded extends GetFavoritesState {
  final List<MovieResponse> movies;
  final bool hasReachedMax;
  final int currentPage;
  final int totalPages;

  const GetFavoritesLoaded({
    required this.movies,
    required this.hasReachedMax,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object> get props => [movies, hasReachedMax, currentPage, totalPages];

  GetFavoritesLoaded copyWith({
    List<MovieResponse>? movies,
    bool? hasReachedMax,
    int? currentPage,
    int? totalPages,
  }) {
    return GetFavoritesLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
