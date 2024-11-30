import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/components/elevation_shadow.dart';
import '../../../../core/components/error_with_button.dart';
import '../../../../core/components/loading_indicator.dart';
import '../../../../core/assets/assets.gen.dart';
import '../../../../core/components/spaces.dart';
import '../bloc/movie_detail/movie_detail_bloc.dart';
import '../widgets/company_tile.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/theme.dart';
import '../../../../env.dart';
import '../../../favorite_movies/domain/entities/request/add_favorite_request.dart';
import '../../../favorite_movies/presentation/bloc/add_favorite/add_favorite_bloc.dart';
import '../../../favorite_movies/presentation/bloc/status_favorite/status_favorite_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    context.read<MovieDetailBloc>().add(MovieDetailLoadEvent(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar() {
      return AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Detail Movie',
          style: blackTextStyle.copyWith(
            fontSize: 16,
            fontWeight: blackWeight,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(14), // Ketebalan garis
          child: ElevationShadow(),
        ),
      );
    }

    Widget header({
      String? backdropUrl,
      String? title,
      String? genres,
      String? posterUrl,
      double? popularity,
      String? status,
      DateTime? releaseDate,
      double? voteAvg,
    }) {
      return Stack(
        children: [
          CachedNetworkImage(
            imageUrl: "${Env.backdropBaseUrl}/$backdropUrl",
            imageBuilder: (context, imageProvider) => Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.28,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imageProvider,
                ),
              ),
            ),
            placeholder: (context, url) => SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.28,
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.28,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
              child: Center(
                child: Icon(
                  Icons.error,
                  color: indigoColor,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.28,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(
                0.6,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: "${Env.posterBaseUrl}/$posterUrl",
                  imageBuilder: (context, imageProvider) => Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageProvider,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => SizedBox(
                    width: MediaQuery.of(context).size.width * 0.28,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade500,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.error,
                        color: indigoColor,
                      ),
                    ),
                  ),
                ),
                const SpaceWidth(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        title ?? "unknown",
                        softWrap: true,
                        style: whiteTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: blackWeight,
                        ),
                      ),
                    ),
                    const SpaceHeight(5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        genres ?? '-',
                        softWrap: true,
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SpaceHeight(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          Assets.images.starYellow.path,
                          width: 14,
                        ),
                        const SpaceWidth(5),
                        Text(
                          NumberFormat('#.#').format(voteAvg ?? 0),
                          style: greyTextStyle.copyWith(
                            color: whiteColor.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SpaceHeight(5),
                    Text(
                      DateFormat('y-MM-dd')
                          .format(releaseDate ?? DateTime.now()),
                      style: greyTextStyle.copyWith(
                        color: whiteColor.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    const SpaceHeight(5),
                    Text(
                      'Popularity ${popularity ?? 0}',
                      style: greyTextStyle.copyWith(
                        color: whiteColor.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 7),
                      decoration: BoxDecoration(
                        color: indigoColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 0.5,
                          color: whiteColor,
                        ),
                      ),
                      child: Text(
                        status ?? "unknown",
                        style: greyTextStyle.copyWith(
                          color: whiteColor,
                          fontSize: 11,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailLoaded) {
              final data = state.detailResponse;
              final genres = data?.genres.map((e) => e.name).join(', ') ?? '';
              final productionCountry =
                  data?.productionCountry.map((e) => e.name).join(', ') ?? '';
              return Column(
                children: [
                  header(
                    backdropUrl: data?.backdropUrl,
                    title: data?.title,
                    genres: genres,
                    posterUrl: data?.posterUrl,
                    popularity: data?.popularity,
                    status: data?.status,
                    releaseDate: data?.release,
                    voteAvg: data?.voteAverage,
                  ),
                  const SpaceHeight(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                data?.tagline ?? '-',
                                softWrap: true,
                                style: blackTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: semiBold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            BlocBuilder<StatusFavoriteBloc,
                                StatusFavoriteState>(
                              builder: (context, state) {
                                if (state is StatusFavoriteLoaded) {
                                  final isFavorite = state.localFavorites.any(
                                      (favorite) =>
                                          favorite.movieId == widget.id);
                                  if (isFavorite) {
                                    return IconButton(
                                      onPressed: () {
                                        context.read<AddFavoriteBloc>().add(
                                              SendFavoriteEvent(
                                                request: AddFavoriteRequest(
                                                    mediaType: "movie",
                                                    id: widget.id,
                                                    isFavorite: false),
                                              ),
                                            );
                                      },
                                      icon: const Icon(Icons.favorite_rounded),
                                      color: redColor,
                                      iconSize: 26,
                                    );
                                  } else {
                                    return IconButton(
                                      onPressed: () {
                                        context.read<AddFavoriteBloc>().add(
                                              SendFavoriteEvent(
                                                request: AddFavoriteRequest(
                                                    mediaType: "movie",
                                                    id: widget.id,
                                                    isFavorite: true),
                                              ),
                                            );
                                      },
                                      icon: const Icon(
                                          Icons.favorite_border_rounded),
                                      color: indigoColor,
                                      iconSize: 26,
                                    );
                                  }
                                }
                                return IconButton(
                                  onPressed: () {
                                    context.read<AddFavoriteBloc>().add(
                                          SendFavoriteEvent(
                                            request: AddFavoriteRequest(
                                                mediaType: "movie",
                                                id: widget.id,
                                                isFavorite: true),
                                          ),
                                        );
                                  },
                                  icon:
                                      const Icon(Icons.favorite_border_rounded),
                                  color: indigoColor,
                                  iconSize: 26,
                                );
                              },
                            ),
                          ],
                        ),
                        Text(
                          'Overview',
                          style: blackTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: bold,
                          ),
                        ),
                        const SpaceHeight(10),
                        Text(
                          data?.overview ?? '-',
                          style: blackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: medium,
                              color: blackColor.withOpacity(0.7)),
                        ),
                        const SpaceHeight(16),
                        Text(
                          'Company',
                          style: blackTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: bold,
                          ),
                        ),
                        const SpaceHeight(10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.flag,
                              size: 16,
                              color: indigoColor,
                            ),
                            const SpaceWidth(5),
                            Flexible(
                              child: Text(
                                productionCountry,
                                textAlign: TextAlign.start,
                                softWrap: true,
                                style: blackTextStyle.copyWith(
                                  fontSize: 10,
                                  fontWeight: semiBold,
                                  color: blackColor.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SpaceHeight(10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...data?.company
                                      .map((e) => CompanyTile(
                                          companyName: e.name,
                                          imageUrl:
                                              "${Env.logoBaseUrl}/${e.logoUrl}"))
                                      .toList() ??
                                  [],
                            ],
                          ),
                        ),
                        const SpaceHeight(10),
                      ],
                    ),
                  )
                ],
              );
            } else if (state is MovieDetailLoading) {
              return Column(
                children: [
                  SpaceHeight(
                    MediaQuery.of(context).size.height * 0.3,
                  ),
                  const LoadingIndicator(),
                ],
              );
            } else if (state is MovieDetailError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpaceHeight(
                      MediaQuery.of(context).size.height * 0.3,
                    ),
                    ErrorWithButton(
                      message: state.message,
                      onRetry: () {
                        context.read<MovieDetailBloc>().add(
                              MovieDetailLoadEvent(widget.id),
                            );
                      },
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
