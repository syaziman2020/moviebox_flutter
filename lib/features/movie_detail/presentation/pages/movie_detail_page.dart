import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviebox_flutter/core/components/spaces.dart';
import 'package:moviebox_flutter/features/movie_detail/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:moviebox_flutter/features/now_playing_upcoming/presentation/pages/main_page.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/env.dart';
import '../../../../core/constants/theme.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Detail Movie',
          style: blackTextStyle.copyWith(
            fontSize: 16,
            fontWeight: blackWeight,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(14), // Ketebalan garis
          child: Container(
            decoration:
                BoxDecoration(color: blackColor.withOpacity(0.05), boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.05),
                blurRadius: 3,
              )
            ]), // Warna garis
            height: 1, // Tinggi garis
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailLoaded) {
              return Column(
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            "${Env.backdropBaseUrl}/${state.detailResponse?.backdropUrl}",
                        imageBuilder: (context, imageProvider) => Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.26,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageProvider,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.26,
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
                          height: MediaQuery.of(context).size.height * 0.26,
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
                        height: MediaQuery.of(context).size.height * 0.26,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(
                            0.6,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  "${Env.posterBaseUrl}/${state.detailResponse?.posterUrl}",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: MediaQuery.of(context).size.width * 0.28,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
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
                                Text(
                                  state.detailResponse?.title ?? "unknown",
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: blackWeight,
                                  ),
                                ),
                                const SpaceHeight(5),
                                Text(
                                  "ini genre",
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is MovieDetailLoading) {
              return Column(
                children: [
                  SpaceHeight(
                    MediaQuery.of(context).size.height * 0.3,
                  ),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
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
                          context
                              .read<MovieDetailBloc>()
                              .add(MovieDetailLoadEvent(widget.id));
                        },
                        child: Icon(
                          Icons.refresh,
                          color: indigoColor,
                        ))
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
