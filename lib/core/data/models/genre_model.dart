import 'dart:convert';

import 'package:hive/hive.dart';
import '../../domain/entities/response/genre_response.dart';
part 'genre_model.g.dart';

@HiveType(typeId: 3)
class GenreModel extends GenreResponse {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  const GenreModel({
    required this.id,
    required this.name,
  }) : super(id: id, name: name);

  factory GenreModel.fromRawJson(String str) =>
      GenreModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  static List<GenreModel> fromJsonList(List<dynamic> data) {
    return data.isEmpty
        ? []
        : data.map((json) => GenreModel.fromJson(json)).toList();
  }
}
