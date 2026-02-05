import 'package:gap/gap.dart';

abstract final class OdinGapValue {
  static const xxxs = 4.0;
  static const xxs = 8.0;
  static const xs = 16.0;
  static const sm = 24.0;
  static const md = 32.0;
  static const lg = 40.0;
  static const xl = 48.0;
  static const xxl = 64.0;
  static const xxxl = 128.0;
}

abstract final class OdinGap {
  static const xxxs = Gap(OdinGapValue.xxxs);
  static const xxs = Gap(OdinGapValue.xxs);
  static const xs = Gap(OdinGapValue.xs);
  static const sm = Gap(OdinGapValue.sm);
  static const md = Gap(OdinGapValue.md);
  static const lg = Gap(OdinGapValue.lg);
  static const xl = Gap(OdinGapValue.xl);
  static const xxl = Gap(OdinGapValue.xxl);
  static const xxxl = Gap(OdinGapValue.xxxl);
}

abstract final class OdinSliverGap {
  static const xxxs = SliverGap(OdinGapValue.xxxs);
  static const xxs = SliverGap(OdinGapValue.xxs);
  static const xs = SliverGap(OdinGapValue.xs);
  static const sm = SliverGap(OdinGapValue.sm);
  static const md = SliverGap(OdinGapValue.md);
  static const lg = SliverGap(OdinGapValue.lg);
  static const xl = SliverGap(OdinGapValue.xl);
  static const xxl = SliverGap(OdinGapValue.xxl);
  static const xxxl = SliverGap(OdinGapValue.xxxl);
}

abstract final class OdinPaddingValue {
  static const xxxs = 4.0;
  static const xxs = 8.0;
  static const xs = 16.0;
  static const sm = 24.0;
  static const md = 32.0;
  static const lg = 40.0;
  static const xl = 48.0;
  static const xxl = 64.0;
}
