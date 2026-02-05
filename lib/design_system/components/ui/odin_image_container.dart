import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

enum OdinImageContainerShape {
  rounded,
  squared,
}

enum OdinImageContainerSize {
  size16(16.0),
  size24(24.0),
  size32(32.0),
  size40(40.0),
  size48(48.0),
  size64(64.0),
  size80(80.0),
  size96(96.0),
  size112(112.0),
  size160(160.0),
  size240(240.0)
  ;

  const OdinImageContainerSize(this.value);

  final double value;
}

class OdinImageContainer extends StatelessWidget {
  const OdinImageContainer({
    required this.image,
    super.key,
    this.size,
    this.shape,
    this.hasOutline,
  });

  final Widget image;
  final OdinImageContainerSize? size;
  final OdinImageContainerShape? shape;
  final bool? hasOutline;

  @override
  Widget build(BuildContext context) {
    final theme = OdinImageContainerTheme.of(context);
    final size = this.size ?? theme.size;
    final shape = this.shape ?? theme.shape;
    final hasOutline = this.hasOutline ?? theme.hasOutline;

    return Container(
      width: size.value,
      height: size.value,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        border: hasOutline
            ? OdinBorder.all(
                color: theme.outlineColor,
                stroke: theme.outlineStroke,
              )
            : null,
        borderRadius: switch (shape) {
          OdinImageContainerShape.rounded => null,
          OdinImageContainerShape.squared => BorderRadius.all(theme.radius),
        },
        shape: switch (shape) {
          OdinImageContainerShape.rounded => BoxShape.circle,
          OdinImageContainerShape.squared => BoxShape.rectangle,
        },
      ),
      child: switch (shape) {
        OdinImageContainerShape.rounded => ClipOval(child: image),
        OdinImageContainerShape.squared => ClipRRect(
          borderRadius: BorderRadius.all(theme.radius),
          child: image,
        ),
      },
    );
  }
}

final class OdinImageContainerTheme extends InheritedTheme {
  const OdinImageContainerTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinImageContainerThemeData data;

  static OdinImageContainerThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinImageContainerTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).imageContainerTheme;
  }

  @override
  bool updateShouldNotify(OdinImageContainerTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinImageContainerTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinImageContainerThemeData {
  OdinImageContainerThemeData({
    required this.size,
    required this.shape,
    required this.backgroundColor,
    required this.outlineColor,
    required this.outlineStroke,
    required this.radius,
    required this.hasOutline,
  });

  final OdinImageContainerSize size;
  final OdinImageContainerShape shape;
  final Color backgroundColor;
  final Color outlineColor;
  final double outlineStroke;
  final Radius radius;
  final bool hasOutline;

  static OdinImageContainerThemeData lerp(
    OdinImageContainerThemeData a,
    OdinImageContainerThemeData b,
    double t,
  ) {
    return OdinImageContainerThemeData(
      size: t < 0.5 ? a.size : b.size,
      shape: t < 0.5 ? a.shape : b.shape,
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      outlineColor: Color.lerp(a.outlineColor, b.outlineColor, t)!,
      outlineStroke: lerpDouble(a.outlineStroke, b.outlineStroke, t),
      radius: Radius.lerp(a.radius, b.radius, t)!,
      hasOutline: lerpBool(a.hasOutline, b.hasOutline, t),
    );
  }

  OdinImageContainerThemeData copyWith({
    OdinImageContainerSize? size,
    OdinImageContainerShape? shape,
    Color? backgroundColor,
    Color? outlineColor,
    double? outlineStroke,
    Radius? radius,
    bool? hasOutline,
  }) {
    return OdinImageContainerThemeData(
      size: size ?? this.size,
      shape: shape ?? this.shape,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      outlineColor: outlineColor ?? this.outlineColor,
      outlineStroke: outlineStroke ?? this.outlineStroke,
      radius: radius ?? this.radius,
      hasOutline: hasOutline ?? this.hasOutline,
    );
  }
}

OdinImageContainerThemeData createDefaultImageContainerTheme({
  required OdinColorScheme colorScheme,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  return OdinImageContainerThemeData(
    size: OdinImageContainerSize.size48,
    shape: OdinImageContainerShape.rounded,
    backgroundColor: colorScheme.neutralBase,
    outlineColor: colorScheme.outlineBase,
    outlineStroke: borderTheme.strokeThin,
    radius: borderTheme.radiusSmall,
    hasOutline: true,
  );
}
