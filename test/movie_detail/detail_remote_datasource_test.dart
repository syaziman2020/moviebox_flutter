import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviebox_flutter/core/data/models/failed_model.dart';
import 'package:moviebox_flutter/env.dart';
import 'package:moviebox_flutter/features/movie_detail/data/datasources/detail_remote_datasource.dart';
import 'package:moviebox_flutter/features/movie_detail/data/models/detail_model.dart';

import 'detail_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DetailRemoteDatasource>(), MockSpec<Dio>()])
void main() {
  late MockDio mockDio;
  late DetailRemoteDatasourceImplementation
      detailRemoteDatasourceImplementation;

  setUp(() {
    mockDio = MockDio();
    detailRemoteDatasourceImplementation =
        DetailRemoteDatasourceImplementation(dio: mockDio);
  });

  final fakeJsonResult = {
    "backdrop_path": "backdrop.jpg",
    "genres": [
      {"id": 1, "name": "Action"}
    ],
    "id": 123,
    "original_title": "Movie Title",
    "overview": "Movie description",
    "popularity": 8.5,
    "poster_path": "poster.jpg",
    "production_companies": [
      {"logo_path": "logo.png", "name": "Studio Name"}
    ],
    "production_countries": [
      {"name": "United States"}
    ],
    "release_date": "2024-01-01",
    "status": "Released",
    "tagline": "Movie tagline",
    "vote_average": 7.8
  };

  final fakeJsonFailed = {
    "status_message": "The resource you requested could not be found.",
  };

  final fakeDetailModel = DetailModel.fromJson(fakeJsonResult);
  const int id = 1292359;

  group("Movie Detail Remote Datasource", () {
    test("Success", () async {
      when(
        mockDio.get(
          '${Env.url}/movie/$id',
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: fakeJsonResult,
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '',
          ),
        ),
      );

      final response = await detailRemoteDatasourceImplementation.getDetail(id);
      expect(response, fakeDetailModel);
    });

    test("Failed", () {
      when(mockDio.get(
        '${Env.url}/movie/$id',
        options: anyNamed('options'),
      )).thenAnswer(
        (_) async => Response(
          data: fakeJsonFailed,
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      expect(() => detailRemoteDatasourceImplementation.getDetail(id),
          throwsA(isA<FailedModel>()));
    });
  });
}
