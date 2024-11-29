import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviebox_flutter/core/data/models/all_movie_model.dart';
import 'package:moviebox_flutter/core/data/models/failed_model.dart';
import 'package:moviebox_flutter/env.dart';
import 'package:moviebox_flutter/features/favorite_movies/data/datasources/favorite_remote_datasource.dart';
import 'package:moviebox_flutter/features/favorite_movies/data/models/add_favorite_model.dart';
import 'package:moviebox_flutter/features/favorite_movies/data/models/add_favorite_request_model.dart';

import 'favorite_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FavoriteRemoteDatasource>(), MockSpec<Dio>()])
void main() {
  late MockDio mockDio;
  late FavoriteRemoteDatasourceImplementation
      favoriteRemoteDatasourceImplementation;

  setUp(() {
    mockDio = MockDio();
    favoriteRemoteDatasourceImplementation =
        FavoriteRemoteDatasourceImplementation(dio: mockDio);
  });

  final fakeJsonResult = {
    "success": true,
    "status_code": 1,
    "status_message": "Success."
  };
  final fakeJsonResultFavorites = {
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
    "success": false,
    "status_code": 34,
    "status_message": "The resource you requested could not be found."
  };

  final fakeAddModel = AddFavoriteModel.fromJson(fakeJsonResult);
  final fakeFavoriteModel = AllMovieModel.fromJson(fakeJsonResultFavorites);
  const addRequest = AddFavoriteRequestModel(
      favorite: true, mediaId: 1292359, mediaType: 'movie');
  const int page = 1;

  group('Add Favorite & Get Favorites', () {
    group("addFavorite", () {
      test("Success", () async {
        when(
          mockDio.post(
            data: addRequest.toJson(),
            '${Env.url}/account/21653394/favorite',
            options: anyNamed('options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: fakeJsonResult,
            statusCode: 201,
            requestOptions: RequestOptions(
              path: '',
            ),
          ),
        );

        final response = await favoriteRemoteDatasourceImplementation
            .addFavorite(addRequest);
        expect(response, fakeAddModel);
      });

      test("Failed", () {
        when(mockDio.post(
          data: addRequest.toJson(),
          '${Env.url}/account/21653394/favorite',
          options: anyNamed('options'),
        )).thenAnswer(
          (_) async => Response(
            data: fakeJsonFailed,
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        expect(
            () =>
                favoriteRemoteDatasourceImplementation.addFavorite(addRequest),
            throwsA(isA<FailedModel>()));
      });
    });
    group("Get favorites", () {
      test("Success", () async {
        when(
          mockDio.get(
            '${Env.url}/account/21653394/favorite/movies?page=$page',
            options: anyNamed('options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: fakeJsonResultFavorites,
            statusCode: 200,
            requestOptions: RequestOptions(
              path: '',
            ),
          ),
        );

        final response =
            await favoriteRemoteDatasourceImplementation.getFavorites(page);
        expect(response, fakeFavoriteModel);
      });

      test("Failed", () {
        when(mockDio.get(
          '${Env.url}/account/21653394/favorite/movies?page=$page',
          options: anyNamed('options'),
        )).thenAnswer(
          (_) async => Response(
            data: fakeJsonFailed,
            statusCode: 400,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        expect(() => favoriteRemoteDatasourceImplementation.getFavorites(page),
            throwsA(isA<FailedModel>()));
      });
    });
  });
}
