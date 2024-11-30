import 'package:flutter/material.dart';

class CustomTextform extends StatelessWidget {
  final TextEditingController searchController;
  final String hintText;
  final Function(String) onChange;
  final Function() onPressed;
  const CustomTextform({
    super.key,
    required this.searchController,
    required this.onChange,
    required this.onPressed,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: onPressed,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onChanged: onChange),
    );
  }
}
