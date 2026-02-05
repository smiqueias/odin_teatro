import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

enum OdinGlobalStatusBadgeKind {
  on,
  off,
}

class OdinGlobalStatusBadge extends StatelessWidget {
  const OdinGlobalStatusBadge({
    required this.kind,
    super.key,
  });

  const OdinGlobalStatusBadge.on({
    super.key,
  }) : kind = OdinGlobalStatusBadgeKind.on;

  const OdinGlobalStatusBadge.off({
    super.key,
  }) : kind = OdinGlobalStatusBadgeKind.off;

  final OdinGlobalStatusBadgeKind kind;

  @override
  Widget build(BuildContext context) {
    final badgeTheme = OdinStatusBadgeTheme.of(context);

    final style = switch (kind) {
      OdinGlobalStatusBadgeKind.on => badgeTheme.statusOnStyle,
      OdinGlobalStatusBadgeKind.off => badgeTheme.statusOffStyle,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.backgroundColor,
        shape: BoxShape.circle,
        border: OdinBorder.all(
          color: style.borderColor,
          stroke: style.borderWidth,
        ),
      ),
      child: SizedBox.square(dimension: style.size),
    );
  }
}

final class OdinStatusBadgeTheme extends InheritedTheme {
  const OdinStatusBadgeTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinStatusBadgeThemeData data;

  static OdinStatusBadgeThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinStatusBadgeTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).statusBadgeTheme;
  }

  @override
  bool updateShouldNotify(OdinStatusBadgeTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinStatusBadgeTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinStatusBadgeThemeData {
  OdinStatusBadgeThemeData({
    required this.statusOnStyle,
    required this.statusOffStyle,
  });

  final OdinStatusBadgeStyle statusOnStyle;
  final OdinStatusBadgeStyle statusOffStyle;

  static OdinStatusBadgeThemeData lerp(
    OdinStatusBadgeThemeData a,
    OdinStatusBadgeThemeData b,
    double t,
  ) {
    return OdinStatusBadgeThemeData(
      statusOnStyle: OdinStatusBadgeStyle.lerp(a.statusOnStyle, b.statusOnStyle, t),
      statusOffStyle: OdinStatusBadgeStyle.lerp(a.statusOffStyle, b.statusOffStyle, t),
    );
  }

  OdinStatusBadgeThemeData copyWith({
    OdinStatusBadgeStyle? statusOnStyle,
    OdinStatusBadgeStyle? statusOffStyle,
  }) {
    return OdinStatusBadgeThemeData(
      statusOnStyle: statusOnStyle ?? this.statusOnStyle,
      statusOffStyle: statusOffStyle ?? this.statusOffStyle,
    );
  }
}

final class OdinStatusBadgeStyle {
  OdinStatusBadgeStyle({
    required this.size,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
  });

  final double size;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;

  static OdinStatusBadgeStyle lerp(OdinStatusBadgeStyle a, OdinStatusBadgeStyle b, double t) {
    return OdinStatusBadgeStyle(
      size: lerpDouble(a.size, b.size, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t)!,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
    );
  }
}

OdinStatusBadgeThemeData createDefaultStatusBadgeTheme({
  required OdinColorScheme colorScheme,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  return OdinStatusBadgeThemeData(
    statusOnStyle: OdinStatusBadgeStyle(
      size: 8.0,
      backgroundColor: colorScheme.statusSuccessBase,
      borderColor: colorScheme.outlineBase,
      borderWidth: borderTheme.strokeHairline,
    ),
    statusOffStyle: OdinStatusBadgeStyle(
      size: 8.0,
      backgroundColor: colorScheme.actionDisabledBase,
      borderColor: colorScheme.outlineBase,
      borderWidth: borderTheme.strokeHairline,
    ),
  );
}
