import 'dart:convert';

import '../../domain/entities/request/add_favorite_request.dart';

class AddFavoriteRequestModel extends AddFavoriteRequest {
  final String mediaType;
  final int mediaId;
  final bool favorite;

  const AddFavoriteRequestModel({
    required this.mediaType,
    required this.mediaId,
    required this.favorite,
  }) : super(mediaType: mediaType, id: mediaId, isFavorite: favorite);

  factory AddFavoriteRequestModel.fromRawJson(String str) =>
      AddFavoriteRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddFavoriteRequestModel.fromJson(Map<String, dynamic> json) =>
      AddFavoriteRequestModel(
        mediaType: json["media_type"],
        mediaId: json["media_id"],
        favorite: json["favorite"],
      );

  Map<String, dynamic> toJson() => {
        "media_type": mediaType,
        "media_id": mediaId,
        "favorite": favorite,
      };
}
