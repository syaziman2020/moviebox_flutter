import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'TMDB_URL')
  static const String url = _Env.url;

  @EnviedField(varName: 'TMDB_POSTER_URL')
  static const String posterBaseUrl = _Env.posterBaseUrl;

  @EnviedField(varName: 'TMDB_BACKDROP_URL')
  static const String backdropBaseUrl = _Env.backdropBaseUrl;

  @EnviedField(varName: 'TMDB_LOGO_URL')
  static const String logoBaseUrl = _Env.logoBaseUrl;

  @EnviedField(varName: 'TMDB_API_KEY', obfuscate: true)
  static String apiKey = _Env.apiKey;
}
