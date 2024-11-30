import 'package:flutter/material.dart';

import '../constants/theme.dart';

class TextError extends StatelessWidget {
  final String message;
  const TextError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: blackTextStyle.copyWith(
          fontSize: 15,
          fontWeight: semiBold,
        ),
      ),
    );
  }
}
