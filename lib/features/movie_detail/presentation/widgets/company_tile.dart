import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/components/spaces.dart';
import '../../../../core/constants/theme.dart';

class CompanyTile extends StatelessWidget {
  const CompanyTile(
      {super.key, required this.companyName, required this.imageUrl});

  final String imageUrl;
  final String companyName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: MediaQuery.of(context).size.width * 0.17,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imageProvider,
                ),
              ),
            ),
            placeholder: (context, url) => SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.width * 0.15,
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
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
          const SpaceHeight(10),
          Text(
            companyName,
            textAlign: TextAlign.center,
            softWrap: true,
            style: blackTextStyle.copyWith(
              fontSize: 10,
              fontWeight: semiBold,
              color: blackColor.withOpacity(0.7),
            ),
          )
        ],
      ),
    );
  }
}
