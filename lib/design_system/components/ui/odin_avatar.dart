import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

enum OdinAvatarSize {
  size24(24.0),
  size32(32.0),
  size40(40.0),
  size48(48.0),
  size64(64.0),
  size80(80.0),
  size112(112.0)
  ;

  const OdinAvatarSize(this.value);

  final double value;
}

sealed class OdinAvatarWidget extends StatelessWidget {
  const OdinAvatarWidget({super.key});
}

class OdinAvatar extends OdinAvatarWidget {
  const OdinAvatar({
    super.key,
    this.size,
    this.hasOutline,
    this.image,
    this.initials,
    this.notificationBadge,
    this.statusBadge,
  });

  final OdinAvatarSize? size;
  final bool? hasOutline;
  final Widget? image;
  final Widget? initials;
  final OdinGlobalNotificationBadge? notificationBadge;
  final OdinGlobalStatusBadge? statusBadge;

  @override
  Widget build(BuildContext context) {
    final theme = OdinAvatarTheme.of(context);

    final size = this.size ?? theme.size;
    final hasOutline = this.hasOutline ?? theme.hasOutline;

    final radius = size.value / 2;

    final resolvedNotificationBadge = notificationBadge != null && size.value <= OdinAvatarSize.size32.value
        ? const OdinGlobalNotificationBadge.bullet() //
        : notificationBadge;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.backgroundColor,
          border: hasOutline
              ? OdinBorder.all(
                  color: theme.borderColor,
                  stroke: theme.borderWidth,
                )
              : null,
        ),
        child: SizedBox.square(
          dimension: size.value,
          child: Stack(
            children: [
              if (image case final image?)
                ClipOval(
                  child: SizedBox.square(
                    dimension: size.value,
                    child: image,
                  ),
                )
              else
                Center(
                  child: DefaultTextStyle(
                    style: theme.textStyleBySize[size]!,
                    child: initials ?? const Text(''),
                  ),
                ),
              if (resolvedNotificationBadge case final notificationBadge?)
                Align(
                  alignment: FractionalOffset.fromOffsetAndSize(
                    circleOffset(radius: radius, angle: 140.0) + const Offset(8.0, 0.0),
                    Size.square(size.value),
                  ),
                  child: notificationBadge,
                ),
              if (statusBadge case final statusBadge?)
                Align(
                  alignment: FractionalOffset.fromOffsetAndSize(
                    circleOffset(radius: radius, angle: 40.0) + const Offset(8.0, 0.0),
                    Size.square(size.value),
                  ),
                  child: statusBadge,
                ),
            ],
          ),
        ),
      ),
    );
  }

  static String initialsFrom(String personName) {
    final name = personName.trim().toUpperCase();

    if (name.isEmpty) {
      return '';
    } else {
      final names = name.split(' ');

      if (names.length > 1) {
        final lastName = names[names.length - 1];
        return '${name[0]}${lastName[0]}';
      } else {
        return name[0];
      }
    }
  }
}

final class OdinAvatarShimmer extends OdinAvatarWidget {
  const OdinAvatarShimmer({
    super.key,
    this.size,
  });

  final OdinAvatarSize? size;

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? OdinAvatarTheme.of(context).size;

    return OdinShimmer(
      child: OdinShimmerCover(
        borderRadius: size.value / 2.0,
        child: SizedBox.square(dimension: size.value),
      ),
    );
  }
}

final class OdinAvatarTheme extends InheritedTheme {
  const OdinAvatarTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinAvatarThemeData data;

  static OdinAvatarThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinAvatarTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).avatarTheme;
  }

  @override
  bool updateShouldNotify(OdinAvatarTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinAvatarTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinAvatarThemeData {
  OdinAvatarThemeData({
    required this.size,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.hasOutline,
    required this.textStyleBySize,
  });

  final OdinAvatarSize size;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final bool hasOutline;
  final Map<OdinAvatarSize, TextStyle?> textStyleBySize;

  static OdinAvatarThemeData lerp(
    OdinAvatarThemeData a,
    OdinAvatarThemeData b,
    double t,
  ) {
    return OdinAvatarThemeData(
      size: t < 0.5 ? a.size : b.size,
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t)!,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      hasOutline: t < 0.5 ? a.hasOutline : b.hasOutline,
      textStyleBySize: {
        OdinAvatarSize.size24: TextStyle.lerp(
          a.textStyleBySize[OdinAvatarSize.size24],
          b.textStyleBySize[OdinAvatarSize.size24],
          t,
        ),
        OdinAvatarSize.size32: TextStyle.lerp(
          a.textStyleBySize[OdinAvatarSize.size32],
          b.textStyleBySize[OdinAvatarSize.size32],
          t,
        ),
        OdinAvatarSize.size40: TextStyle.lerp(
          a.textStyleBySize[OdinAvatarSize.size40],
          b.textStyleBySize[OdinAvatarSize.size40],
          t,
        ),
        OdinAvatarSize.size48: TextStyle.lerp(
          a.textStyleBySize[OdinAvatarSize.size48],
          b.textStyleBySize[OdinAvatarSize.size48],
          t,
        ),
        OdinAvatarSize.size64: TextStyle.lerp(
          a.textStyleBySize[OdinAvatarSize.size64],
          b.textStyleBySize[OdinAvatarSize.size64],
          t,
        ),
        OdinAvatarSize.size80: TextStyle.lerp(
          a.textStyleBySize[OdinAvatarSize.size80],
          b.textStyleBySize[OdinAvatarSize.size80],
          t,
        ),
        OdinAvatarSize.size112: TextStyle.lerp(
          a.textStyleBySize[OdinAvatarSize.size112],
          b.textStyleBySize[OdinAvatarSize.size112],
          t,
        ),
      },
    );
  }

  OdinAvatarThemeData copyWith({
    OdinAvatarSize? size,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    bool? hasOutline,
    Map<OdinAvatarSize, TextStyle?>? textStyleBySize,
  }) {
    return OdinAvatarThemeData(
      size: size ?? this.size,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      hasOutline: hasOutline ?? this.hasOutline,
      textStyleBySize: textStyleBySize ?? this.textStyleBySize,
    );
  }
}

OdinAvatarThemeData createDefaultAvatarTheme({
  required OdinColorScheme colorScheme,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  return OdinAvatarThemeData(
    size: OdinAvatarSize.size32,
    backgroundColor: colorScheme.neutralExtended30,
    borderColor: colorScheme.outlineBase,
    borderWidth: borderTheme.strokeThin,
    hasOutline: true,
    textStyleBySize: {
      OdinAvatarSize.size24: typography.labelMicro.copyWith(color: colorScheme.onColorEmphasisHigh),
      OdinAvatarSize.size32: typography.labelSmall.copyWith(color: colorScheme.onColorEmphasisHigh),
      OdinAvatarSize.size40: typography.labelSmall.copyWith(color: colorScheme.onColorEmphasisHigh),
      OdinAvatarSize.size48: typography.labelSmall.copyWith(color: colorScheme.onColorEmphasisHigh),
      OdinAvatarSize.size64: typography.titleSmall.copyWith(color: colorScheme.onColorEmphasisHigh),
      OdinAvatarSize.size80: typography.titleSmall.copyWith(color: colorScheme.onColorEmphasisHigh),
      OdinAvatarSize.size112: typography.titleSmall.copyWith(color: colorScheme.onColorEmphasisHigh),
    },
  );
}
