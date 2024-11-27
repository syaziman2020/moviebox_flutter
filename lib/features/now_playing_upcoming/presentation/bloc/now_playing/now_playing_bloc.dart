import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moviebox_flutter/features/now_playing_upcoming/domain/usecases/get_now_playing_case.dart';

import '../../../../../core/domain/entities/response/all_movie_response.dart';

part 'now_playing_event.dart';
part 'now_playing_state.dart';

class NowPlayingBloc extends Bloc<NowPlayingEvent, NowPlayingState> {
  final GetNowPlayingCase getNowPlayingCase;
  NowPlayingBloc({required this.getNowPlayingCase})
      : super(NowPlayingInitial()) {
    on<GetNowPlayingEvent>((event, emit) async {
      emit(MovieLoadingNowPlaying());
      final result = await getNowPlayingCase.execute(1);

      result.fold(
        (failure) {
          emit(MovieErrorNowPlaying(failure.errorMessage));
        },
        (data) {
          if (data == null || data.movies.isEmpty) {
            emit(const MovieErrorNowPlaying('Data is empty'));
          } else {
            emit(NowPlayingMovieLoaded(
              movies: data.movies,
              hasReachedMax: data.page >= data.totalPages,
              currentPage: data.page,
              totalPages: data.totalPages,
            ));
          }
        },
      );
    });

    on<LoadMoreNowPlayingEvent>((event, emit) async {
      final currentState = state;
      if (currentState is NowPlayingMovieLoaded &&
          !currentState.hasReachedMax &&
          currentState.currentPage < currentState.totalPages) {
        final nextPage = currentState.currentPage + 1;
        final result = await getNowPlayingCase.execute(nextPage);

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

              emit(NowPlayingMovieLoaded(
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
