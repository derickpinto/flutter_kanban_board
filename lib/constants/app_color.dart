import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryText = Colors.black; // Hex code: #D93535
  static const Color secondaryText = Color(0xFF2F2F2F); // Hex code: #D93535

  static const Color deepRed = Color(0xFFD93535); // Hex code: #D93535
  static const Color steelBlue = Color(0xFF6A6DCD); // Hex code: #6A6DCD
  static const Color vibrantPink = Color(0xFFC340A1); // Hex code: #C340A1
  static const Color mintGreen = Color(0xFF00A88B); // Hex code: #00A88B
  static const Color purpleShade = Color(0xFF8A6EE2); // Hex code: #8A6EE2
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFEEEEEE); // Hex code: #EEEEEE
  static const Color warmBeige = Color(0xFFF2E1C1); // Hex code: #F2E1C1
  static const Color skyBlue = Color(0xFF78B2F2); // Hex code: #78B2F2
  static const Color softMint = Color(0xFF98D9B8); // Hex code: #98D9B8
  static const Color mediumGray = Color(0xFF979797); // Hex code: #EEEEEE


  static List<Color> get colors => [
    deepRed,
    steelBlue,
    vibrantPink,
    mintGreen,
  ];

  static Color getRandomColor() {
    final random = Random();
    final index = random.nextInt(colors.length);
    return colors[index];
  }
}
