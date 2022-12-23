//color enum dark mode, light mode (for background)
import 'package:flutter/material.dart';

enum ColorMode { dark, light }

//method that returns the color based on the mode
Color getBgColor(ColorMode mode) {
  switch (mode) {
    case ColorMode.dark:
      return Colors.grey[800]!;
    case ColorMode.light:
      return Colors.grey[0]!;
    default:
      return Colors.grey[0]!;
  }
}
