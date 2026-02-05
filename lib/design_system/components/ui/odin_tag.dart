import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

final class OdinTagFilter extends StatelessWidget {
  const OdinTagFilter({
    required this.label,
    super.key,
    this.isSelected = false,
    this.onChanged,
  });

  final Widget label;
  final bool isSelected;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final tagTheme = OdinTagTheme.of(context);
    final tagStyle = tagTheme.tagStyle;

    return _OdinTag(
      isSelected: isSelected,
      onChanged: onChanged,
      builder: (context, states, child) {
        return DefaultTextStyle(
          style: theme.typography.labelSmall.copyWith(
            color: tagStyle.labelColor.resolve(states),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: tagStyle.backgroundColor.resolve(states),
              border: Border.all(color: tagStyle.borderColor.resolve(states)),
              borderRadius: BorderRadius.all(tagStyle.borderRadius),
            ),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: tagStyle.innerPadding,
        child: label,
      ),
    );
  }
}

final class OdinTagSearch extends StatelessWidget {
  const OdinTagSearch({
    required this.label,
    super.key,
    this.onTap,
  });

  final Widget label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final tagTheme = OdinTagTheme.of(context);
    final tagStyle = tagTheme.tagStyle;
    final onTap = this.onTap;

    return _OdinTag(
      isSelected: true,
      onChanged: onTap != null
          ? ((value) => onTap()) //
          : null,
      child: Padding(
        padding: tagStyle.innerPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            label,
            OdinGap.xxxs,
            const Icon(
              OdinIcons.close,
              size: 16.0,
            ),
          ],
        ),
      ),
      builder: (context, states, child) {
        final labelColor = tagStyle.labelColor.resolve(states);

        return DefaultTextStyle(
          style: theme.typography.labelSmall.copyWith(color: labelColor),
          child: OdinIconContainerTheme(
            data: OdinIconContainerTheme.of(context).copyWith(foregroundColor: labelColor),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: tagStyle.backgroundColor.resolve(states),
                border: Border.all(color: tagStyle.borderColor.resolve(states)),
                borderRadius: BorderRadius.all(tagStyle.borderRadius),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _OdinTag extends StatefulWidget {
  const _OdinTag({
    required this.builder,
    required this.isSelected,
    this.child,
    this.onChanged,
  });

  final ValueWidgetBuilder<Set<WidgetState>> builder;
  final Widget? child;
  final bool isSelected;
  final ValueChanged<bool>? onChanged;

  @override
  State<_OdinTag> createState() => _OdinTagState();
}

class _OdinTagState extends State<_OdinTag> {
  late bool _isSelected = widget.isSelected;
  late bool _isEnabled = widget.onChanged != null;
  bool _isPressed = false;

  @override
  void didUpdateWidget(_OdinTag oldWidget) {
    super.didUpdateWidget(oldWidget);

    final isSelected = widget.isSelected;
    final isEnabled = widget.onChanged != null;

    if (_isSelected != isSelected || _isEnabled != isEnabled) {
      _isSelected = isSelected;
      _isEnabled = isEnabled;
      if (!isEnabled) {
        _isPressed = false;
      }
    }
  }

  void _onUpdatePressed({required bool value}) {
    if (_isEnabled && _isPressed != value) {
      setState(() => _isPressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onChanged = widget.onChanged;
    final states = <WidgetState>{
      if (_isSelected) WidgetState.selected,
      if (_isPressed) WidgetState.pressed,
      if (!_isEnabled) WidgetState.disabled,
    };

    return OdinInkWell(
      onTapDown: (details) => _onUpdatePressed(value: true),
      onTapUp: (details) => _onUpdatePressed(value: false),
      onTapCancel: () => _onUpdatePressed(value: false),
      onTap: onChanged == null
          ? null //
          : () => onChanged(!_isSelected),
      child: widget.builder(context, states, widget.child),
    );
  }
}

final class OdinTagTheme extends InheritedTheme {
  const OdinTagTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinTagThemeData data;

  static OdinTagThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinTagTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).tagTheme;
  }

  @override
  bool updateShouldNotify(OdinTagTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinTagTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinTagThemeData {
  OdinTagThemeData({required this.tagStyle});

  final OdinTagStyle tagStyle;

  static OdinTagThemeData lerp(OdinTagThemeData a, OdinTagThemeData b, double t) {
    return OdinTagThemeData(
      tagStyle: OdinTagStyle.lerp(a.tagStyle, b.tagStyle, t),
    );
  }

  OdinTagThemeData copyWith({OdinTagStyle? tagStyle}) {
    return OdinTagThemeData(
      tagStyle: tagStyle ?? this.tagStyle,
    );
  }

  OdinTagThemeData copyAllStylesWith({
    EdgeInsets? innerPadding,
    Radius? borderRadius,
    WidgetStateProperty<Color>? backgroundColor,
    WidgetStateProperty<Color>? borderColor,
    WidgetStateProperty<Color>? labelColor,
  }) {
    return OdinTagThemeData(
      tagStyle: tagStyle.copyWith(
        innerPadding: innerPadding ?? tagStyle.innerPadding,
        borderRadius: borderRadius ?? tagStyle.borderRadius,
        backgroundColor: backgroundColor ?? tagStyle.backgroundColor,
        borderColor: borderColor ?? tagStyle.borderColor,
        labelColor: labelColor ?? tagStyle.labelColor,
      ),
    );
  }
}

final class OdinTagStyle {
  const OdinTagStyle({
    required this.innerPadding,
    required this.borderRadius,
    required this.backgroundColor,
    required this.borderColor,
    required this.labelColor,
  });

  final EdgeInsets innerPadding;
  final Radius borderRadius;
  final WidgetStateProperty<Color> backgroundColor;
  final WidgetStateProperty<Color> borderColor;
  final WidgetStateProperty<Color> labelColor;

  static OdinTagStyle lerp(OdinTagStyle a, OdinTagStyle b, double t) {
    return OdinTagStyle(
      innerPadding: EdgeInsets.lerp(a.innerPadding, b.innerPadding, t)!,
      borderRadius: Radius.lerp(a.borderRadius, b.borderRadius, t)!,
      backgroundColor: WidgetStateProperty.lerp(a.backgroundColor, b.backgroundColor, t, Color.lerp)! as WidgetStateProperty<Color>,
      borderColor: WidgetStateProperty.lerp(a.borderColor, b.borderColor, t, Color.lerp)! as WidgetStateProperty<Color>,
      labelColor: WidgetStateProperty.lerp(a.labelColor, b.labelColor, t, Color.lerp)! as WidgetStateProperty<Color>,
    );
  }

  OdinTagStyle copyWith({
    EdgeInsets? innerPadding,
    Radius? borderRadius,
    WidgetStateProperty<Color>? backgroundColor,
    WidgetStateProperty<Color>? borderColor,
    WidgetStateProperty<Color>? labelColor,
  }) {
    return OdinTagStyle(
      innerPadding: innerPadding ?? this.innerPadding,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      labelColor: labelColor ?? this.labelColor,
    );
  }
}

OdinTagThemeData createDefaultTagTheme({
  required OdinColorScheme colorScheme,
  required bool isInverse,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  return OdinTagThemeData(
    tagStyle: OdinTagStyle(
      innerPadding: const EdgeInsets.all(OdinPaddingValue.xxs),
      borderRadius: borderTheme.radiusSmall,
      backgroundColor: generateState(
        colorScheme.actionNeutralEnabled,
        selected: colorScheme.actionSecondarySelected,
        pressed: colorScheme.actionNeutralPressed,
        pressedAndSelected: colorScheme.actionNeutralPressed,
        disabled: colorScheme.actionDisabledBase,
      ),
      borderColor: generateState(
        colorScheme.outlineBase,
        disabled: kTransparentColor,
      ),
      labelColor: generateState(
        colorScheme.onColorEmphasisHigh,
        selected: colorScheme.onColorEmphasisHighInverse,
        pressed: colorScheme.onColorEmphasisHigh,
        pressedAndSelected: colorScheme.onColorEmphasisHigh,
        disabled: colorScheme.onColorEmphasisDisabled,
      ),
    ),
  );
}
