part of 'movie_detail_bloc.dart';

sealed class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object?> get props => [];
}

final class MovieDetailInitial extends MovieDetailState {}

final class MovieDetailLoading extends MovieDetailState {}

final class MovieDetailError extends MovieDetailState {
  final String message;
  const MovieDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class MovieDetailLoaded extends MovieDetailState {
  final DetailResponse? detailResponse;
  const MovieDetailLoaded({required this.detailResponse});

  @override
  List<Object?> get props => [detailResponse];
}
