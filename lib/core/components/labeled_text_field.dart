import 'package:flutter/material.dart';

/// A reusable labeled [TextFormField] used across the app.
///
/// Keeps the same API surface needed by the callers in this project.
class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.maxLines = 1,
    this.validator,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.alignLabelWithHint = false,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final bool alignLabelWithHint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        alignLabelWithHint: alignLabelWithHint,
      ),
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      validator: validator,
      enabled: enabled,
    );
  }
}
