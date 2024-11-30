import '../../domain/entities/response/failed_response.dart';

class FailedModel extends FailedResponse {
  final String statusMessage;

  const FailedModel({
    required this.statusMessage,
  }) : super(errorMessage: statusMessage);

  factory FailedModel.fromJson(Map<String, dynamic> json) => FailedModel(
        statusMessage: json["status_message"],
      );
}
