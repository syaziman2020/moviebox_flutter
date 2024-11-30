import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox_flutter/core/components/elevation_shadow.dart';
import 'package:moviebox_flutter/core/components/error_with_button.dart';
import 'package:moviebox_flutter/core/components/loading_indicator.dart';
import '../bloc/get_favorites/get_favorites_bloc.dart';

import '../../../../core/components/card_movie.dart';
import '../../../../core/components/spaces.dart';
import '../../../../core/constants/theme.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ScrollController _getFavoritesScrollController = ScrollController();
  bool _isGetFavoritesLoadingMore = false;
  @override
  void initState() {
    context.read<GetFavoritesBloc>().add(GetFirstFavoriteEvent());
    super.initState();
    _setupGetFavoritesScrollController();
  }

  void _setupGetFavoritesScrollController() {
    _getFavoritesScrollController.addListener(() {
      if (_getFavoritesScrollController.position.pixels >=
          _getFavoritesScrollController.position.maxScrollExtent * 0.95) {
        final currentState = context.read<GetFavoritesBloc>().state;
        if (currentState is GetFavoritesLoaded &&
            !_isGetFavoritesLoadingMore &&
            !currentState.hasReachedMax) {
          setState(() => _isGetFavoritesLoadingMore = true);
          context.read<GetFavoritesBloc>().add(LoadMoreGetFavoritesEvent());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Favorites',
          style: blackTextStyle.copyWith(
            fontSize: 16,
            fontWeight: blackWeight,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(14), // Ketebalan garis
          child: ElevationShadow(),
        ),
      ),
      body: BlocConsumer<GetFavoritesBloc, GetFavoritesState>(
        listener: (context, state) {
          if (state is GetFavoritesLoaded && _isGetFavoritesLoadingMore) {
            setState(() => _isGetFavoritesLoadingMore = false);
          }
        },
        builder: (context, state) {
          if (state is GetFavoritesLoading) {
            return const LoadingIndicator();
          }

          if (state is GetFavoritesError) {
            return ErrorWithButton(
              message: state.errorMessage,
              onRetry: () {
                context.read<GetFavoritesBloc>().add(GetFirstFavoriteEvent());
              },
            );
          }

          if (state is GetFavoritesLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<GetFavoritesBloc>().add(GetFirstFavoriteEvent());
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _getFavoritesScrollController,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: state.movies.length + (state.hasReachedMax ? 0 : 1),
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
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
