import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/elevation_shadow.dart';
import '../../../../core/components/loading_indicator.dart';
import '../../../../core/components/text_error.dart';
import '../widgets/custom_textform.dart';
import '../bloc/discover/discover_bloc.dart';

import '../../../../core/components/card_movie.dart';
import '../../../../core/constants/theme.dart';
import 'package:flutter/foundation.dart' show listEquals;

import '../../../../core/domain/entities/response/genre_response.dart';
import '../../../../core/presentation/bloc/genre/genre_bloc.dart';
import '../widgets/custom_sort_filtering_dialog.dart';

class MovieDiscoverPage extends StatefulWidget {
  const MovieDiscoverPage({super.key});

  @override
  State<MovieDiscoverPage> createState() => _MovieDiscoverPageState();
}

class _MovieDiscoverPageState extends State<MovieDiscoverPage> {
  final ScrollController _getDiscoverScrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  List<int> genres = [];
  bool _isGetDiscoverLoadingMore = false;
  String sortBy = '';
  Timer? _debounce;

  bool _isSearchMode = false;
  String _currentQuery = '';
  String _currentSortBy = '';
  List<int> _currentGenres = [];

  @override
  void initState() {
    super.initState();
    _setupGetDiscoverScrollController();
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _setupGetDiscoverScrollController() {
    _getDiscoverScrollController.addListener(() {
      if (_getDiscoverScrollController.position.pixels >=
          _getDiscoverScrollController.position.maxScrollExtent * 0.95) {
        final currentState = context.read<DiscoverBloc>().state;
        if (currentState is DiscoverLoaded &&
            !_isGetDiscoverLoadingMore &&
            !currentState.hasReachedMax) {
          setState(() => _isGetDiscoverLoadingMore = true);
          _loadMoreContent();
        }
      }
    });
  }

  void _loadMoreContent() {
    if (_isSearchMode && _currentQuery.isNotEmpty) {
      context.read<DiscoverBloc>().add(
            LoadMoreDiscoverSearchEvent(
              query: _currentQuery,
            ),
          );
    } else if (_currentSortBy.isNotEmpty || _currentGenres.isNotEmpty) {
      context.read<DiscoverBloc>().add(
            LoadMoreDiscoverSortByEvent(
              sortBy: _currentSortBy,
              genres: _currentGenres,
            ),
          );
    }
  }

  void _handleSortAndFilterChange({
    required String sortBy,
    required List<int> genres,
  }) {
    if (sortBy != _currentSortBy || !listEquals(_currentGenres, genres)) {
      setState(() {
        _isSearchMode = false;
        _currentQuery = '';
        _currentSortBy = sortBy;
        _currentGenres = genres;
        searchController.clear();
      });

      if (sortBy.isNotEmpty || genres.isNotEmpty) {
        context.read<DiscoverBloc>().add(
              DiscoverSortByEvent(
                sortBy: sortBy,
                genres: genres,
              ),
            );
      }
    }
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      backgroundColor: primaryColor,
      centerTitle: true,
      title: Text(
        'Discover',
        style: blackTextStyle.copyWith(
          fontSize: 16,
          fontWeight: blackWeight,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => BlocBuilder<GenreBloc, GenreState>(
                builder: (context, state) {
                  if (state is GenreLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is GenreError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: blackTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: medium,
                        ),
                      ),
                    );
                  }

                  if (state is GenreLoaded) {
                    return CustomSortFilterDialog(
                      genres: state.genres
                          .whereType<GenreResponse>()
                          .toList(), // Mengakses data dari GenreResponse
                      initialSortBy: _currentSortBy,
                      initialGenres: _currentGenres,
                      onApply: (sortBy, selectedGenres) {
                        _handleSortAndFilterChange(
                          sortBy: sortBy,
                          genres: selectedGenres,
                        );
                        Navigator.pop(context);
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            );
          },
          icon: Stack(
            children: [
              const Icon(Icons.filter_list),
              if (_currentSortBy.isNotEmpty || _currentGenres.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: indigoColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      (_currentGenres.length + (_currentSortBy.isEmpty ? 0 : 1))
                          .toString(),
                      style: whiteTextStyle.copyWith(
                        fontSize: 10,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(14),
        child: ElevationShadow(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          CustomTextform(
            hintText: 'Search movies...',
            searchController: searchController,
            onChange: (value) {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                if (value.trim().isNotEmpty) {
                  setState(() {
                    _isSearchMode = true;
                    _currentQuery = value.trim();
                  });
                  context
                      .read<DiscoverBloc>()
                      .add(DiscoverSearchEvent(query: value.trim()));
                }
              });
            },
            onPressed: () {
              searchController.clear();
              setState(() {
                _isSearchMode = false;
                _currentQuery = '';
              });
              if (_currentSortBy.isNotEmpty || _currentGenres.isNotEmpty) {
                context.read<DiscoverBloc>().add(
                      DiscoverSortByEvent(
                        sortBy: _currentSortBy,
                        genres: _currentGenres,
                      ),
                    );
              }
            },
          ),
          Expanded(
            child: BlocConsumer<DiscoverBloc, DiscoverState>(
              listener: (context, state) {
                if (state is DiscoverLoaded && _isGetDiscoverLoadingMore) {
                  setState(() => _isGetDiscoverLoadingMore = false);
                }
              },
              builder: (context, state) {
                if (state is DiscoverLoading) {
                  return const LoadingIndicator();
                }

                if (state is DiscoverError) {
                  return TextError(message: state.error);
                }

                if (state is DiscoverLoaded) {
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _getDiscoverScrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount:
                        state.movies.length + (state.hasReachedMax ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index >= state.movies.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return CardMovie(
                        data: state.movies[index],
                      );
                    },
                  );
                }

                return const TextError(
                    message: "No items match your search\n or filter criteria");
              },
            ),
          ),
        ],
      ),
    );
  }
}
