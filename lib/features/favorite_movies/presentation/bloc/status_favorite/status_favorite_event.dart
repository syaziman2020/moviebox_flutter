part of 'status_favorite_bloc.dart';

sealed class StatusFavoriteEvent extends Equatable {
  const StatusFavoriteEvent();

  @override
  List<Object> get props => [];
}

class CheckFavoriteEvent extends StatusFavoriteEvent {}
