import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../favorite_movies/presentation/pages/favorites_page.dart';
import '../bloc/change_page/change_page_bloc.dart';
import '../bloc/now_playing/now_playing_bloc.dart';
import 'now_playing_page.dart';
import 'upcoming_page.dart';

import '../../../../core/constants/theme.dart';
import '../bloc/upcoming/upcoming_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    context.read<NowPlayingBloc>().add(GetNowPlayingEvent());
    context.read<UpcomingBloc>().add(GetUpcomingEvent());

    super.initState();
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Moviebox',
            style: blackTextStyle.copyWith(
              fontSize: 28,
              fontWeight: blackWeight,
            ),
          ),
          Text(
            'Watch much easier',
            style: greyTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(14), // Ketebalan garis
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 3)
              ]), // Warna garis
          height: 1, // Tinggi garis
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritesPage(),
              ),
            );
          },
          icon: Icon(
            Icons.favorite_border_rounded,
            color: blackColor,
            size: 30,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.search,
            color: blackColor,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget content(int index) {
    switch (index) {
      case 0:
        return const NowPlayingPage();
      case 1:
        return const UpcomingPage();
      default:
        return const NowPlayingPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: _buildAppBar(),
      body: BlocBuilder<ChangePageBloc, int>(
        builder: (context, state) {
          return content(state);
        },
      ),
      bottomNavigationBar: BlocBuilder<ChangePageBloc, int>(
        builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: state,
            selectedItemColor: indigoColor,
            unselectedItemColor: indigoColor,
            onTap: (index) {
              context.read<ChangePageBloc>().add(ChangeIndexEvent(index));
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.movie_outlined),
                activeIcon: Icon(Icons.movie),
                label: 'Now Playing',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.upcoming_outlined),
                activeIcon: Icon(Icons.upcoming),
                label: 'Upcoming Movie',
              ),
            ],
          );
        },
      ),
    );
  }
}
