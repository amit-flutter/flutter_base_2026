import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double screenWidthFraction(BuildContext context, double fraction) =>
      screenWidth(context) * fraction;

  static double screenHeightFraction(BuildContext context, double fraction) =>
      screenHeight(context) * fraction;

  static double contentMaxWidth(BuildContext context) {
    final width = screenWidth(context);
    if (width > 1200) return 1200;
    return width;
  }
}
