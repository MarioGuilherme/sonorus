import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

extension FontSizeExtension on TextStyle  {
  TextStyle withFontSize(int fontSize) => this.copyWith(fontSize: fontSize.sp);
}