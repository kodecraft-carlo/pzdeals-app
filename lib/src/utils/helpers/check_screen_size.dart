import 'dart:math';
import 'package:flutter/material.dart';

bool isSmallScreen(BuildContext context, {double maxScreenSizeInInches = 5.5}) {
  // Get the screen width and height in logical pixels
  final Size size = MediaQuery.of(context).size;
  // Get the device's pixel density
  final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

  // Calculate the width and height in physical pixels
  final double widthPixels = size.width * pixelRatio;
  final double heightPixels = size.height * pixelRatio;

  // Calculate the diagonal size in pixels using the Pythagorean theorem
  final double diagonalPixels =
      sqrt(widthPixels * widthPixels + heightPixels * heightPixels);

  // Convert the diagonal size from pixels to inches
  final double diagonalInches = diagonalPixels / pixelRatio;

  // Check if the screen size is equal to or smaller than the specified size
  return diagonalInches <= maxScreenSizeInInches;
}
