import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/color_scheme/color_scheme.dart';
import 'package:odin_teatro/design_system/color_scheme/color_scheme_provider.dart';
import 'package:odin_teatro/design_system/components/ui/odin_border.dart';
import 'package:odin_teatro/design_system/foundation/lerp.dart';
import 'package:odin_teatro/design_system/foundation/platform_extension.dart';
import 'package:odin_teatro/design_system/foundation/typography.dart';
import 'package:odin_teatro/design_system/models/action_settings.dart';

final class OdinIconButton extends StatelessWidget {
  const OdinIconButton({
    required this.icon,
    super.key,
    this.color,
    this.disabledColor,
    this.minSize,
    this.iconSize,
    this.tooltip,
    this.onPress,
    this.alignment = Alignment.center,
  });

  OdinIconButton.fromActionSettings({
    required OdinIconActionSettings actionSettings,
    super.key,
    this.color,
    this.disabledColor,
    this.minSize,
    this.iconSize,
    this.tooltip,
    this.alignment = Alignment.center,
  }) : icon = Icon(actionSettings.icon),
       onPress = actionSettings.onPress;

  final Widget icon;
  final Color? color;
  final Color? disabledColor;
  final double? minSize;
  final double? iconSize;
  final String? tooltip;
  final VoidCallback? onPress;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final theme = OdinIconButtonTheme.of(context);
    final isIOS = Theme.of(context).platform.isIOS;

    final effectiveColor = onPress == null
        ? (disabledColor ?? theme.disabledColor) //
        : color ?? theme.color;
    final effectiveMinSize = minSize ?? theme.minSize;
    final effectiveIconSize = iconSize ?? theme.iconSize;
    final splashRadius = theme.splashRadius;

    final iconButton = isIOS
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onPress,
            alignment: alignment,
            minimumSize: Size.square(effectiveMinSize),
            child: IconTheme(
              data: IconThemeData(
                size: effectiveIconSize,
                color: effectiveColor,
              ),
              child: icon,
            ),
          )
        : IconButton(
            icon: icon,
            onPressed: onPress,
            color: effectiveColor,
            // This is needed to force the disabled color for Android devices.
            disabledColor: effectiveColor,
            iconSize: effectiveIconSize,
            padding: EdgeInsets.zero,
            splashRadius: splashRadius,
            alignment: alignment,
            constraints: BoxConstraints(
              minWidth: effectiveMinSize,
              minHeight: effectiveMinSize,
            ),
            // This needs to be forced so the spacings on desktop look like the
            // ones in mobile devices.
            visualDensity: VisualDensity.standard,
          );

    return tooltip != null
        ? Tooltip(
            message: tooltip,
            child: iconButton,
          )
        : iconButton;
  }
}

final class OdinIconButtonTheme extends InheritedTheme {
  const OdinIconButtonTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinIconButtonThemeData data;

  static OdinIconButtonThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinIconButtonTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).iconButtonTheme;
  }

  @override
  bool updateShouldNotify(OdinIconButtonTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinIconButtonTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinIconButtonThemeData {
  OdinIconButtonThemeData({
    required this.color,
    required this.disabledColor,
    required this.minSize,
    required this.iconSize,
    required this.splashRadius,
  });

  final Color color;
  final Color disabledColor;
  final double minSize;
  final double iconSize;
  final double splashRadius;

  static OdinIconButtonThemeData lerp(
    OdinIconButtonThemeData a,
    OdinIconButtonThemeData b,
    double t,
  ) {
    return OdinIconButtonThemeData(
      color: Color.lerp(a.color, b.color, t)!,
      disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t)!,
      minSize: lerpDouble(a.minSize, b.minSize, t),
      iconSize: lerpDouble(a.iconSize, b.iconSize, t),
      splashRadius: lerpDouble(a.splashRadius, b.splashRadius, t),
    );
  }

  OdinIconButtonThemeData copyWith({
    Color? color,
    Color? disabledColor,
    double? minSize,
    double? iconSize,
    double? splashRadius,
  }) {
    return OdinIconButtonThemeData(
      color: color ?? this.color,
      disabledColor: disabledColor ?? this.disabledColor,
      minSize: minSize ?? this.minSize,
      iconSize: iconSize ?? this.iconSize,
      splashRadius: splashRadius ?? this.splashRadius,
    );
  }
}

OdinIconButtonThemeData createDefaultIconButtonTheme({
  required OdinColorScheme colorScheme,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  return OdinIconButtonThemeData(
    color: colorScheme.onColorEmphasisHigh,
    disabledColor: colorScheme.onColorEmphasisDisabled,
    minSize: kMinInteractiveDimension,
    iconSize: 24.0,
    splashRadius: 24.0,
  );
}
