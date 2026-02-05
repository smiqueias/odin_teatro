import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/foundation/lerp.dart';

import 'constants.dart';
import 'fonts.dart';

final class OdinFontSize {
  const OdinFontSize({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.base,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.xxxxl,
  });

  final double xxs;
  final double xs;
  final double sm;
  final double base;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;
  final double xxxxl;

  static OdinFontSize lerp(OdinFontSize a, OdinFontSize b, double t) {
    return OdinFontSize(
      xxs: lerpDouble(a.xxs, b.xxs, t),
      xs: lerpDouble(a.xs, b.xs, t),
      sm: lerpDouble(a.sm, b.sm, t),
      base: lerpDouble(a.base, b.base, t),
      md: lerpDouble(a.md, b.md, t),
      lg: lerpDouble(a.lg, b.lg, t),
      xl: lerpDouble(a.xl, b.xl, t),
      xxl: lerpDouble(a.xxl, b.xxl, t),
      xxxl: lerpDouble(a.xxxl, b.xxxl, t),
      xxxxl: lerpDouble(a.xxxxl, b.xxxxl, t),
    );
  }

  OdinFontSize copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? base,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
    double? xxxxl,
  }) {
    return OdinFontSize(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      base: base ?? this.base,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
      xxxxl: xxxxl ?? this.xxxxl,
    );
  }
}

final class OdinFontWeight {
  const OdinFontWeight({
    required this.regular,
    required this.bold,
  });

  final FontWeight regular;
  final FontWeight bold;

  static OdinFontWeight lerp(OdinFontWeight a, OdinFontWeight b, double t) => t < 0.5 ? a : b;

  OdinFontWeight copyWith({
    FontWeight? regular,
    FontWeight? bold,
  }) {
    return OdinFontWeight(
      regular: regular ?? this.regular,
      bold: bold ?? this.bold,
    );
  }
}

final class OdinLineHeight {
  const OdinLineHeight({
    required this.small,
    required this.medium,
    required this.large,
  });

  final double small;
  final double medium;
  final double large;

  static OdinLineHeight lerp(OdinLineHeight a, OdinLineHeight b, double t) {
    return OdinLineHeight(
      small: lerpDouble(a.small, b.small, t),
      medium: lerpDouble(a.medium, b.medium, t),
      large: lerpDouble(a.large, b.large, t),
    );
  }

  OdinLineHeight copyWith({
    double? small,
    double? medium,
    double? large,
  }) {
    return OdinLineHeight(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
    );
  }
}

const _baseTextStyle = TextStyle(
  leadingDistribution: TextLeadingDistribution.even,
  letterSpacing: 0.0,
  package: kTeatroPackage,
);

final class OdinTypography {
  OdinTypography({
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    required this.lineHeight,
  }) : displayBase = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.xl,
         height: lineHeight.large,
         fontWeight: fontWeight.regular,
       ),
       displayBaseUnderline = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.xl,
         height: lineHeight.large,
         fontWeight: fontWeight.regular,
         decoration: TextDecoration.underline,
       ),
       titleBase = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.lg,
         height: lineHeight.medium,
         fontWeight: fontWeight.regular,
       ),
       titleSmall = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.md,
         height: lineHeight.medium,
         fontWeight: fontWeight.regular,
       ),
       bodyBase = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.base,
         height: lineHeight.large,
         fontWeight: fontWeight.regular,
       ),
       bodyBaseUnderline = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.base,
         height: lineHeight.large,
         fontWeight: fontWeight.regular,
         decoration: TextDecoration.underline,
       ),
       bodyBaseStrikethrough = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.base,
         height: lineHeight.large,
         fontWeight: fontWeight.regular,
         decoration: TextDecoration.lineThrough,
       ),
       bodySmall = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.sm,
         height: lineHeight.large,
         fontWeight: fontWeight.regular,
       ),
       bodySmallUnderline = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.sm,
         height: lineHeight.large,
         fontWeight: fontWeight.regular,
         decoration: TextDecoration.underline,
       ),
       bodySmallStrikethrough = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.sm,
         height: lineHeight.large,
         fontWeight: fontWeight.regular,
         decoration: TextDecoration.lineThrough,
       ),
       captionBase = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.xs,
         height: lineHeight.large,
         fontWeight: fontWeight.regular,
       ),
       captionBaseStrikethrough = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.xs,
         height: lineHeight.large,
         fontWeight: fontWeight.regular,
         decoration: TextDecoration.lineThrough,
       ),
       labelBase = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.base,
         height: lineHeight.medium,
         fontWeight: fontWeight.regular,
       ),
       labelBaseUnderline = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.base,
         height: lineHeight.medium,
         fontWeight: fontWeight.regular,
         decoration: TextDecoration.underline,
       ),
       labelBaseStrikethrough = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.base,
         height: lineHeight.medium,
         fontWeight: fontWeight.regular,
         decoration: TextDecoration.lineThrough,
       ),
       labelSmall = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.sm,
         height: lineHeight.medium,
         fontWeight: fontWeight.regular,
       ),
       labelSmallUnderline = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.sm,
         height: lineHeight.medium,
         fontWeight: fontWeight.regular,
         decoration: TextDecoration.underline,
       ),
       labelSmallStrikethrough = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.sm,
         height: lineHeight.medium,
         fontWeight: fontWeight.regular,
         decoration: TextDecoration.lineThrough,
       ),
       labelTiny = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.xs,
         height: lineHeight.medium,
         fontWeight: fontWeight.regular,
       ),
       labelMicro = _baseTextStyle.copyWith(
         fontFamily: fontFamily,
         fontSize: fontSize.xxs,
         height: lineHeight.medium,
         fontWeight: fontWeight.regular,
       );

  final String fontFamily;
  final OdinFontSize fontSize;
  final OdinFontWeight fontWeight;
  final OdinLineHeight lineHeight;

  final TextStyle displayBase;
  final TextStyle displayBaseUnderline;
  final TextStyle titleBase;
  final TextStyle titleSmall;
  final TextStyle bodyBase;
  final TextStyle bodyBaseUnderline;
  final TextStyle bodyBaseStrikethrough;
  final TextStyle bodySmall;
  final TextStyle bodySmallUnderline;
  final TextStyle bodySmallStrikethrough;
  final TextStyle captionBase;
  final TextStyle captionBaseStrikethrough;
  final TextStyle labelBase;
  final TextStyle labelBaseStrikethrough;
  final TextStyle labelBaseUnderline;
  final TextStyle labelSmall;
  final TextStyle labelSmallUnderline;
  final TextStyle labelSmallStrikethrough;
  final TextStyle labelTiny;
  final TextStyle labelMicro;

  OdinTypography copyWith({
    String? fontFamily,
    OdinFontSize? fontSize,
    OdinFontWeight? fontWeight,
    OdinLineHeight? lineHeight,
  }) {
    return OdinTypography(
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      lineHeight: lineHeight ?? this.lineHeight,
    );
  }

  static OdinTypography lerp(OdinTypography a, OdinTypography b, double t) {
    return OdinTypography(
      fontFamily: t > 0.5 ? a.fontFamily : b.fontFamily,
      fontSize: OdinFontSize.lerp(a.fontSize, b.fontSize, t),
      fontWeight: OdinFontWeight.lerp(a.fontWeight, b.fontWeight, t),
      lineHeight: OdinLineHeight.lerp(a.lineHeight, b.lineHeight, t),
    );
  }
}

final defaultTypography = OdinTypography(
  fontFamily: FontFamily.fontFamily,
  fontSize: const OdinFontSize(
    xxs: 10.0,
    xs: 12.0,
    sm: 14.0,
    base: 16.0,
    md: 18.0,
    lg: 24.0,
    xl: 28.0,
    xxl: 32.0,
    xxxl: 48.0,
    xxxxl: 64.0,
  ),
  fontWeight: const OdinFontWeight(
    regular: FontWeight.w400,
    bold: FontWeight.w700,
  ),
  lineHeight: OdinLineHeight(
    small: 1.00,
    medium: switch (defaultTargetPlatform) {
      TargetPlatform.iOS => 1.05,
      TargetPlatform.android || TargetPlatform.fuchsia || TargetPlatform.linux || TargetPlatform.macOS || TargetPlatform.windows => 1.25,
    },
    large: switch (defaultTargetPlatform) {
      TargetPlatform.iOS => 1.25,
      TargetPlatform.android || TargetPlatform.fuchsia || TargetPlatform.linux || TargetPlatform.macOS || TargetPlatform.windows => 1.50,
    },
  ),
);
