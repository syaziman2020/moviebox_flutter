import 'package:flutter/material.dart';
import '../../../../core/components/spaces.dart';
import '../../../../core/domain/entities/response/genre_response.dart';

import '../../../../core/constants/theme.dart';

class CustomSortFilterDialog extends StatefulWidget {
  final List<GenreResponse> genres;
  final Function(String, List<int>) onApply;
  final String initialSortBy;
  final List<int> initialGenres;

  const CustomSortFilterDialog({
    super.key,
    required this.genres,
    required this.onApply,
    this.initialSortBy = '',
    this.initialGenres = const [],
  });

  @override
  State<CustomSortFilterDialog> createState() => _CustomSortFilterDialogState();
}

class _CustomSortFilterDialogState extends State<CustomSortFilterDialog> {
  late String _selectedSort;
  late List<int> _selectedGenres;

  final List<Map<String, String>> sortOptions = [
    {'label': 'Popularity', 'value': 'popularity.desc'},
    {'label': 'Rating', 'value': 'vote_average.desc'},
    {'label': 'Release Date', 'value': 'primary_release_date.desc'},
    {'label': 'Title A-Z', 'value': 'original_title.asc'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.initialSortBy;
    _selectedGenres = List.from(widget.initialGenres);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sort & Filter',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SpaceHeight(16),
              Text(
                'Sort By',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
              const SpaceHeight(8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: sortOptions.map((sort) {
                    final isSelected = _selectedSort == sort['value'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSort = isSelected ? '' : sort['value']!;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? indigoColor : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? indigoColor : greyColor,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          sort['label']!,
                          style: (isSelected ? whiteTextStyle : greyTextStyle)
                              .copyWith(
                            fontSize: 12,
                            fontWeight: medium,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SpaceHeight(16),
              Text(
                'Genres',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
              const SpaceHeight(8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.genres.map((genre) {
                    final isSelected = _selectedGenres.contains(genre.id);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedGenres.remove(genre.id);
                          } else {
                            _selectedGenres.add(genre.id);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? indigoColor : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? indigoColor : greyColor,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          genre.name,
                          style: (isSelected ? whiteTextStyle : greyTextStyle)
                              .copyWith(
                            fontSize: 12,
                            fontWeight: medium,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SpaceHeight(24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    widget.onApply(_selectedSort, _selectedGenres);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: indigoColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: whiteTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
