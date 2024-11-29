import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviebox_flutter/core/data/models/all_movie_model.dart';
import 'package:moviebox_flutter/core/data/models/failed_model.dart';
import 'package:moviebox_flutter/env.dart';
import 'package:moviebox_flutter/features/now_playing_upcoming/data/datasources/movie_remote_datasource.dart';

import 'playing_upcoming_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MovieRemoteDatasource>(), MockSpec<Dio>()])
void main() {
  late MockDio mockDio;
  late MovieRemoteDataSourceImplementation movieRemoteDataSourceImplementation;

  setUp(() {
    mockDio = MockDio();
    movieRemoteDataSourceImplementation =
        MovieRemoteDataSourceImplementation(dio: mockDio);
  });

  final fakeJsonResult = {
    "page": 1,
    "results": [
      {
        "genre_ids": [28, 12, 16],
        "id": 123,
        "popularity": 234,
        "poster_path": "/path/to/poster.jpg",
        "title": "Movie Title",
        "vote_average": 7.5
      }
    ],
    "total_pages": 10
  };

  final fakeJsonFailed = {
    "status_message":
        "Invalid page: Pages start at 1 and max at 500. They are expected to be an integer.",
  };

  final fakeMovieModel = AllMovieModel.fromJson(fakeJsonResult);
  const int page = 1;

  group('Now Playing & Upcoming Remote Datasource', () {
    group("GetUpcoming", () {
      test("Success", () async {
        when(
          mockDio.get(
            '${Env.url}/movie/upcoming?page=$page',
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

        final response =
            await movieRemoteDataSourceImplementation.getUpcoming(page);
        expect(response, fakeMovieModel);
      });

      test("Failed", () {
        when(mockDio.get(
          '${Env.url}/movie/upcoming?page=$page',
          options: anyNamed('options'),
        )).thenAnswer(
          (_) async => Response(
            data: fakeJsonFailed,
            statusCode: 400,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        expect(() => movieRemoteDataSourceImplementation.getUpcoming(page),
            throwsA(isA<FailedModel>()));
      });
    });
    group("GetNowPlaying", () {
      test("Success", () async {
        when(
          mockDio.get(
            '${Env.url}/movie/now_playing?page=$page',
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

        final response =
            await movieRemoteDataSourceImplementation.getNowPlaying(page);
        expect(response, fakeMovieModel);
      });

      test("Failed", () {
        when(mockDio.get(
          '${Env.url}/movie/now_playing?page=$page',
          options: anyNamed('options'),
        )).thenAnswer(
          (_) async => Response(
            data: fakeJsonFailed,
            statusCode: 400,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        expect(() => movieRemoteDataSourceImplementation.getNowPlaying(page),
            throwsA(isA<FailedModel>()));
      });
    });
  });
}
