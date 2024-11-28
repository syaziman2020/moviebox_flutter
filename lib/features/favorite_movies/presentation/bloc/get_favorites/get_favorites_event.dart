part of 'get_favorites_bloc.dart';

sealed class GetFavoritesEvent extends Equatable {
  const GetFavoritesEvent();

  @override
  List<Object> get props => [];
}

class GetFirstFavoriteEvent extends GetFavoritesEvent {}

class LoadMoreGetFavoritesEvent extends GetFavoritesEvent {}
