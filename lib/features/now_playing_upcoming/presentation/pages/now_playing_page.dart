import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox_flutter/features/now_playing_upcoming/presentation/bloc/now_playing/now_playing_bloc.dart';

import '../../../../core/components/card_movie.dart';
import '../../../../core/components/spaces.dart';
import '../../../../core/constants/theme.dart';
import '../bloc/upcoming/upcoming_bloc.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  final ScrollController _nowPlayingScrollController = ScrollController();
  bool _isNowPlayingLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _setupNowPlayingScrollController();
  }

  void _setupNowPlayingScrollController() {
    _nowPlayingScrollController.addListener(() {
      if (_nowPlayingScrollController.position.pixels >=
          _nowPlayingScrollController.position.maxScrollExtent * 0.95) {
        final currentState = context.read<NowPlayingBloc>().state;
        if (currentState is NowPlayingMovieLoaded &&
            !_isNowPlayingLoadingMore &&
            !currentState.hasReachedMax) {
          setState(() => _isNowPlayingLoadingMore = true);
          context.read<NowPlayingBloc>().add(LoadMoreNowPlayingEvent());
        }
      }
    });
  }

  @override
  void dispose() {
    _nowPlayingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NowPlayingBloc, NowPlayingState>(
      listener: (context, state) {
        if (state is NowPlayingMovieLoaded && _isNowPlayingLoadingMore) {
          setState(() => _isNowPlayingLoadingMore = false);
        }
      },
      builder: (context, state) {
        if (state is MovieLoadingNowPlaying) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MovieErrorNowPlaying) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.message,
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
                    context.read<NowPlayingBloc>().add(GetNowPlayingEvent());
                  },
                  child: Icon(
                    Icons.refresh,
                    color: indigoColor,
                  ),
                )
              ],
            ),
          );
        }

        if (state is NowPlayingMovieLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<NowPlayingBloc>().add(GetNowPlayingEvent());
            },
            child: ListView.builder(
              controller: _nowPlayingScrollController,
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
    );
  }
}
