import 'package:flutter/material.dart';
import '../../../../core/assets/assets.gen.dart';
import '../../../../core/constants/theme.dart';
import '../../../now_playing_upcoming/presentation/pages/main_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(
          const Duration(milliseconds: 2500),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
              );
            });
          }
          return Scaffold(
            body: Center(
              child: Image.asset(
                Assets.images.logo.path,
                width: (MediaQuery.of(context).orientation ==
                        Orientation.landscape)
                    ? MediaQuery.of(context).size.height * 0.7
                    : MediaQuery.of(context).size.width * 0.7,
                fit: BoxFit.cover,
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                'v1.0.0',
                textAlign: TextAlign.center,
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: semiBold,
                ),
              ),
            ),
          );
        });
  }
}
