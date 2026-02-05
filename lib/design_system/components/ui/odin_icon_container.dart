import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

enum OdinIconContainerSize {
  size16(16.0),
  size24(24.0),
  size32(32.0),
  size40(40.0),
  size48(48.0),
  size64(64.0),
  size72(72.0),
  size80(80.0),
  size96(96.0),
  size112(112.0),
  size128(128.0)
  ;

  const OdinIconContainerSize(this.value);

  static OdinIconContainerSize? lerp(OdinIconContainerSize? a, OdinIconContainerSize? b, double t) {
    return lerpEnum(values, a, b, t);
  }

  final double value;
}

final class OdinIconContainer extends StatelessWidget {
  const OdinIconContainer({
    required this.icon,
    super.key,
    this.size,
    this.color,
    this.hasNotification = false,
    this.isLoading = false,
    this.onPress,
  });

  final IconData icon;
  final OdinIconContainerSize? size;
  final Color? color;
  final bool hasNotification;
  final bool isLoading;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      final size = this.size ?? OdinIconContainerSize.size24;

      return OdinShimmer(
        child: OdinShimmerCover(
          child: SizedBox(
            width: size.value,
            height: size.value,
          ),
        ),
      );
    } else {
      return OdinInkWell.outsideResponse(
        onTap: onPress,
        child: _IconContainer(
          icon: icon,
          size: size,
          color: color,
          notificationBadge: hasNotification
              ? const OdinGlobalNotificationBadge.bullet() //
              : null,
        ),
      );
    }
  }
}

final class OdinIconContainerNotification extends OdinIconContainer {
  const OdinIconContainerNotification({
    required super.icon,
    super.key,
    super.size,
    super.color,
  }) : super(hasNotification: true);
}

final class OdinIconContainerShimmer extends OdinIconContainer {
  const OdinIconContainerShimmer({
    super.key,
    super.size,
  }) : super(
         icon: OdinIcons.agro,
         isLoading: true,
       );
}

final class _IconContainer extends StatelessWidget {
  const _IconContainer({
    required this.icon,
    this.size,
    this.notificationBadge,
    this.color,
  });

  final IconData icon;
  final OdinIconContainerSize? size;
  final OdinGlobalNotificationBadge? notificationBadge;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = OdinIconContainerTheme.of(context);

    final child = Icon(
      icon,
      size: size?.value ?? theme.size.value,
      color: color ?? theme.foregroundColor,
      applyTextScaling: theme.applyTextScaling,
    );

    if (notificationBadge case final notificationBadge?) {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          child,
          notificationBadge,
        ],
      );
    } else {
      return child;
    }
  }
}

enum OdinIconContainerCircleSize {
  size24(24.0, OdinIconContainerSize.size16),
  size32(32.0, OdinIconContainerSize.size16),
  size40(40.0, OdinIconContainerSize.size24),
  size48(48.0, OdinIconContainerSize.size32),
  size64(64.0, OdinIconContainerSize.size40),
  size72(72.0, OdinIconContainerSize.size40),
  size80(80.0, OdinIconContainerSize.size48),
  size96(96.0, OdinIconContainerSize.size64),
  size112(112.0, OdinIconContainerSize.size64),
  size128(128.0, OdinIconContainerSize.size72)
  ;

  const OdinIconContainerCircleSize(
    this.size,
    this.iconSize,
  );

  final double size;
  final OdinIconContainerSize iconSize;
}

final class OdinIconContainerCircle extends StatelessWidget {
  const OdinIconContainerCircle({
    required this.icon,
    super.key,
    this.size,
    this.notificationBadge,
    this.foregroundColor,
    this.backgroundColor,
    this.hasOutline,
    this.isLoading = false,
    this.onPress,
  });

  final IconData icon;
  final OdinIconContainerCircleSize? size;
  final OdinGlobalNotificationBadge? notificationBadge;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final bool? hasOutline;
  final bool isLoading;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return OdinInkWell(
      onTap: onPress,
      child: _IconContainerCircle(
        icon: icon,
        size: size,
        notificationBadge: notificationBadge,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        hasOutline: hasOutline,
        isLoading: isLoading,
      ),
    );
  }
}

final class OdinIconContainerCircleNotification extends OdinIconContainerCircle {
  const OdinIconContainerCircleNotification({
    required super.icon,
    required OdinGlobalNotificationBadge super.notificationBadge,
    super.key,
    super.size,
    super.foregroundColor,
    super.backgroundColor,
    super.hasOutline,
  });
}

final class OdinIconContainerCircleShimmer extends OdinIconContainerCircle {
  const OdinIconContainerCircleShimmer({
    super.key,
    super.size,
  }) : super(
         icon: OdinIcons.empty,
         isLoading: true,
       );
}

final class _IconContainerCircle extends StatelessWidget {
  const _IconContainerCircle({
    required this.icon,
    required this.isLoading,
    this.size,
    this.foregroundColor,
    this.backgroundColor,
    this.hasOutline,
    this.notificationBadge,
  });

  final IconData icon;
  final OdinIconContainerCircleSize? size;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final bool? hasOutline;
  final bool isLoading;
  final OdinGlobalNotificationBadge? notificationBadge;

  @override
  Widget build(BuildContext context) {
    final theme = OdinIconContainerTheme.of(context);
    final size = this.size ?? theme.circleSize;
    final position = size.size / 2.0 + size.size * sqrt1_2 / 2.0;
    final hasOutline = this.hasOutline ?? theme.hasOutline;

    if (isLoading) {
      return OdinShimmer(
        child: OdinShimmerCover(
          borderRadius: size.size,
          child: SizedBox(
            width: size.size,
            height: size.size,
          ),
        ),
      );
    } else {
      final resolvedNotificationBadge = switch ((notificationBadge, size)) {
        (null, _) => null,
        (_?, OdinIconContainerCircleSize.size24) => const OdinGlobalNotificationBadge.bullet(),
        (_?, OdinIconContainerCircleSize.size32) => const OdinGlobalNotificationBadge.bullet(),
        (_?, _) => notificationBadge,
      };

      final child = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? theme.backgroundColor,
          border: hasOutline
              ? OdinBorder.all(
                  color: theme.borderColor,
                  stroke: theme.borderWidth,
                )
              : null,
        ),
        width: size.size,
        height: size.size,
        child: _IconContainer(
          icon: icon,
          size: size.iconSize,
          color: foregroundColor,
        ),
      );

      if (resolvedNotificationBadge case final resolvedNotificationBadge?) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            child,
            Positioned(
              left: position,
              bottom: position,
              child: FractionalTranslation(
                translation: const Offset(-0.5, 0.5),
                child: resolvedNotificationBadge,
              ),
            ),
          ],
        );
      } else {
        return child;
      }
    }
  }
}

class OdinIconContainerTheme extends StatefulWidget {
  const OdinIconContainerTheme({
    required this.child,
    required this.data,
    super.key,
  });

  final Widget child;
  final OdinIconContainerThemeData data;

  static OdinIconContainerThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinIconContainerThemeScope>();
    return theme?.data ?? OdinThemeProvider.of(context).iconContainerTheme;
  }

  @override
  State<OdinIconContainerTheme> createState() => _OdinIconContainerThemeState();
}

class _OdinIconContainerThemeState extends State<OdinIconContainerTheme> {
  @override
  Widget build(BuildContext context) {
    return OdinIconContainerThemeScope(
      data: widget.data,
      child: IconTheme(
        data: IconTheme.of(context).copyWith(
          color: widget.data.foregroundColor,
          size: widget.data.size.value,
          applyTextScaling: true,
        ),
        child: widget.child,
      ),
    );
  }
}

final class OdinIconContainerThemeScope extends InheritedTheme {
  const OdinIconContainerThemeScope({
    required this.data,
    required super.child,
    super.key,
  });

  final OdinIconContainerThemeData data;

  @override
  bool updateShouldNotify(OdinIconContainerThemeScope oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinIconContainerTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinIconContainerThemeData {
  OdinIconContainerThemeData({
    required this.size,
    required this.circleSize,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.hasOutline,
    required this.applyTextScaling,
  });

  final OdinIconContainerSize size;
  final OdinIconContainerCircleSize circleSize;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final bool hasOutline;
  final bool applyTextScaling;

  static OdinIconContainerThemeData lerp(
    OdinIconContainerThemeData a,
    OdinIconContainerThemeData b,
    double t,
  ) {
    return OdinIconContainerThemeData(
      size: t < 0.5 ? a.size : b.size,
      circleSize: t < 0.5 ? a.circleSize : b.circleSize,
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t)!,
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t)!,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      hasOutline: lerpBool(a.hasOutline, b.hasOutline, t),
      applyTextScaling: lerpBool(a.applyTextScaling, b.applyTextScaling, t),
    );
  }

  OdinIconContainerThemeData copyWith({
    OdinIconContainerSize? size,
    OdinIconContainerCircleSize? circleSize,
    Color? foregroundColor,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    bool? hasOutline,
    bool? applyTextScaling,
  }) {
    return OdinIconContainerThemeData(
      size: size ?? this.size,
      circleSize: circleSize ?? this.circleSize,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      hasOutline: hasOutline ?? this.hasOutline,
      applyTextScaling: applyTextScaling ?? this.applyTextScaling,
    );
  }
}

OdinIconContainerThemeData createDefaultIconContainerTheme({
  required OdinColorScheme colorScheme,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  return OdinIconContainerThemeData(
    size: OdinIconContainerSize.size24,
    circleSize: OdinIconContainerCircleSize.size24,
    foregroundColor: colorScheme.onColorEmphasisHigh,
    backgroundColor: colorScheme.neutralExtended30,
    borderColor: colorScheme.outlineBase,
    borderWidth: borderTheme.strokeThin,
    hasOutline: true,
    applyTextScaling: true,
  );
}
