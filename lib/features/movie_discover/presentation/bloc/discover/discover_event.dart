part of 'discover_bloc.dart';

sealed class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object?> get props => [];
}

class DiscoverSearchEvent extends DiscoverEvent {
  final String query;
  const DiscoverSearchEvent({
    required this.query,
  });
  @override
  List<Object?> get props => [query];
}

class LoadMoreDiscoverSearchEvent extends DiscoverEvent {
  final String query;
  const LoadMoreDiscoverSearchEvent({required this.query});
  @override
  List<Object?> get props => [query];
}

class LoadMoreDiscoverSortByEvent extends DiscoverEvent {
  final String sortBy;
  final List<int> genres;
  const LoadMoreDiscoverSortByEvent(
      {required this.sortBy, required this.genres});
  @override
  List<Object?> get props => [sortBy, genres];
}

class DiscoverSortByEvent extends DiscoverEvent {
  final String sortBy;
  final List<int> genres;
  const DiscoverSortByEvent({
    required this.sortBy,
    required this.genres,
  });
  @override
  List<Object?> get props => [sortBy, genres];
}
