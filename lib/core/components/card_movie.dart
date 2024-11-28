import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moviebox_flutter/features/movie_detail/presentation/pages/movie_detail_page.dart';
import '../../features/favorite_movies/domain/entities/request/add_favorite_request.dart';
import '../../features/favorite_movies/presentation/bloc/add_favorite/add_favorite_bloc.dart';
import '../../features/favorite_movies/presentation/bloc/get_favorites/get_favorites_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/favorite_movies/presentation/bloc/status_favorite/status_favorite_bloc.dart';
import '../assets/assets.gen.dart';
import '../constants/env.dart';
import '../constants/theme.dart';
import '../data/models/genre_model.dart';
import '../domain/entities/response/all_movie_response.dart';
import '../presentation/bloc/genre/genre_bloc.dart';
import 'spaces.dart';

class CardMovie extends StatefulWidget {
  final MovieResponse data;

  const CardMovie({
    super.key,
    required this.data,
  });

  @override
  State<CardMovie> createState() => _CardMovieState();
}

class _CardMovieState extends State<CardMovie> {
  @override
  void initState() {
    super.initState();
    context.read<StatusFavoriteBloc>().add(CheckFavoriteEvent());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(id: widget.data.id),
          ),
        );
      },
      child: Container(
        height: 127,
        margin: const EdgeInsets.only(top: 17, bottom: 13),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: "${Env.posterBaseUrl}${widget.data.posterUrl}",
              imageBuilder: (context, imageProvider) => Container(
                width: 100,
                height: 127,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                  ),
                ),
              ),
              placeholder: (context, url) => SizedBox(
                width: 100,
                height: 127,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21),
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 100,
                height: 127,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Center(
                  child: Icon(
                    Icons.error,
                    color: indigoColor,
                  ),
                ),
              ),
            ),
            const SpaceWidth(20),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.title,
                    overflow: TextOverflow.ellipsis,
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: blackWeight,
                    ),
                  ),
                  const SpaceHeight(1),
                  BlocBuilder<GenreBloc, GenreState>(
                    builder: (context, state) {
                      if (state is GenreLoaded) {
                        final genreNames = widget.data.genre.map((id) {
                          final genre = state.genres.firstWhere(
                            (genre) => genre?.id == id,
                            orElse: () => const GenreModel(
                              id: 0,
                              name: '',
                            ),
                          );
                          return genre?.name;
                        }).join(', ');

                        return Text(
                          genreNames.isEmpty ? 'No Genre' : genreNames,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: greyTextStyle.copyWith(
                            fontSize: 13,
                            fontWeight: semiBold,
                          ),
                        );
                      }

                      return Text(
                        'Loading genres...',
                        style: greyTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: semiBold,
                        ),
                      );
                    },
                  ),
                  const SpaceHeight(18),
                  Row(
                    children: [
                      Image.asset(
                        Assets.images.starYellow.path,
                        width: 18,
                        height: 18,
                        color: yellowColor,
                      ),
                      const SpaceWidth(3),
                      Text(
                        NumberFormat("#.#").format(widget.data.voteAvg),
                        style: blackTextStyle.copyWith(
                          fontSize: 15,
                          fontWeight: semiBold,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            BlocListener<AddFavoriteBloc, AddFavoriteState>(
              listener: (context, state) {
                ScaffoldMessenger.of(context).clearSnackBars();

                Color backgroundColor;
                String message;
                Widget? leadingIcon;

                if (state is AddFavoriteLoading) {
                  backgroundColor = indigoColor;
                  message = 'loading...';
                  leadingIcon = const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  );
                } else if (state is AddFavoriteLoaded) {
                  backgroundColor = indigoColor;
                  message = state.response.message;
                  leadingIcon =
                      const Icon(Icons.check_circle, color: Colors.white);
                  context.read<GetFavoritesBloc>().add(GetFirstFavoriteEvent());
                  context.read<StatusFavoriteBloc>().add(CheckFavoriteEvent());
                } else if (state is AddFavoriteError) {
                  backgroundColor = Colors.red;
                  message = state.message;
                  leadingIcon =
                      const Icon(Icons.error_outline, color: Colors.white);
                } else {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (leadingIcon != null) ...[
                          leadingIcon,
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Text(
                            message,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: backgroundColor,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 2,
                      left: 20,
                      right: 20,
                    ),
                    duration: state is AddFavoriteLoading
                        ? const Duration(days: 1)
                        : const Duration(seconds: 2),
                    dismissDirection: DismissDirection.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              child: BlocBuilder<StatusFavoriteBloc, StatusFavoriteState>(
                builder: (context, state) {
                  if (state is StatusFavoriteLoaded) {
                    final isFavorite = state.localFavorites
                        .any((favorite) => favorite.movieId == widget.data.id);
                    if (isFavorite) {
                      return IconButton(
                        onPressed: () {
                          context.read<AddFavoriteBloc>().add(
                                SendFavoriteEvent(
                                  request: AddFavoriteRequest(
                                      mediaType: "movie",
                                      id: widget.data.id,
                                      isFavorite: false),
                                ),
                              );
                        },
                        icon: const Icon(Icons.favorite_rounded),
                        color: redColor,
                        iconSize: 24,
                      );
                    } else {
                      return IconButton(
                        onPressed: () {
                          context.read<AddFavoriteBloc>().add(
                                SendFavoriteEvent(
                                  request: AddFavoriteRequest(
                                      mediaType: "movie",
                                      id: widget.data.id,
                                      isFavorite: true),
                                ),
                              );
                        },
                        icon: const Icon(Icons.favorite_border_rounded),
                        color: indigoColor,
                        iconSize: 24,
                      );
                    }
                  }
                  return IconButton(
                    onPressed: () {
                      context.read<AddFavoriteBloc>().add(
                            SendFavoriteEvent(
                              request: AddFavoriteRequest(
                                  mediaType: "movie",
                                  id: widget.data.id,
                                  isFavorite: true),
                            ),
                          );
                    },
                    icon: const Icon(Icons.favorite_border_rounded),
                    color: indigoColor,
                    iconSize: 24,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
