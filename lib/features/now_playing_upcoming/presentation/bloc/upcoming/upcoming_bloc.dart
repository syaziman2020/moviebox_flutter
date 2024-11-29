import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/domain/entities/response/all_movie_response.dart';
import '../../../domain/usecases/get_upcoming_case.dart';

part 'upcoming_event.dart';
part 'upcoming_state.dart';

class UpcomingBloc extends Bloc<UpcomingEvent, UpcomingState> {
  final GetUpcomingCase getUpcomingCase;

  UpcomingBloc({required this.getUpcomingCase}) : super(UpcomingInitial()) {
    on<GetUpcomingEvent>((event, emit) async {
      emit(MovieLoadingUpcoming());
      final result = await getUpcomingCase.execute(1);

      result.fold(
        (failure) {
          emit(MovieErrorUpcoming(failure.errorMessage));
        },
        (data) {
          if (data == null || data.movies.isEmpty) {
            emit(const MovieErrorUpcoming('Data is empty'));
          } else {
            emit(UpcomingMovieLoaded(
              movies: data.movies,
              hasReachedMax: data.page >= data.totalPages,
              currentPage: data.page,
              totalPages: data.totalPages,
            ));
          }
        },
      );
    });

    on<LoadMoreUpcomingEvent>((event, emit) async {
      final currentState = state;
      if (currentState is UpcomingMovieLoaded &&
          !currentState.hasReachedMax &&
          currentState.currentPage < currentState.totalPages) {
        final nextPage = currentState.currentPage + 1;
        final result = await getUpcomingCase.execute(nextPage);

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

              emit(UpcomingMovieLoaded(
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
