import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../assets/assets.gen.dart';
import '../constants/env.dart';
import '../constants/theme.dart';
import '../data/models/genre_model.dart';
import '../domain/entities/response/all_movie_response.dart';
import '../presentation/bloc/genre/genre_bloc.dart';
import 'spaces.dart';

class CardMovie extends StatelessWidget {
  final MovieResponse data;

  const CardMovie({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 127,
      margin: const EdgeInsets.only(top: 17, bottom: 13),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: "${Env.posterBaseUrl}${data.posterUrl}",
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
                  data.title,
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
                      final genreNames = data.genre.map((id) {
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
                      NumberFormat("#.#").format(data.voteAvg),
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
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite_border_rounded),
            color: indigoColor,
            iconSize: 24,
          )
        ],
      ),
    );
  }
}
