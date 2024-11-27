part of 'upcoming_bloc.dart';

sealed class UpcomingEvent extends Equatable {
  const UpcomingEvent();

  @override
  List<Object> get props => [];
}

class GetUpcomingEvent extends UpcomingEvent {}

class LoadMoreUpcomingEvent extends UpcomingEvent {}
