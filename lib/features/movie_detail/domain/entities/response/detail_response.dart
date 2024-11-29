import 'package:equatable/equatable.dart';
import '../../../../../core/domain/entities/response/genre_response.dart';

class DetailResponse extends Equatable {
  final int id;
  final String backdropUrl;
  final List<GenreResponse> genres;
  final String title;
  final double popularity;
  final String posterUrl;
  final List<CompanyResponse> company;
  final DateTime release;
  final String overview;
  final double voteAverage;
  final String status;
  final String tagline;
  final List<ProductionCountryResponse> productionCountry;

  const DetailResponse({
    required this.id,
    required this.backdropUrl,
    required this.genres,
    required this.title,
    required this.popularity,
    required this.posterUrl,
    required this.company,
    required this.release,
    required this.overview,
    required this.voteAverage,
    required this.status,
    required this.tagline,
    required this.productionCountry,
  });

  @override
  List<Object?> get props => [
        id,
        backdropUrl,
        genres,
        title,
        popularity,
        posterUrl,
        company,
        release,
        overview,
        voteAverage,
        status,
        tagline,
        productionCountry,
      ];
}

class CompanyResponse extends Equatable {
  final String? logoUrl;
  final String name;
  const CompanyResponse({
    this.logoUrl,
    required this.name,
  });

  @override
  List<Object?> get props => [logoUrl, name];
}

class ProductionCountryResponse extends Equatable {
  final String name;

  const ProductionCountryResponse({
    required this.name,
  });

  @override
  List<Object?> get props => [name];
}
