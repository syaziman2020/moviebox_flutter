import '../../domain/entities/request/add_favorite_request.dart';

class AddFavoriteRequestModel extends AddFavoriteRequest {
  final int mediaId;
  final bool favorite;

  const AddFavoriteRequestModel({
    required super.mediaType,
    required this.mediaId,
    required this.favorite,
  }) : super(id: mediaId, isFavorite: favorite);

  Map<String, dynamic> toJson() => {
        "media_type": mediaType,
        "media_id": mediaId,
        "favorite": favorite,
      };
}
