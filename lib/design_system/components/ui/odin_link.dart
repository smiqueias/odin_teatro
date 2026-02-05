import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

enum OdinLinkKind {
  neutral,
  primary,
}

enum OdinLinkSize {
  large,
  small,
}

class OdinLink extends StatelessWidget {
  const OdinLink({
    required this.label,
    super.key,
    this.leftIcon,
    this.rightIcon,
    this.kind = OdinLinkKind.neutral,
    this.size,
    this.isUnderline = false,
    this.onPress,
    this.semantics = const OdinSemanticsData(),
  });

  OdinLink.fromActionSettings({
    required OdinActionSettings<VoidCallback> actionSettings,
    super.key,
    this.kind = OdinLinkKind.neutral,
    this.size,
    this.isUnderline = false,
    this.semantics = const OdinSemanticsData(),
  }) : label = Text(actionSettings.text),
       leftIcon = actionSettings.leftIcon == null
           ? null //
           : Icon(actionSettings.leftIcon),
       rightIcon = actionSettings.rightIcon == null
           ? null //
           : Icon(actionSettings.rightIcon),
       onPress = actionSettings.onPress;

  final OdinLinkKind kind;
  final OdinLinkSize? size;
  final Widget label;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final bool isUnderline;
  final VoidCallback? onPress;
  final OdinSemanticsData semantics;

  @override
  Widget build(BuildContext context) {
    final colorScheme = OdinThemeProvider.of(context).appColorScheme;
    final linkTheme = OdinThemeProvider.of(context).linkTheme;

    final linkStyle = switch (kind) {
      OdinLinkKind.neutral => linkTheme.neutralLinkStyle,
      OdinLinkKind.primary => linkTheme.primaryLinkStyle,
    };

    final size = this.size ?? linkTheme.size;

    final textStyle = switch ((size, isUnderline)) {
      (OdinLinkSize.large, false) => linkStyle.largeTextStyle,
      (OdinLinkSize.large, true) => linkStyle.largeUnderlineTextStyle,
      (OdinLinkSize.small, false) => linkStyle.smallTextStyle,
      (OdinLinkSize.small, true) => linkStyle.smallUnderlineTextStyle,
    };

    final foregroundColor = WidgetStateProperty.resolveWith(
      (states) {
        final resolvedTextStyleData = linkStyle.largeTextStyle.resolve(states);
        return resolvedTextStyleData.color ?? colorScheme.onColorEmphasisHigh;
      },
    );

    return Semantics.fromProperties(
      excludeSemantics: semantics.exclude,
      container: semantics.container,
      properties: semantics.properties,
      blockUserActions: semantics.blockUserActions,
      key: semantics.key,
      explicitChildNodes: semantics.explicitChildNodes,
      child: TextButton(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: textStyle,
          padding: generateState(EdgeInsets.zero),
          iconSize: generateState(linkStyle.iconSize.value),
          iconColor: WidgetStateProperty.resolveWith(
            (states) {
              final resolvedTextStyleData = textStyle.resolve(states);
              return resolvedTextStyleData.color ?? colorScheme.onColorEmphasisHigh;
            },
          ),
          foregroundColor: foregroundColor,
          minimumSize: const WidgetStatePropertyAll(Size.zero),
          overlayColor: generateState(kTransparentColor),
        ),
        onPressed: onPress,
        child: Builder(
          builder: (context) {
            return OdinIconContainerTheme(
              data: OdinIconContainerTheme.of(context).copyWith(
                size: linkStyle.iconSize,
                foregroundColor: IconTheme.of(context).color,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leftIcon case final leftIcon?) ...[
                    leftIcon,
                    SizedBox(width: linkTheme.iconSpacing),
                  ],
                  Flexible(
                    child: label,
                  ),
                  if (rightIcon case final rightIcon?) ...[
                    SizedBox(width: linkTheme.iconSpacing),
                    rightIcon,
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

final class OdinLinkTheme extends InheritedTheme {
  const OdinLinkTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinLinkThemeData data;

  static OdinLinkThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinLinkTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).linkTheme;
  }

  @override
  bool updateShouldNotify(OdinLinkTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinLinkTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinLinkThemeData {
  const OdinLinkThemeData({
    required this.neutralLinkStyle,
    required this.primaryLinkStyle,
    required this.size,
    required this.iconSpacing,
  });

  final OdinLinkStyle neutralLinkStyle;
  final OdinLinkStyle primaryLinkStyle;
  final OdinLinkSize size;
  final double iconSpacing;

  static OdinLinkThemeData lerp(OdinLinkThemeData a, OdinLinkThemeData b, double t) {
    return OdinLinkThemeData(
      neutralLinkStyle: OdinLinkStyle.lerp(a.neutralLinkStyle, b.neutralLinkStyle, t),
      primaryLinkStyle: OdinLinkStyle.lerp(a.primaryLinkStyle, b.primaryLinkStyle, t),
      size: t < 0.5 ? a.size : b.size,
      iconSpacing: lerpDouble(a.iconSpacing, b.iconSpacing, t),
    );
  }

  OdinLinkThemeData copyWith({
    OdinLinkStyle? neutralLinkStyle,
    OdinLinkStyle? primaryLinkStyle,
    OdinLinkSize? size,
    double? iconSpacing,
  }) {
    return OdinLinkThemeData(
      neutralLinkStyle: neutralLinkStyle ?? this.neutralLinkStyle,
      primaryLinkStyle: primaryLinkStyle ?? this.primaryLinkStyle,
      size: size ?? this.size,
      iconSpacing: iconSpacing ?? this.iconSpacing,
    );
  }
}

final class OdinLinkStyle {
  const OdinLinkStyle({
    required this.largeTextStyle,
    required this.smallTextStyle,
    required this.largeUnderlineTextStyle,
    required this.smallUnderlineTextStyle,
    required this.iconSize,
  });

  final WidgetStateProperty<TextStyle> largeTextStyle;
  final WidgetStateProperty<TextStyle> smallTextStyle;
  final WidgetStateProperty<TextStyle> largeUnderlineTextStyle;
  final WidgetStateProperty<TextStyle> smallUnderlineTextStyle;
  final OdinIconContainerSize iconSize;

  static OdinLinkStyle lerp(OdinLinkStyle a, OdinLinkStyle b, double t) {
    return OdinLinkStyle(
      largeTextStyle:
          WidgetStateProperty.lerp(
                a.largeTextStyle,
                b.largeTextStyle,
                t,
                TextStyle.lerp,
              )!
              as WidgetStateProperty<TextStyle>,
      smallTextStyle:
          WidgetStateProperty.lerp(
                a.smallTextStyle,
                b.smallTextStyle,
                t,
                TextStyle.lerp,
              )!
              as WidgetStateProperty<TextStyle>,
      largeUnderlineTextStyle:
          WidgetStateProperty.lerp(
                a.largeUnderlineTextStyle,
                b.largeUnderlineTextStyle,
                t,
                TextStyle.lerp,
              )!
              as WidgetStateProperty<TextStyle>,
      smallUnderlineTextStyle:
          WidgetStateProperty.lerp(
                a.smallUnderlineTextStyle,
                b.smallUnderlineTextStyle,
                t,
                TextStyle.lerp,
              )!
              as WidgetStateProperty<TextStyle>,
      iconSize: OdinIconContainerSize.lerp(a.iconSize, b.iconSize, t)!,
    );
  }

  OdinLinkStyle copyWith({
    WidgetStateProperty<TextStyle>? largeTextStyle,
    WidgetStateProperty<TextStyle>? smallTextStyle,
    WidgetStateProperty<TextStyle>? largeUnderlineTextStyle,
    WidgetStateProperty<TextStyle>? smallUnderlineTextStyle,
    OdinIconContainerSize? iconSize,
  }) {
    return OdinLinkStyle(
      largeTextStyle: largeTextStyle ?? this.largeTextStyle,
      smallTextStyle: smallTextStyle ?? this.smallTextStyle,
      largeUnderlineTextStyle: largeUnderlineTextStyle ?? this.largeUnderlineTextStyle,
      smallUnderlineTextStyle: smallUnderlineTextStyle ?? this.smallUnderlineTextStyle,
      iconSize: iconSize ?? this.iconSize,
    );
  }
}

OdinLinkThemeData createDefaultLinkTheme({
  required OdinColorScheme colorScheme,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  WidgetStateProperty<TextStyle> createTextStyleState(OdinLinkKind kind, TextStyle baseTextStyle) {
    return generateState(
      baseTextStyle.copyWith(
        color: switch (kind) {
          OdinLinkKind.neutral => colorScheme.onColorEmphasisHigh,
          OdinLinkKind.primary => colorScheme.actionSecondaryEnabled,
        },
      ),
      pressed: baseTextStyle.copyWith(
        color: switch (kind) {
          OdinLinkKind.neutral => colorScheme.onColorEmphasisLow,
          OdinLinkKind.primary => colorScheme.actionSecondaryPressed,
        },
      ),
      disabled: baseTextStyle.copyWith(
        color: switch (kind) {
          OdinLinkKind.neutral => colorScheme.onColorEmphasisDisabled,
          OdinLinkKind.primary => colorScheme.onColorEmphasisDisabled,
        },
      ),
    );
  }

  return OdinLinkThemeData(
    neutralLinkStyle: OdinLinkStyle(
      largeTextStyle: createTextStyleState(OdinLinkKind.neutral, typography.labelBase),
      smallTextStyle: createTextStyleState(OdinLinkKind.neutral, typography.labelSmall),
      largeUnderlineTextStyle: createTextStyleState(
        OdinLinkKind.neutral,
        typography.labelBaseUnderline,
      ),
      smallUnderlineTextStyle: createTextStyleState(
        OdinLinkKind.neutral,
        typography.labelSmallUnderline,
      ),
      iconSize: OdinIconContainerSize.size16,
    ),
    primaryLinkStyle: OdinLinkStyle(
      largeTextStyle: createTextStyleState(OdinLinkKind.primary, typography.titleSmall),
      smallTextStyle: createTextStyleState(OdinLinkKind.primary, typography.labelSmall),
      largeUnderlineTextStyle: createTextStyleState(
        OdinLinkKind.primary,
        typography.labelBaseUnderline,
      ),
      smallUnderlineTextStyle: createTextStyleState(
        OdinLinkKind.primary,
        typography.labelSmallUnderline,
      ),
      iconSize: OdinIconContainerSize.size16,
    ),
    size: OdinLinkSize.large,
    iconSpacing: OdinGapValue.xxxs,
  );
}
