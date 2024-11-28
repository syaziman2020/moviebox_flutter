import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/request/add_favorite_request.dart';
import '../../../domain/entities/response/add_favorite_response.dart';
import '../../../domain/usecases/add_favorite_case.dart';

part 'add_favorite_event.dart';
part 'add_favorite_state.dart';

class AddFavoriteBloc extends Bloc<AddFavoriteEvent, AddFavoriteState> {
  final AddFavoriteCase addFavoriteCase;

  AddFavoriteBloc({required this.addFavoriteCase})
      : super(AddFavoriteInitial()) {
    on<SendFavoriteEvent>((event, emit) async {
      emit(AddFavoriteLoading());
      final result = await addFavoriteCase.execute(event.request);
      result.fold(
        (failure) => emit(AddFavoriteError(message: failure.errorMessage)),
        (data) => data == null
            ? emit(const AddFavoriteError(message: 'Data Request is empty'))
            : emit(AddFavoriteLoaded(response: data)),
      );
    });
  }
}
