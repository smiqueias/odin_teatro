import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

enum OdinButtonKind {
  primary,
  neutral,
  line,
}

enum OdinButtonSize {
  compact,
  normal,
  fullWidth,
}

enum _ButtonProperty { kind, size }

final class OdinDefaultButtonProperties extends InheritedModel<_ButtonProperty> {
  const OdinDefaultButtonProperties({
    required super.child,
    super.key,
    this.kind,
    this.size,
  });

  static Widget merge({
    required Widget child,
    Key? key,
    OdinButtonKind? kind,
    OdinButtonSize? size,
  }) {
    return Builder(
      builder: (context) {
        final parent = OdinDefaultButtonProperties.maybeOf(context);

        return OdinDefaultButtonProperties(
          key: key,
          kind: kind ?? parent?.kind,
          size: size ?? parent?.size,
          child: child,
        );
      },
    );
  }

  final OdinButtonKind? kind;
  final OdinButtonSize? size;

  static OdinDefaultButtonProperties? maybeOf(BuildContext context, [String? aspect]) {
    return InheritedModel.inheritFrom<OdinDefaultButtonProperties>(context, aspect: aspect);
  }

  static OdinButtonKind? kindOf(BuildContext context) {
    return InheritedModel.inheritFrom<OdinDefaultButtonProperties>(
      context,
      aspect: _ButtonProperty.kind,
    )?.kind;
  }

  static OdinButtonSize? sizeOf(BuildContext context) {
    return InheritedModel.inheritFrom<OdinDefaultButtonProperties>(
      context,
      aspect: _ButtonProperty.size,
    )?.size;
  }

  @override
  bool updateShouldNotify(OdinDefaultButtonProperties oldWidget) {
    if (identical(this, oldWidget)) {
      return false;
    }
    return oldWidget.kind != kind || oldWidget.size != size;
  }

  @override
  bool updateShouldNotifyDependent(
    OdinDefaultButtonProperties oldWidget,
    Set<_ButtonProperty> dependencies,
  ) {
    if (identical(this, oldWidget)) {
      return false;
    }
    return (dependencies.contains(_ButtonProperty.kind) && oldWidget.kind != kind) || //
        (dependencies.contains(_ButtonProperty.size) && oldWidget.size != size);
  }
}

final class OdinButton extends StatelessWidget {
  const OdinButton({
    required this.label,
    super.key,
    this.kind,
    this.size,
    this.leftIcon,
    this.rightIcon,
    this.onPress,
    this.semantics = const OdinSemanticsData(),
  });

  OdinButton.fromActionSettings({
    required OdinActionSettings<VoidCallback> actionSettings,
    super.key,
    this.kind,
    this.size,
  }) : label = Text(actionSettings.text),
       leftIcon = actionSettings.leftIcon == null
           ? null //
           : Icon(actionSettings.leftIcon),
       rightIcon = actionSettings.rightIcon == null
           ? null //
           : Icon(actionSettings.rightIcon),
       semantics = actionSettings.semantics,
       onPress = actionSettings.onPress;

  final Widget label;
  final OdinButtonKind? kind;
  final OdinButtonSize? size;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final VoidCallback? onPress;
  final OdinSemanticsData semantics;

  @override
  Widget build(BuildContext context) {
    final buttonTheme = OdinButtonTheme.of(context);

    final kind = this.kind ?? OdinDefaultButtonProperties.kindOf(context) ?? OdinButtonKind.primary;
    final size = this.size ?? OdinDefaultButtonProperties.sizeOf(context) ?? OdinButtonSize.normal;

    final buttonStyle = switch ((kind, size)) {
      (OdinButtonKind.primary, OdinButtonSize.compact) => buttonTheme.primaryCompactButtonStyle,
      (OdinButtonKind.primary, OdinButtonSize.normal) => buttonTheme.primaryNormalButtonStyle,
      (OdinButtonKind.primary, OdinButtonSize.fullWidth) => buttonTheme.primaryFullWidthButtonStyle,
      (OdinButtonKind.neutral, OdinButtonSize.compact) => buttonTheme.neutralCompactButtonStyle,
      (OdinButtonKind.neutral, OdinButtonSize.normal) => buttonTheme.neutralNormalButtonStyle,
      (OdinButtonKind.neutral, OdinButtonSize.fullWidth) => buttonTheme.neutralFullWidthButtonStyle,
      (OdinButtonKind.line, OdinButtonSize.compact) => buttonTheme.lineCompactButtonStyle,
      (OdinButtonKind.line, OdinButtonSize.normal) => buttonTheme.lineNormalButtonStyle,
      (OdinButtonKind.line, OdinButtonSize.fullWidth) => buttonTheme.lineFullWidthButtonStyle,
    };

    final padding = switch (size) {
      OdinButtonSize.compact => const EdgeInsets.symmetric(
        horizontal: OdinPaddingValue.xs,
        vertical: OdinPaddingValue.xxs,
      ),
      OdinButtonSize.normal => const EdgeInsets.all(OdinPaddingValue.xs),
      OdinButtonSize.fullWidth => const EdgeInsets.all(OdinPaddingValue.xs),
    };

    return OdinIconContainerTheme(
      data: OdinIconContainerTheme.of(context).copyWith(size: OdinIconContainerSize.size16),
      child: Semantics.fromProperties(
        excludeSemantics: semantics.exclude,
        container: semantics.container,
        blockUserActions: semantics.blockUserActions,
        explicitChildNodes: semantics.explicitChildNodes,
        key: semantics.key,
        properties: semantics.properties,
        child: _ButtonBase(
          buttonStyle: buttonStyle,
          onPress: onPress,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 16),
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leftIcon case final leading?) ...[
                    leading,
                    OdinGap.xxs,
                  ],
                  Flexible(
                    child: label,
                  ),
                  if (rightIcon case final trailing?) ...[
                    OdinGap.xxs,
                    trailing,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class OdinButtonInline extends StatelessWidget {
  const OdinButtonInline({
    required this.isSelected,
    required this.label,
    super.key,
    this.leftIcon,
    this.rightIcon,
    this.onPress,
  });

  OdinButtonInline.fromActionSettings({
    required this.isSelected,
    required OdinActionSettings<VoidCallback> actionSettings,
    super.key,
  }) : label = Text(actionSettings.text),
       leftIcon = actionSettings.leftIcon == null
           ? null //
           : Icon(actionSettings.leftIcon),
       rightIcon = actionSettings.rightIcon == null
           ? null //
           : Icon(actionSettings.rightIcon),
       onPress = actionSettings.onPress;

  final bool isSelected;
  final Widget label;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = OdinButtonTheme.of(context).inlineButtonStyle;

    final resolvedButtonStyle = isSelected
        ? buttonStyle.copyWith(
            backgroundColor: generateState(
              buttonStyle.backgroundColor.resolve({WidgetState.selected}),
              pressed: buttonStyle.backgroundColor.resolve({WidgetState.pressed}),
              disabled: buttonStyle.backgroundColor.resolve({WidgetState.disabled}),
            ),
            foregroundColor: generateState(
              buttonStyle.foregroundColor.resolve({WidgetState.selected}),
              pressed: buttonStyle.foregroundColor.resolve({WidgetState.pressed}),
              disabled: buttonStyle.foregroundColor.resolve({WidgetState.disabled}),
            ),
          )
        : buttonStyle;

    return OdinIconContainerTheme(
      data: OdinIconContainerTheme.of(context).copyWith(size: OdinIconContainerSize.size16),
      child: _ButtonBase(
        buttonStyle: resolvedButtonStyle,
        onPress: onPress,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 16),
          child: Padding(
            padding: const EdgeInsets.all(OdinPaddingValue.xxs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leftIcon case final leading?) ...[
                  leading,
                  OdinGap.xxxs,
                ],
                label,
                if (rightIcon case final trailing?) ...[
                  OdinGap.xxxs,
                  trailing,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class OdinButtonForward extends StatelessWidget {
  const OdinButtonForward({
    super.key,
    this.onPress,
  });

  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = OdinButtonTheme.of(context).forwardButtonStyle;

    return _ButtonBase(
      buttonStyle: buttonStyle,
      onPress: onPress,
      shape: generateState(const CircleBorder()),
      child: const Padding(
        padding: EdgeInsets.all(OdinPaddingValue.xxs),
        child: Icon(OdinIcons.right, size: 24),
      ),
    );
  }
}

enum OdinButtonShortcutKind {
  normal,
  neww,
}

final class OdinButtonShortcut extends StatelessWidget {
  const OdinButtonShortcut({
    required this.kind,
    required this.hasOutline,
    required this.label,
    super.key,
    this.badge,
    this.icon,
    this.onPress,
  });

  final OdinButtonShortcutKind kind;
  final bool hasOutline;
  final Widget label;
  final Widget? badge;
  final Widget? icon;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final buttonTheme = OdinButtonTheme.of(context);

    OdinButtonStyle buttonStyle = switch (kind) {
      OdinButtonShortcutKind.normal => buttonTheme.normalShortcutButtonStyle,
      OdinButtonShortcutKind.neww => buttonTheme.newShortcutButtonStyle,
    };
    if (!hasOutline) {
      buttonStyle = buttonStyle.copyWith(
        borderSide: generateStateBorderSide(0.0, kTransparentColor),
      );
    }

    return AspectRatio(
      aspectRatio: 1.0,
      child: _ButtonBase(
        buttonStyle: buttonStyle,
        onPress: onPress,
        child: Padding(
          padding: const EdgeInsets.all(OdinPaddingValue.xxs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (badge case final badge?) badge,
                  OdinGap.xxs,
                  if (icon case final icon?)
                    OdinIconContainerTheme(
                      data: OdinIconContainerTheme.of(
                        context,
                      ).copyWith(size: OdinIconContainerSize.size24),
                      child: icon,
                    ),
                ],
              ),
              OdinGap.xxs,
              DefaultTextStyle.merge(
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                child: label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ButtonBase extends StatefulWidget {
  const _ButtonBase({
    required this.buttonStyle,
    required this.child,
    this.shape,
    this.onPress,
  });

  final OdinButtonStyle buttonStyle;
  final WidgetStateProperty<OutlinedBorder>? shape;
  final VoidCallback? onPress;
  final Widget child;

  @override
  State<_ButtonBase> createState() => _ButtonBaseState();
}

final class _ButtonBaseState extends State<_ButtonBase> {
  final statesController = WidgetStatesController();

  @override
  void dispose() {
    statesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = widget.buttonStyle;

    final shape =
        widget.shape ??
        WidgetStateProperty.resolveWith((states) {
          return RoundedRectangleBorder(
            borderRadius: buttonStyle.radius,
            side: buttonStyle.borderSide?.resolve(states) ?? BorderSide.none,
          );
        });

    return DecoratedBox(
      decoration: BoxDecoration(boxShadow: buttonStyle.elevation),
      child: ElevatedButton(
        onPressed: widget.onPress,
        statesController: statesController,
        style:
            ElevatedButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.zero,
              minimumSize: buttonStyle.minimumSize,
            ).copyWith(
              elevation: WidgetStateProperty.all(0.0),
              backgroundColor: buttonStyle.backgroundColor,
              foregroundColor: buttonStyle.foregroundColor,
              overlayColor: buttonStyle.overlayColor,
              shape: shape,
              iconColor: buttonStyle.iconColor,
              textStyle: buttonStyle.textStyle,
            ),
        child: Builder(
          builder: (context) {
            return DefaultTextStyle(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DefaultTextStyle.of(context).style,
              child: widget.child,
            );
          },
        ),
      ),
    );
  }
}

final class OdinButtonFixed extends StatelessWidget {
  const OdinButtonFixed({
    required this.button,
    super.key,
    this.externalLink,
    this.overline,
    this.title,
    this.checkbox,
    this.legalCheckbox,
    this.notification,
    this.defaultLink,
    this.link,
  });

  final OdinLink? externalLink;
  final Widget? overline;
  final Widget? title;
  final OdinCheckboxLabel? checkbox;
  final OdinSubButtonFixedCheckboxAccordion? legalCheckbox;
  final OdinNotificationInline? notification;
  final OdinLink? defaultLink;
  final OdinButton button;
  final OdinLink? link;

  @override
  Widget build(BuildContext context) {
    return OdinBaseButtonFixed(
      externalLink: externalLink,
      overline: overline,
      title: title,
      checkbox: checkbox,
      legalCheckbox: legalCheckbox,
      notification: notification,
      defaultLink: defaultLink,
      button: button,
      link: link,
      hasDivider: true,
    );
  }
}

final class OdinBaseButtonFixed extends StatelessWidget {
  const OdinBaseButtonFixed({
    required this.hasDivider,
    super.key,
    this.externalLink,
    this.overline,
    this.title,
    this.checkbox,
    this.legalCheckbox,
    this.notification,
    this.defaultLink,
    this.button,
    this.link,
    this.semantics = const OdinSemanticsData(),
  });

  final OdinLink? externalLink;
  final Widget? overline;
  final Widget? title;
  final OdinCheckboxLabel? checkbox;
  final OdinSubButtonFixedCheckboxAccordion? legalCheckbox;
  final OdinNotificationInline? notification;
  final OdinLink? defaultLink;
  final OdinButton? button;
  final OdinLink? link;
  final bool hasDivider;
  final OdinSemanticsData semantics;

  bool get _hasContent {
    return externalLink != null || //
        overline != null ||
        title != null ||
        checkbox != null ||
        legalCheckbox != null ||
        notification != null ||
        defaultLink != null ||
        button != null ||
        link != null;
  }

  @override
  Widget build(BuildContext context) {
    if (_hasContent) {
      final theme = OdinThemeProvider.of(context);

      const invisibleBorder = OdinBorderSide(
        color: Color(0x00000000),
        stroke: 1.0,
        borderStyle: OdinSolidBorderStyle(),
      );

      return DecoratedBox(
        decoration: BoxDecoration(
          color: theme.appColorScheme.neutralBase,
          border: hasDivider
              ? OdinBorder(
                  left: invisibleBorder,
                  right: invisibleBorder,
                  top: OdinBorderSide(
                    borderStyle: const OdinBorderStyle.solid(),
                    color: theme.appColorScheme.outlineBase,
                    stroke: theme.borderTheme.strokeThin,
                  ),
                  bottom: invisibleBorder,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: OdinPaddingValue.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              OdinGap.sm,
              if (externalLink case final externalLink?) ...[
                externalLink,
                OdinGap.sm,
              ],
              if (overline case final overline?) ...[
                DefaultTextStyle(
                  style: theme.typography.labelTiny.copyWith(
                    color: theme.appColorScheme.onColorEmphasisLow,
                  ),
                  child: overline,
                ),
                if (title != null) OdinGap.xxs else OdinGap.sm,
              ],
              if (title case final title?) ...[
                DefaultTextStyle(
                  style: theme.typography.titleSmall.copyWith(
                    color: theme.appColorScheme.onColorEmphasisHigh,
                  ),
                  child: title,
                ),
                OdinGap.sm,
              ],
              if (checkbox case final checkbox?) ...[
                Transform.translate(
                  offset: const Offset(0.0, -kCheckboxExtraSpacing),
                  child: checkbox,
                ),
                const SizedBox(
                  height: OdinGapValue.sm - 2 * kCheckboxExtraSpacing,
                ),
              ],
              if (legalCheckbox case final legalCheckbox?) ...[
                legalCheckbox,
                OdinGap.sm,
              ],
              if (notification case final notification?) ...[
                notification,
                OdinGap.sm,
              ],
              if (defaultLink case final defaultLink?) ...[
                defaultLink,
                OdinGap.sm,
              ],
              if (button case final button?) ...[
                OdinDefaultButtonProperties(
                  kind: OdinButtonKind.primary,
                  size: OdinButtonSize.fullWidth,
                  child: button,
                ),
                OdinGap.sm,
              ],
              if (link case final link?) ...[
                OdinGap.xxs,
                Center(
                  child: Semantics.fromProperties(
                    excludeSemantics: semantics.exclude,
                    container: semantics.container,
                    blockUserActions: semantics.blockUserActions,
                    explicitChildNodes: semantics.explicitChildNodes,
                    key: semantics.key,
                    properties: semantics.properties,
                    child: link,
                  ),
                ),
                OdinGap.sm,
                if (Theme.of(context).platform.isAndroid) //
                  OdinGap.xxs,
              ],
              const OdinBottomSafeAreaSpacer(),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

final class OdinSubButtonFixedCheckboxAccordion extends StatelessWidget {
  const OdinSubButtonFixedCheckboxAccordion({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 50,
      child: Placeholder(),
    );
  }
}

final class OdinButtonTheme extends InheritedTheme {
  const OdinButtonTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinButtonThemeData data;

  static OdinButtonThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinButtonTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).buttonTheme;
  }

  @override
  bool updateShouldNotify(OdinButtonTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinButtonTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinButtonThemeData {
  OdinButtonThemeData({
    required this.primaryCompactButtonStyle,
    required this.primaryNormalButtonStyle,
    required this.primaryFullWidthButtonStyle,
    required this.neutralCompactButtonStyle,
    required this.neutralNormalButtonStyle,
    required this.neutralFullWidthButtonStyle,
    required this.lineCompactButtonStyle,
    required this.lineNormalButtonStyle,
    required this.lineFullWidthButtonStyle,
    required this.inlineButtonStyle,
    required this.forwardButtonStyle,
    required this.normalShortcutButtonStyle,
    required this.newShortcutButtonStyle,
  });

  final OdinButtonStyle primaryCompactButtonStyle;
  final OdinButtonStyle primaryNormalButtonStyle;
  final OdinButtonStyle primaryFullWidthButtonStyle;
  final OdinButtonStyle neutralCompactButtonStyle;
  final OdinButtonStyle neutralNormalButtonStyle;
  final OdinButtonStyle neutralFullWidthButtonStyle;
  final OdinButtonStyle lineCompactButtonStyle;
  final OdinButtonStyle lineNormalButtonStyle;
  final OdinButtonStyle lineFullWidthButtonStyle;
  final OdinButtonStyle inlineButtonStyle;
  final OdinButtonStyle forwardButtonStyle;
  final OdinButtonStyle normalShortcutButtonStyle;
  final OdinButtonStyle newShortcutButtonStyle;

  static OdinButtonThemeData lerp(OdinButtonThemeData a, OdinButtonThemeData b, double t) {
    return OdinButtonThemeData(
      primaryCompactButtonStyle: OdinButtonStyle.lerp(
        a.primaryCompactButtonStyle,
        b.primaryCompactButtonStyle,
        t,
      ),
      primaryNormalButtonStyle: OdinButtonStyle.lerp(
        a.primaryNormalButtonStyle,
        b.primaryNormalButtonStyle,
        t,
      ),
      primaryFullWidthButtonStyle: OdinButtonStyle.lerp(
        a.primaryFullWidthButtonStyle,
        b.primaryFullWidthButtonStyle,
        t,
      ),
      neutralCompactButtonStyle: OdinButtonStyle.lerp(
        a.neutralCompactButtonStyle,
        b.neutralCompactButtonStyle,
        t,
      ),
      neutralNormalButtonStyle: OdinButtonStyle.lerp(
        a.neutralNormalButtonStyle,
        b.neutralNormalButtonStyle,
        t,
      ),
      neutralFullWidthButtonStyle: OdinButtonStyle.lerp(
        a.neutralFullWidthButtonStyle,
        b.neutralFullWidthButtonStyle,
        t,
      ),
      lineCompactButtonStyle: OdinButtonStyle.lerp(
        a.lineCompactButtonStyle,
        b.lineCompactButtonStyle,
        t,
      ),
      lineNormalButtonStyle: OdinButtonStyle.lerp(
        a.lineNormalButtonStyle,
        b.lineNormalButtonStyle,
        t,
      ),
      lineFullWidthButtonStyle: OdinButtonStyle.lerp(
        a.lineFullWidthButtonStyle,
        b.lineFullWidthButtonStyle,
        t,
      ),
      inlineButtonStyle: OdinButtonStyle.lerp(a.inlineButtonStyle, b.inlineButtonStyle, t),
      forwardButtonStyle: OdinButtonStyle.lerp(a.forwardButtonStyle, b.forwardButtonStyle, t),
      normalShortcutButtonStyle: OdinButtonStyle.lerp(
        a.normalShortcutButtonStyle,
        b.normalShortcutButtonStyle,
        t,
      ),
      newShortcutButtonStyle: OdinButtonStyle.lerp(
        a.newShortcutButtonStyle,
        b.newShortcutButtonStyle,
        t,
      ),
    );
  }

  OdinButtonThemeData copyWith({
    OdinButtonStyle? primaryCompactButtonStyle,
    OdinButtonStyle? primaryNormalButtonStyle,
    OdinButtonStyle? primaryFullWidthButtonStyle,
    OdinButtonStyle? neutralCompactButtonStyle,
    OdinButtonStyle? neutralNormalButtonStyle,
    OdinButtonStyle? neutralFullWidthButtonStyle,
    OdinButtonStyle? lineCompactButtonStyle,
    OdinButtonStyle? lineNormalButtonStyle,
    OdinButtonStyle? lineFullWidthButtonStyle,
    OdinButtonStyle? inlineButtonStyle,
    OdinButtonStyle? forwardButtonStyle,
    OdinButtonStyle? normalShortcutButtonStyle,
    OdinButtonStyle? newShortcutButtonStyle,
  }) {
    return OdinButtonThemeData(
      primaryCompactButtonStyle: primaryCompactButtonStyle ?? this.primaryCompactButtonStyle,
      primaryNormalButtonStyle: primaryNormalButtonStyle ?? this.primaryNormalButtonStyle,
      primaryFullWidthButtonStyle: primaryFullWidthButtonStyle ?? this.primaryFullWidthButtonStyle,
      neutralCompactButtonStyle: neutralCompactButtonStyle ?? this.neutralCompactButtonStyle,
      neutralNormalButtonStyle: neutralNormalButtonStyle ?? this.neutralNormalButtonStyle,
      neutralFullWidthButtonStyle: neutralFullWidthButtonStyle ?? this.neutralFullWidthButtonStyle,
      lineCompactButtonStyle: lineCompactButtonStyle ?? this.lineCompactButtonStyle,
      lineNormalButtonStyle: lineNormalButtonStyle ?? this.lineNormalButtonStyle,
      lineFullWidthButtonStyle: lineFullWidthButtonStyle ?? this.lineFullWidthButtonStyle,
      inlineButtonStyle: inlineButtonStyle ?? this.inlineButtonStyle,
      forwardButtonStyle: forwardButtonStyle ?? this.forwardButtonStyle,
      normalShortcutButtonStyle: normalShortcutButtonStyle ?? this.normalShortcutButtonStyle,
      newShortcutButtonStyle: newShortcutButtonStyle ?? this.newShortcutButtonStyle,
    );
  }

  OdinButtonThemeData copyAllStylesWith({
    BorderRadius? radius,
    WidgetStateProperty<TextStyle>? textStyle,
    WidgetStateProperty<OdinBorderSide>? borderSide,
    WidgetStateProperty<Color>? backgroundColor,
    WidgetStateProperty<Color>? foregroundColor,
    WidgetStateProperty<Color>? overlayColor,
    List<BoxShadow>? elevation,
    Size? minimumSize,
  }) {
    OdinButtonStyle applyInStyle(OdinButtonStyle style) {
      return style.copyWith(
        radius: radius ?? style.radius,
        textStyle: textStyle ?? style.textStyle,
        borderSide: borderSide ?? style.borderSide,
        backgroundColor: backgroundColor ?? style.backgroundColor,
        foregroundColor: foregroundColor ?? style.foregroundColor,
        overlayColor: overlayColor ?? style.overlayColor,
        elevation: elevation ?? style.elevation,
        minimumSize: minimumSize ?? style.minimumSize,
      );
    }

    return OdinButtonThemeData(
      primaryCompactButtonStyle: applyInStyle(primaryCompactButtonStyle),
      primaryNormalButtonStyle: applyInStyle(primaryNormalButtonStyle),
      primaryFullWidthButtonStyle: applyInStyle(primaryFullWidthButtonStyle),
      neutralCompactButtonStyle: applyInStyle(neutralCompactButtonStyle),
      neutralNormalButtonStyle: applyInStyle(neutralNormalButtonStyle),
      neutralFullWidthButtonStyle: applyInStyle(neutralFullWidthButtonStyle),
      lineCompactButtonStyle: applyInStyle(lineCompactButtonStyle),
      lineNormalButtonStyle: applyInStyle(lineNormalButtonStyle),
      lineFullWidthButtonStyle: applyInStyle(lineFullWidthButtonStyle),
      inlineButtonStyle: applyInStyle(inlineButtonStyle),
      forwardButtonStyle: applyInStyle(forwardButtonStyle),
      normalShortcutButtonStyle: applyInStyle(normalShortcutButtonStyle),
      newShortcutButtonStyle: applyInStyle(newShortcutButtonStyle),
    );
  }
}

final class OdinButtonStyle {
  const OdinButtonStyle({
    required this.radius,
    required this.textStyle,
    required this.borderSide,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.overlayColor,
    required this.iconColor,
    required this.elevation,
    required this.minimumSize,
  });

  final BorderRadius radius;
  final WidgetStateProperty<TextStyle> textStyle;
  final WidgetStateProperty<OdinBorderSide>? borderSide;
  final WidgetStateProperty<Color> backgroundColor;
  final WidgetStateProperty<Color> foregroundColor;
  final WidgetStateProperty<Color> overlayColor;
  final WidgetStateProperty<Color>? iconColor;
  final List<BoxShadow>? elevation;
  final Size minimumSize;

  static OdinButtonStyle lerp(OdinButtonStyle a, OdinButtonStyle b, double t) {
    return OdinButtonStyle(
      radius: BorderRadius.lerp(a.radius, b.radius, t)!,
      textStyle: WidgetStateProperty.lerp(a.textStyle, b.textStyle, t, TextStyle.lerp)! as WidgetStateProperty<TextStyle>,
      borderSide: WidgetStateProperty.lerp(a.borderSide, b.borderSide, t, OdinBorderSide.lerpNullable)! as WidgetStateProperty<OdinBorderSide>,
      backgroundColor: WidgetStateProperty.lerp(a.backgroundColor, b.backgroundColor, t, Color.lerp)! as WidgetStateProperty<Color>,
      foregroundColor: WidgetStateProperty.lerp(a.foregroundColor, b.foregroundColor, t, Color.lerp)! as WidgetStateProperty<Color>,
      overlayColor: WidgetStateProperty.lerp(a.overlayColor, b.overlayColor, t, Color.lerp)! as WidgetStateProperty<Color>,
      iconColor: WidgetStateProperty.lerp(a.iconColor, b.iconColor, t, Color.lerp) as WidgetStateProperty<Color>?,
      elevation: t < 0.5 ? a.elevation : b.elevation,
      minimumSize: Size.lerp(a.minimumSize, b.minimumSize, t)!,
    );
  }

  OdinButtonStyle copyWith({
    BorderRadius? radius,
    WidgetStateProperty<TextStyle>? textStyle,
    WidgetStateProperty<OdinBorderSide>? borderSide,
    WidgetStateProperty<Color>? backgroundColor,
    WidgetStateProperty<Color>? foregroundColor,
    WidgetStateProperty<Color>? overlayColor,
    WidgetStateProperty<Color>? iconColor,
    List<BoxShadow>? elevation,
    Size? minimumSize,
  }) {
    return OdinButtonStyle(
      radius: radius ?? this.radius,
      textStyle: textStyle ?? this.textStyle,
      borderSide: borderSide ?? this.borderSide,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      overlayColor: overlayColor ?? this.overlayColor,
      iconColor: iconColor ?? this.iconColor,
      elevation: elevation ?? this.elevation,
      minimumSize: minimumSize ?? this.minimumSize,
    );
  }
}

OdinButtonThemeData createDefaultButtonTheme({
  required OdinColorScheme colorScheme,
  required OdinTypography typography,
  required OdinBorderThemeData borderTheme,
  bool isInverse = false,
}) {
  final compactTextStyle = WidgetStateProperty.all(typography.labelSmall.copyWith(height: 1.0));
  final normalTextStyle = WidgetStateProperty.all(typography.labelSmall.copyWith(height: 1.0));
  final fullWidthTextStyle = WidgetStateProperty.all(typography.labelBase.copyWith(height: 1.0));

  const compactMinimumSize = Size(0.0, 32.0);
  const normalMinimumSize = Size(0.0, 48.0);
  const fullWidthMinimumSize = Size(double.infinity, 56.0);

  final baseButtonStyle = OdinButtonStyle(
    radius: BorderRadius.all(borderTheme.radiusSmall),
    textStyle: normalTextStyle,
    borderSide: null,
    backgroundColor: generateState(kTransparentColor),
    foregroundColor: generateState(kTransparentColor),
    overlayColor: WidgetStateProperty.all(kTransparentColor),
    iconColor: null,
    elevation: null,
    minimumSize: Size.zero,
  );

  final primaryButtonStyle = baseButtonStyle.copyWith(
    backgroundColor: generateState(
      colorScheme.actionMainEnabled,
      pressed: colorScheme.actionMainPressed,
      disabled: colorScheme.actionDisabledBase,
    ),
    foregroundColor: isInverse
        ? generateState(
            colorScheme.onColorEmphasisHigh,
            pressed: colorScheme.onColorEmphasisHigh,
            disabled: colorScheme.onColorEmphasisDisabled,
          )
        : generateState(
            colorScheme.onColorEmphasisHighInverse,
            pressed: colorScheme.onColorEmphasisHighInverse,
            disabled: colorScheme.onColorEmphasisDisabled,
          ),
  );

  final neutralButtonStyle = baseButtonStyle.copyWith(
    backgroundColor: generateState(
      colorScheme.actionNeutralEnabledInverse,
      pressed: colorScheme.actionNeutralPressedInverse,
      disabled: colorScheme.actionDisabledBase,
    ),
    foregroundColor: generateState(
      colorScheme.onColorEmphasisHighInverse,
      pressed: colorScheme.onColorEmphasisHighInverse,
      disabled: colorScheme.onColorEmphasisDisabled,
    ),
  );

  final lineButtonStyle = baseButtonStyle.copyWith(
    borderSide: generateStateBorderSide(
      borderTheme.strokeThin,
      colorScheme.actionSecondaryEnabled,
      pressedColor: colorScheme.actionSecondaryPressed,
      disabledColor: colorScheme.actionDisabledBase,
      borderStyle: const OdinSolidBorderStyle(),
    ),
    backgroundColor: WidgetStateProperty.all(kTransparentColor),
    foregroundColor: generateState(
      colorScheme.onColorEmphasisHigh,
      pressed: colorScheme.onColorEmphasisHigh,
      disabled: colorScheme.onColorEmphasisDisabled,
    ),
  );

  final inlineButtonStyle = baseButtonStyle.copyWith(
    borderSide: generateStateBorderSide(
      borderTheme.strokeThin,
      colorScheme.outlineBase,
      pressedColor: colorScheme.outlineBase,
      disabledColor: kTransparentColor,
      selectedColor: kTransparentColor,
      borderStyle: const OdinSolidBorderStyle(),
    ),
    backgroundColor: generateState(
      colorScheme.actionNeutralEnabled,
      pressed: colorScheme.actionNeutralPressed,
      disabled: colorScheme.actionDisabledBase,
      selected: colorScheme.actionMainSelected,
    ),
    foregroundColor: isInverse
        ? generateState(
            colorScheme.onColorEmphasisHigh,
            pressed: colorScheme.onColorEmphasisHigh,
            disabled: colorScheme.onColorEmphasisDisabled,
            selected: colorScheme.onColorEmphasisHigh,
          )
        : generateState(
            colorScheme.onColorEmphasisHigh,
            pressed: colorScheme.onColorEmphasisHigh,
            disabled: colorScheme.onColorEmphasisDisabled,
            selected: colorScheme.onColorEmphasisHighInverse,
          ),
  );

  final forwardButtonStyle = baseButtonStyle.copyWith(
    backgroundColor: generateState(
      colorScheme.actionMainEnabled,
      pressed: colorScheme.actionMainPressed,
      disabled: colorScheme.actionDisabledBase,
    ),
    foregroundColor: isInverse
        ? generateState(
            colorScheme.onColorEmphasisHigh,
            pressed: colorScheme.onColorEmphasisHigh,
            disabled: colorScheme.onColorEmphasisDisabled,
          )
        : generateState(
            colorScheme.onColorEmphasisHighInverse,
            pressed: colorScheme.onColorEmphasisHighInverse,
            disabled: colorScheme.onColorEmphasisDisabled,
          ),
    elevation: colorScheme.elevationMedium,
    minimumSize: const Size.square(48.0),
  );

  final normalShortcutButtonStyle = baseButtonStyle.copyWith(
    borderSide: generateStateBorderSide(
      borderTheme.strokeThin,
      colorScheme.outlineBase,
      borderStyle: const OdinSolidBorderStyle(),
    ),
    backgroundColor: generateState(
      colorScheme.actionNeutralEnabled,
      pressed: colorScheme.actionNeutralPressed,
    ),
    foregroundColor: generateState(colorScheme.onColorEmphasisHigh),
    iconColor: generateState(colorScheme.secondaryBase),
  );

  final newShortcutButtonStyle = baseButtonStyle.copyWith(
    borderSide: generateStateBorderSide(
      borderTheme.strokeThin,
      colorScheme.outlineBase,
      borderStyle: borderTheme.dashStyleSmall,
    ),
    backgroundColor: generateState(
      kTransparentColor,
      pressed: colorScheme.actionNeutralPressed,
    ),
    foregroundColor: generateState(colorScheme.onColorEmphasisHigh),
    iconColor: generateState(colorScheme.secondaryBase),
  );

  return OdinButtonThemeData(
    primaryCompactButtonStyle: primaryButtonStyle.copyWith(
      minimumSize: compactMinimumSize,
      textStyle: compactTextStyle,
    ),
    primaryNormalButtonStyle: primaryButtonStyle.copyWith(
      minimumSize: normalMinimumSize,
      textStyle: normalTextStyle,
    ),
    primaryFullWidthButtonStyle: primaryButtonStyle.copyWith(
      minimumSize: fullWidthMinimumSize,
      textStyle: fullWidthTextStyle,
    ),
    neutralCompactButtonStyle: neutralButtonStyle.copyWith(
      minimumSize: compactMinimumSize,
      textStyle: compactTextStyle,
    ),
    neutralNormalButtonStyle: neutralButtonStyle.copyWith(
      minimumSize: normalMinimumSize,
      textStyle: normalTextStyle,
    ),
    neutralFullWidthButtonStyle: neutralButtonStyle.copyWith(
      minimumSize: fullWidthMinimumSize,
      textStyle: fullWidthTextStyle,
    ),
    lineCompactButtonStyle: lineButtonStyle.copyWith(
      minimumSize: compactMinimumSize,
      textStyle: compactTextStyle,
    ),
    lineNormalButtonStyle: lineButtonStyle.copyWith(
      minimumSize: normalMinimumSize,
      textStyle: normalTextStyle,
    ),
    lineFullWidthButtonStyle: lineButtonStyle.copyWith(
      minimumSize: fullWidthMinimumSize,
      textStyle: fullWidthTextStyle,
    ),
    inlineButtonStyle: inlineButtonStyle,
    forwardButtonStyle: forwardButtonStyle,
    normalShortcutButtonStyle: normalShortcutButtonStyle,
    newShortcutButtonStyle: newShortcutButtonStyle,
  );
}
