import 'dart:convert';

import '../../domain/entities/response/failed_response.dart';

class FailedModel extends FailedResponse {
  final String statusMessage;

  const FailedModel({
    required this.statusMessage,
  }) : super(errorMessage: statusMessage);

  factory FailedModel.fromRawJson(String str) =>
      FailedModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FailedModel.fromJson(Map<String, dynamic> json) => FailedModel(
        statusMessage: json["status_message"],
      );

  Map<String, dynamic> toJson() => {
        "status_message": statusMessage,
      };
}
