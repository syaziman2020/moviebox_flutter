import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/data/models/genre_model.dart';
import '../../domain/entities/response/detail_response.dart';

part 'detail_model.g.dart';

@HiveType(typeId: 5)
class DetailModel extends DetailResponse {
  @HiveField(0)
  final String backdropPath;

  @HiveField(1)
  final List<GenreModel> genres;

  @HiveField(2)
  final int id;

  @HiveField(3)
  final String originalTitle;

  @HiveField(4)
  final String overview;

  @HiveField(5)
  final double popularity;

  @HiveField(6)
  final String posterPath;

  @HiveField(7)
  final List<ProductionCompany> productionCompanies;

  @HiveField(8)
  final List<ProductionCountry> productionCountries;

  @HiveField(9)
  final DateTime releaseDate;

  @HiveField(10)
  final String status;

  @HiveField(11)
  final String tagline;

  @HiveField(12)
  final double voteAverage;

  const DetailModel({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.releaseDate,
    required this.status,
    required this.tagline,
    required this.voteAverage,
    required this.productionCountries,
  }) : super(
          backdropUrl: backdropPath,
          status: status,
          id: id,
          tagline: tagline,
          voteAverage: voteAverage,
          genres: genres,
          overview: overview,
          popularity: popularity,
          posterUrl: posterPath,
          title: originalTitle,
          company: productionCompanies,
          release: releaseDate,
          productionCountry: productionCountries,
        );

  factory DetailModel.fromRawJson(String str) =>
      DetailModel.fromJson(json.decode(str));

  factory DetailModel.fromJson(Map<String, dynamic> json) => DetailModel(
        backdropPath: json["backdrop_path"],
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
        id: json["id"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        productionCompanies: List<ProductionCompany>.from(
            json["production_companies"]
                .map((x) => ProductionCompany.fromJson(x))),
        productionCountries: List<ProductionCountry>.from(
            json["production_countries"]
                .map((x) => ProductionCountry.fromJson(x))),
        releaseDate: DateTime.parse(json["release_date"]),
        status: json["status"],
        tagline: json["tagline"],
        voteAverage: json["vote_average"]?.toDouble(),
      );
}

@HiveType(typeId: 6)
class ProductionCompany extends CompanyResponse {
  @HiveField(0)
  final String? logoPath;

  @HiveField(1)
  final String name;

  ProductionCompany({
    this.logoPath,
    required this.name,
  }) : super(logoUrl: logoPath, name: name);

  factory ProductionCompany.fromRawJson(String str) =>
      ProductionCompany.fromJson(json.decode(str));

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      ProductionCompany(
        logoPath: json["logo_path"],
        name: json["name"],
      );
}

@HiveType(typeId: 7)
class ProductionCountry extends ProductionCountryResponse {
  @HiveField(0)
  final String name;

  ProductionCountry({
    required this.name,
  }) : super(name: name);

  factory ProductionCountry.fromRawJson(String str) =>
      ProductionCountry.fromJson(json.decode(str));

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      ProductionCountry(
        name: json["name"],
      );
}
