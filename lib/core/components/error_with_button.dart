import 'package:flutter/material.dart';
import 'package:moviebox_flutter/core/components/spaces.dart';

import '../constants/theme.dart';

class ErrorWithButton extends StatelessWidget {
  final String message;
  final Function() onRetry;
  const ErrorWithButton(
      {super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: blackTextStyle.copyWith(
              fontSize: 15,
              fontWeight: semiBold,
            ),
          ),
          const SpaceHeight(10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: whiteColor, elevation: 3),
            onPressed: onRetry,
            child: Icon(
              Icons.refresh,
              color: indigoColor,
            ),
          )
        ],
      ),
    );
  }
}
