import 'package:flutter/material.dart';

class NoGlowScrollBehavior extends ScrollBehavior {
  const NoGlowScrollBehavior() : super();
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
