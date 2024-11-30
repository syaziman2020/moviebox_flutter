import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/error_with_button.dart';
import '../../../../core/components/loading_indicator.dart';

import '../../../../core/components/card_movie.dart';
import '../bloc/upcoming/upcoming_bloc.dart';

class UpcomingPage extends StatefulWidget {
  const UpcomingPage({super.key});

  @override
  State<UpcomingPage> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  final ScrollController _upcomingScrollController = ScrollController();
  bool _isUpcomingLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _setupUpcomingScrollController();
  }

  void _setupUpcomingScrollController() {
    _upcomingScrollController.addListener(() {
      if (_upcomingScrollController.position.pixels >=
          _upcomingScrollController.position.maxScrollExtent * 0.95) {
        final currentState = context.read<UpcomingBloc>().state;
        if (currentState is UpcomingMovieLoaded &&
            !_isUpcomingLoadingMore &&
            !currentState.hasReachedMax) {
          setState(() => _isUpcomingLoadingMore = true);
          context.read<UpcomingBloc>().add(LoadMoreUpcomingEvent());
        }
      }
    });
  }

  @override
  void dispose() {
    _upcomingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpcomingBloc, UpcomingState>(
      listener: (context, state) {
        if (state is UpcomingMovieLoaded && _isUpcomingLoadingMore) {
          setState(() => _isUpcomingLoadingMore = false);
        }
      },
      builder: (context, state) {
        if (state is MovieLoadingUpcoming) {
          return const LoadingIndicator();
        }

        if (state is MovieErrorUpcoming) {
          ErrorWithButton(
            message: state.message,
            onRetry: () {
              context.read<UpcomingBloc>().add(GetUpcomingEvent());
            },
          );
        }

        if (state is UpcomingMovieLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<UpcomingBloc>().add(GetUpcomingEvent());
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _upcomingScrollController,
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
