part of 'status_favorite_bloc.dart';

sealed class StatusFavoriteState extends Equatable {
  const StatusFavoriteState();

  @override
  List<Object> get props => [];
}

final class StatusFavoriteInitial extends StatusFavoriteState {}

final class StatusFavoriteLoading extends StatusFavoriteState {}

final class StatusFavoriteLoaded extends StatusFavoriteState {
  final List<FavoriteLocalMovie> localFavorites;
  const StatusFavoriteLoaded({required this.localFavorites});

  @override
  List<Object> get props => [localFavorites];
}

final class StatusFavoriteError extends StatusFavoriteState {
  final String errorMessage;

  const StatusFavoriteError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
