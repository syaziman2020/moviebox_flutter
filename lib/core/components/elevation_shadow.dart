import 'package:flutter/material.dart';

class ElevationShadow extends StatelessWidget {
  const ElevationShadow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
          ),
        ],
      ),
      height: 1,
    );
  }
}
