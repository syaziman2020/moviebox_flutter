import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(14), // Ketebalan garis
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 3)
                ]), // Warna garis
            height: 1, // Tinggi garis
          ),
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
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetFavoritesError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.errorMessage,
                    style: blackTextStyle.copyWith(
                      fontSize: 15,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SpaceHeight(10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: whiteColor, elevation: 3),
                      onPressed: () {
                        context
                            .read<GetFavoritesBloc>()
                            .add(GetFirstFavoriteEvent());
                      },
                      child: Icon(
                        Icons.refresh,
                        color: indigoColor,
                      ))
                ],
              ),
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
