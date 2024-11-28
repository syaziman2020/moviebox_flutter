import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/datasources/add_favorite_local_datasource.dart';
import '../../../data/models/favorite_local_movie.dart';

part 'status_favorite_event.dart';
part 'status_favorite_state.dart';

class StatusFavoriteBloc
    extends Bloc<StatusFavoriteEvent, StatusFavoriteState> {
  final AddFavoriteLocalDatasource addFavoriteLocalDatasource;
  StatusFavoriteBloc({required this.addFavoriteLocalDatasource})
      : super(StatusFavoriteInitial()) {
    on<CheckFavoriteEvent>((event, emit) async {
      emit(StatusFavoriteLoading());
      final result = addFavoriteLocalDatasource.getAllFavorites();
      emit(StatusFavoriteLoaded(localFavorites: result));
    });
  }
}
