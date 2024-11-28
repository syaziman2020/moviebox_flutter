import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/response/detail_response.dart';

import '../../../domain/usecases/get_detail_case.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetDetailCase getDetailCase;
  MovieDetailBloc({required this.getDetailCase}) : super(MovieDetailInitial()) {
    on<MovieDetailLoadEvent>((event, emit) async {
      emit(MovieDetailLoading());
      final result = await getDetailCase.execute(event.id);
      result.fold((failure) {
        emit(MovieDetailError(message: failure.errorMessage));
      }, (data) {
        if (data == null) {
          emit(const MovieDetailError(message: 'Data is empty'));
        }
        emit(MovieDetailLoaded(detailResponse: data));
      });
    });
  }
}
