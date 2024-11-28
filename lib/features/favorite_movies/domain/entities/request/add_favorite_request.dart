import 'package:equatable/equatable.dart';

class AddFavoriteRequest extends Equatable {
  final String mediaType;
  final int id;
  final bool isFavorite;

  const AddFavoriteRequest(
      {required this.mediaType, required this.id, required this.isFavorite});
  @override
  List<Object?> get props => [mediaType, id, isFavorite];
}
