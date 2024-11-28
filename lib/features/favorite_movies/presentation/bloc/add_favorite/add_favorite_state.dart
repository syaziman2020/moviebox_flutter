part of 'add_favorite_bloc.dart';

sealed class AddFavoriteState extends Equatable {
  const AddFavoriteState();

  @override
  List<Object> get props => [];
}

final class AddFavoriteInitial extends AddFavoriteState {}

final class AddFavoriteLoading extends AddFavoriteState {}

final class AddFavoriteError extends AddFavoriteState {
  final String message;
  const AddFavoriteError({required this.message});
  @override
  List<Object> get props => [message];
}

final class AddFavoriteLoaded extends AddFavoriteState {
  final AddFavoriteResponse response;
  const AddFavoriteLoaded({required this.response});
  @override
  List<Object> get props => [response];
}
