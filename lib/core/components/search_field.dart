import 'package:flutter/material.dart';

/// Reusable search field used across the app.
///
/// - [controller]: the text controller for the field
/// - [hintText]: optional hint to display
/// - [onChanged]: called when the text changes
/// - [showClear]: whether to show the clear button
/// - [onClear]: callback when clear pressed
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText,
    this.showClear = false,
    this.onClear,
  });

  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String> onChanged;
  final bool showClear;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText ?? 'Search',
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            showClear
                ? IconButton(icon: const Icon(Icons.clear), onPressed: onClear)
                : null,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      onChanged: onChanged,
    );
  }
}
