import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/get_genre_case.dart';

import '../../../domain/entities/response/genre_response.dart';

part 'genre_event.dart';
part 'genre_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  final GetGenreCase getGenreCase;
  GenreBloc({required this.getGenreCase}) : super(GenreInitial()) {
    on<GenreEvent>((event, emit) async {
      emit(GenreLoading());
      final result = await getGenreCase.execute();
      result.fold(
        (failure) => emit(GenreError(message: failure.errorMessage)),
        (genres) => emit(GenreLoaded(genres: genres)),
      );
    });
  }
}
