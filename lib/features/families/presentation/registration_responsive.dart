import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Keep existing phone ScreenUtil sizing; use stable logical pixels on tablets.
extension RegistrationResponsiveSize on num {
  double regW(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 600 ? toDouble() : w;

  double regH(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 600 ? toDouble() : h;

  double regR(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 600 ? toDouble() : r;

  double regSp(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 600
          ? math.max(14.0, toDouble() * 1.16)
          : sp;
}

extension RegistrationScreenSize on BuildContext {
  bool get registrationIsTablet => MediaQuery.sizeOf(this).shortestSide >= 600;
  bool get registrationIsWide => MediaQuery.sizeOf(this).width >= 900;
}
