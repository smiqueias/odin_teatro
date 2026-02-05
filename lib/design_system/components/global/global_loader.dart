import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

final class OdinGlobalLoader extends StatelessWidget {
  const OdinGlobalLoader({
    super.key,
    this.size = 64.0,
    this.strokeWidth = 3.2,
    this.color,
  });

  final Color? color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);

    return _GlobalLoader(
      color: color ?? theme.appColorScheme.onColorEmphasisHigh,
      size: size,
      strokeWidth: strokeWidth,
    );
  }
}

enum OdinGlobalLoaderSmallSize {
  size16(16.0, 13.3),
  size24(24.0, 20.0)
  ;

  const OdinGlobalLoaderSmallSize(this.totalSize, this.internalSize);

  final double totalSize;
  final double internalSize;
}

final class OdinGlobalLoaderSmall extends StatelessWidget {
  const OdinGlobalLoaderSmall({
    super.key,
    this.size = OdinGlobalLoaderSmallSize.size24,
    this.color,
  });

  final OdinGlobalLoaderSmallSize size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);

    return Padding(
      padding: EdgeInsets.all((size.totalSize - size.internalSize) / 2),
      child: _GlobalLoader(
        color: color ?? theme.appColorScheme.onColorEmphasisHigh,
        size: size.internalSize,
        strokeWidth: switch (size) {
          OdinGlobalLoaderSmallSize.size16 => 0.65,
          OdinGlobalLoaderSmallSize.size24 => 1.0,
        },
      ),
    );
  }
}

final class _GlobalLoader extends StatelessWidget {
  const _GlobalLoader({
    required this.color,
    required this.size,
    required this.strokeWidth,
  });

  final Color color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.square(size),
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
