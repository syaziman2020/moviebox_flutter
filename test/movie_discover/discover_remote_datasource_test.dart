import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviebox_flutter/core/data/models/all_movie_model.dart';
import 'package:moviebox_flutter/core/data/models/failed_model.dart';
import 'package:moviebox_flutter/env.dart';
import 'package:moviebox_flutter/features/movie_discover/data/datasources/discover_remote_datasource.dart';

import 'discover_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DiscoverRemoteDatasource>(), MockSpec<Dio>()])
void main() {
  late MockDio mockDio;
  late DiscoverRemoteDatasourceImplementation
      discoverRemoteDatasourceImplementation;

  setUp(() {
    mockDio = MockDio();
    discoverRemoteDatasourceImplementation =
        DiscoverRemoteDatasourceImplementation(dio: mockDio);
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
  const String query = "venom";
  const String sortBy = "popularity.desc";
  const List<int> genres = [28];
  String concatList = genres.join(",");

  group('Search & Filter Remote Datasource', () {
    group("Discover Search", () {
      test("Success", () async {
        when(
          mockDio.get(
            '${Env.url}/search/movie?query=$query&page=$page',
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

        final response = await discoverRemoteDatasourceImplementation
            .getSearchDiscover(query, page);
        expect(response, fakeMovieModel);
      });

      test("Failed", () {
        when(mockDio.get(
          '${Env.url}/search/movie?query=$query&page=$page',
          options: anyNamed('options'),
        )).thenAnswer(
          (_) async => Response(
            data: fakeJsonFailed,
            statusCode: 400,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        expect(
            () => discoverRemoteDatasourceImplementation.getSearchDiscover(
                query, page),
            throwsA(isA<FailedModel>()));
      });
    });
    group("Filter Sort By & Genres", () {
      test("Success", () async {
        when(
          mockDio.get(
            '${Env.url}/discover/movie?sort_by=$sortBy&with_genres=$concatList&page=$page',
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

        final response = await discoverRemoteDatasourceImplementation
            .getDiscoverSortBy(sortBy, genres, page);
        expect(response, fakeMovieModel);
      });

      test("Failed", () {
        when(mockDio.get(
          '${Env.url}/discover/movie?sort_by=$sortBy&with_genres=$concatList&page=$page',
          options: anyNamed('options'),
        )).thenAnswer(
          (_) async => Response(
            data: fakeJsonFailed,
            statusCode: 400,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        expect(
            () => discoverRemoteDatasourceImplementation.getDiscoverSortBy(
                sortBy, genres, page),
            throwsA(isA<FailedModel>()));
      });
    });
  });
}
