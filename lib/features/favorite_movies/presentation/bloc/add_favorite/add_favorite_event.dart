part of 'add_favorite_bloc.dart';

sealed class AddFavoriteEvent extends Equatable {
  const AddFavoriteEvent();

  @override
  List<Object> get props => [];
}

class SendFavoriteEvent extends AddFavoriteEvent {
  final AddFavoriteRequest request;
  const SendFavoriteEvent({required this.request});

  @override
  List<Object> get props => [request];
}
