import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/get_favorite_case.dart';

import '../../../../../core/domain/entities/response/all_movie_response.dart';

part 'get_favorites_event.dart';
part 'get_favorites_state.dart';

class GetFavoritesBloc extends Bloc<GetFavoritesEvent, GetFavoritesState> {
  final GetFavoriteCase getFavoriteCase;
  GetFavoritesBloc({required this.getFavoriteCase})
      : super(GetFavoritesInitial()) {
    on<GetFirstFavoriteEvent>((event, emit) async {
      emit(GetFavoritesLoading());
      final result = await getFavoriteCase.execute(1);

      result.fold(
        (failure) {
          emit(GetFavoritesError(errorMessage: failure.errorMessage));
        },
        (data) {
          if (data == null || data.movies.isEmpty) {
            emit(const GetFavoritesError(
                errorMessage: 'Data Favorites is empty'));
          } else {
            emit(GetFavoritesLoaded(
              movies: data.movies,
              hasReachedMax: data.page >= data.totalPages,
              currentPage: data.page,
              totalPages: data.totalPages,
            ));
          }
        },
      );
    });

    on<LoadMoreGetFavoritesEvent>(
      (event, emit) async {
        final currentState = state;
        if (currentState is GetFavoritesLoaded &&
            !currentState.hasReachedMax &&
            currentState.currentPage < currentState.totalPages) {
          final nextPage = currentState.currentPage + 1;
          final result = await getFavoriteCase.execute(nextPage);

          result.fold(
            (failure) {
              emit(currentState);
            },
            (data) {
              if (data == null || data.movies.isEmpty) {
                emit(currentState.copyWith(hasReachedMax: true));
              } else {
                final updatedMovies = List.of(currentState.movies)
                  ..addAll(data.movies);

                emit(GetFavoritesLoaded(
                  movies: updatedMovies,
                  hasReachedMax: data.page >= data.totalPages,
                  currentPage: data.page,
                  totalPages: data.totalPages,
                ));
              }
            },
          );
        }
      },
    );
  }
}
