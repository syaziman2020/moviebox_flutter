import '../../domain/entities/response/add_favorite_response.dart';

class AddFavoriteModel extends AddFavoriteResponse {
  final bool success;
  final String statusMessage;

  const AddFavoriteModel({
    required this.success,
    required this.statusMessage,
  }) : super(success: success, message: statusMessage);

  factory AddFavoriteModel.fromJson(Map<String, dynamic> json) =>
      AddFavoriteModel(
        success: json["success"],
        statusMessage: json["status_message"],
      );
}
