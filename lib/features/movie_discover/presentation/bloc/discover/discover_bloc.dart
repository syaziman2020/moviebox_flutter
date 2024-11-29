import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/domain/entities/response/all_movie_response.dart';
import '../../../domain/usecases/get_discover_sortby_case.dart';
import '../../../domain/usecases/get_search_discover_case.dart';

part 'discover_event.dart';
part 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final GetSearchDiscoverCase getSearchDiscoverCase;
  final GetDiscoverSortbyCase getDiscoverSortbyCase;
  DiscoverBloc({
    required this.getSearchDiscoverCase,
    required this.getDiscoverSortbyCase,
  }) : super(DiscoverInitial()) {
    on<DiscoverSearchEvent>((event, emit) async {
      emit(DiscoverLoading());
      final result = await getSearchDiscoverCase.execute(event.query, 1);
      result.fold(
        (failure) {
          emit(DiscoverError(error: failure.errorMessage));
        },
        (data) {
          if (data == null || data.movies.isEmpty) {
            emit(const DiscoverError(error: 'Data is empty'));
          } else {
            emit(DiscoverLoaded(
              movies: data.movies,
              hasReachedMax: data.page >= data.totalPages,
              currentPage: data.page,
              totalPages: data.totalPages,
            ));
          }
        },
      );
    });
    on<DiscoverSortByEvent>((event, emit) async {
      emit(DiscoverLoading());
      final result =
          await getDiscoverSortbyCase.execute(event.sortBy, event.genres, 1);
      result.fold(
        (failure) {
          emit(DiscoverError(error: failure.errorMessage));
        },
        (data) {
          if (data == null || data.movies.isEmpty) {
            emit(const DiscoverError(error: 'Data is empty'));
          } else {
            emit(DiscoverLoaded(
              movies: data.movies,
              hasReachedMax: data.page >= data.totalPages,
              currentPage: data.page,
              totalPages: data.totalPages,
            ));
          }
        },
      );
    });

    on<LoadMoreDiscoverSearchEvent>((event, emit) async {
      final currentState = state;
      if (currentState is DiscoverLoaded &&
          !currentState.hasReachedMax &&
          currentState.currentPage < currentState.totalPages) {
        final nextPage = currentState.currentPage + 1;
        final result =
            await getSearchDiscoverCase.execute(event.query, nextPage);

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

              emit(DiscoverLoaded(
                movies: updatedMovies,
                hasReachedMax: data.page >= data.totalPages,
                currentPage: data.page,
                totalPages: data.totalPages,
              ));
            }
          },
        );
      }
    });

    on<LoadMoreDiscoverSortByEvent>((event, emit) async {
      final currentState = state;
      if (currentState is DiscoverLoaded &&
          !currentState.hasReachedMax &&
          currentState.currentPage < currentState.totalPages) {
        final nextPage = currentState.currentPage + 1;
        final result = await getDiscoverSortbyCase.execute(
            event.sortBy, event.genres, nextPage);

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

              emit(DiscoverLoaded(
                movies: updatedMovies,
                hasReachedMax: data.page >= data.totalPages,
                currentPage: data.page,
                totalPages: data.totalPages,
              ));
            }
          },
        );
      }
    });
  }
}
