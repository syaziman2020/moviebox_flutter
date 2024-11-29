import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviebox_flutter/core/data/datasources/genre_remote_datasource.dart';
import 'package:moviebox_flutter/core/data/models/failed_model.dart';
import 'package:moviebox_flutter/core/data/models/genre_model.dart';
import 'package:moviebox_flutter/env.dart';

import 'genres_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GenreRemoteDatasource>(), MockSpec<Dio>()])
void main() {
  late MockDio mockDio;
  late GenreRemoteDatasourceImplementation genreRemoteDatasourceImplementation;

  setUp(() {
    mockDio = MockDio();
    genreRemoteDatasourceImplementation =
        GenreRemoteDatasourceImplementation(dio: mockDio);
  });

  final fakeJsonResult = {"id": 28, "name": "Action"};

  final fakeJsonFailed = {
    "status_message": "Invalid API key: You must be granted a valid key.",
  };

  final fakeGenreModel = GenreModel.fromJson(fakeJsonResult);

  group("Genres Remote Datasource", () {
    test("Success", () async {
      when(
        mockDio.get(
          '${Env.url}/genre/movie/list',
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {
            "genres": [fakeJsonResult]
          },
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '',
          ),
        ),
      );

      final response = await genreRemoteDatasourceImplementation.getGenres();
      expect(response, [fakeGenreModel]);
    });

    test("Failed", () {
      when(mockDio.get(
        '${Env.url}/genre/movie/list',
        options: anyNamed('options'),
      )).thenAnswer(
        (_) async => Response(
          data: fakeJsonFailed,
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      expect(() => genreRemoteDatasourceImplementation.getGenres(),
          throwsA(isA<FailedModel>()));
    });
  });
}
