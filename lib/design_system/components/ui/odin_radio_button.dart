import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

const _kToggleDuration = Duration(milliseconds: 150);

enum OdinRadioButtonPosition {
  left,
  right,
}

class OdinRadioButton<T> extends StatelessWidget {
  const OdinRadioButton({
    required this.value,
    super.key,
    this.selectedValue,
    this.autofocus = false,
    this.focusNode,
    this.mouseCursor,
    this.onChanged,
  });

  final T value;
  final T? selectedValue;
  final bool autofocus;
  final FocusNode? focusNode;
  final MouseCursor? mouseCursor;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final style = OdinRadioButtonTheme.of(context).radioButtonStyle;

    return _OdinRadioButtonActionHandler(
      value: value,
      selectedValue: selectedValue,
      onChanged: onChanged,
      style: style,
      builder: (context, states) {
        return Padding(
          padding: style.padding,
          child: _OdinRadioButton(
            isEnabled: onChanged != null,
            state: _OdinRadioButtonInternalState.from(
              style: style,
              states: states,
              isSelected: value == selectedValue,
            ),
          ),
        );
      },
    );
  }
}

class OdinRadioButtonLabel<T> extends StatelessWidget {
  const OdinRadioButtonLabel({
    required this.label,
    required this.value,
    super.key,
    this.selectedValue,
    this.position = OdinRadioButtonPosition.right,
    this.onChanged,
  });

  final String label;
  final T value;
  final T? selectedValue;
  final OdinRadioButtonPosition position;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final style = theme.radioButtonTheme.radioButtonStyle;

    return _OdinRadioButtonActionHandler(
      value: value,
      selectedValue: selectedValue,
      style: style,
      onChanged: onChanged,
      shouldUseOutsideInkResponse: true,
      builder: (context, states) {
        return Padding(
          padding: EdgeInsets.only(
            top: style.padding.top,
            bottom: style.padding.bottom,
          ),
          child: Row(
            textDirection: position == OdinRadioButtonPosition.left
                ? (TextDirection.ltr) //
                : TextDirection.rtl,
            children: [
              _OdinRadioButton(
                isEnabled: onChanged != null,
                state: _OdinRadioButtonInternalState.from(
                  style: style,
                  states: states,
                  isSelected: value == selectedValue,
                ),
              ),
              OdinGap.xxs,
              Expanded(
                child: Text(
                  label,
                  style: theme.typography.bodyBase.copyWith(
                    color: style.labelColor.resolve(states),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class OdinRadioButtonCard<T> extends StatelessWidget {
  const OdinRadioButtonCard({
    required this.value,
    super.key,
    this.number,
    this.label,
    this.icon,
    this.selectedValue,
    this.onChanged,
  }) : assert(
         number != null || label != null,
         'At least one of `number` or `label` must be provided!',
       );

  final Widget? number;
  final Widget? label;
  final OdinIconContainer? icon;
  final T value;
  final T? selectedValue;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final style = theme.radioButtonTheme.radioButtonCardStyle;

    return _OdinRadioButtonActionHandler(
      value: value,
      selectedValue: selectedValue,
      onChanged: onChanged,
      style: style,
      builder: (context, states) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: style.backgroundColor.resolve(states),
            borderRadius: const BorderRadius.all(Radius.circular(OdinGapValue.xxxs)),
            border: style.border.resolve(states),
          ),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Padding(
              padding: style.padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      if (icon case final icon?) //
                        OdinIconContainerTheme(
                          data: theme.iconContainerTheme.copyWith(
                            backgroundColor: theme.appColorScheme.onColorEmphasisHigh,
                            size: OdinIconContainerSize.size32,
                          ),
                          child: icon,
                        ),
                      Align(
                        alignment: Alignment.topRight,
                        child: _OdinRadioButton(
                          isEnabled: onChanged != null,
                          state: _OdinRadioButtonInternalState.from(
                            style: style,
                            states: states,
                            isSelected: value == selectedValue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (number case final number?) //
                    DefaultTextStyle(
                      overflow: TextOverflow.ellipsis,
                      style: theme.typography.titleBase.copyWith(
                        color: style.labelColor.resolve(states),
                      ),
                      child: number,
                    ),
                  if (label case final label?) //
                    DefaultTextStyle(
                      overflow: TextOverflow.ellipsis,
                      style: theme.typography.bodySmall.copyWith(
                        color: style.labelColor.resolve(states),
                      ),
                      child: label,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class OdinRadioButtonBox<T> extends StatelessWidget {
  const OdinRadioButtonBox({
    required this.label,
    required this.value,
    super.key,
    this.selectedValue,
    this.paragraph,
    this.onChanged,
  });

  final String label;
  final String? paragraph;
  final T value;
  final T? selectedValue;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final style = theme.radioButtonTheme.radioButtonBoxStyle;

    return _OdinRadioButtonActionHandler(
      value: value,
      selectedValue: selectedValue,
      onChanged: onChanged,
      style: style,
      builder: (context, states) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: style.backgroundColor.resolve(states),
            borderRadius: BorderRadius.all(style.borderRadius),
            border: style.border.resolve(states),
          ),
          child: Padding(
            padding: style.padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.typography.bodyBase.copyWith(
                          color: style.labelColor.resolve(states),
                        ),
                      ),
                      if (paragraph case final paragraph?) //
                        Padding(
                          padding: const EdgeInsets.only(top: OdinPaddingValue.xxxs),
                          child: Text(
                            paragraph,
                            style: theme.typography.bodySmall.copyWith(
                              color: style.labelColor.resolve(states),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                OdinGap.xxs,
                _OdinRadioButton(
                  isEnabled: onChanged != null,
                  state: _OdinRadioButtonInternalState.from(
                    style: style,
                    states: states,
                    isSelected: value == selectedValue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

typedef _OdinRadioButtonBuilder = Widget Function(BuildContext context, Set<WidgetState> states);

class _OdinRadioButtonActionHandler<T> extends StatefulWidget {
  const _OdinRadioButtonActionHandler({
    required this.builder,
    required this.value,
    required this.style,
    this.shouldUseOutsideInkResponse = false,
    this.selectedValue,
    this.onChanged,
  });

  final _OdinRadioButtonBuilder builder;
  final T value;
  final T? selectedValue;
  final bool shouldUseOutsideInkResponse;
  final ValueChanged<T?>? onChanged;
  final OdinRadioButtonStyle style;

  @override
  State<_OdinRadioButtonActionHandler<T>> createState() => _OdinRadioButtonActionHandlerState();
}

class _OdinRadioButtonActionHandlerState<T> extends State<_OdinRadioButtonActionHandler<T>> {
  late bool _isSelected = widget.value == widget.selectedValue;
  late bool _isEnabled = widget.onChanged != null;
  bool _isPressed = false;

  @override
  void didUpdateWidget(_OdinRadioButtonActionHandler<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final isSelected = widget.value == widget.selectedValue;
    final isEnabled = widget.onChanged != null;

    if (_isSelected != isSelected || _isEnabled != isEnabled) {
      setState(() {
        _isSelected = isSelected;
        _isEnabled = isEnabled;
        if (!isEnabled) {
          _isPressed = false;
        }
      });
    }
  }

  void _onUpdatePressed({required bool value}) {
    if (_isEnabled && (_isPressed != value)) {
      setState(() => _isPressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final states = <WidgetState>{
      if (_isSelected) WidgetState.selected,
      if (_isPressed) WidgetState.pressed,
      if (!_isEnabled) WidgetState.disabled,
    };

    if (widget.shouldUseOutsideInkResponse) {
      return OdinInkWell.outsideResponse(
        verticalSplashOverflow: 0.0,
        borderRadius: BorderRadius.all(widget.style.borderRadius),
        onTapDown: _isEnabled ? (details) => _onUpdatePressed(value: true) : null,
        onTapUp: _isEnabled ? (details) => _onUpdatePressed(value: false) : null,
        onTapCancel: _isEnabled ? () => _onUpdatePressed(value: false) : null,
        onTap: _isEnabled ? () => widget.onChanged?.call(widget.value) : null,
        child: widget.builder(context, states),
      );
    } else {
      return OdinInkWell(
        borderRadius: BorderRadius.all(widget.style.borderRadius),
        onTapDown: _isEnabled ? (details) => _onUpdatePressed(value: true) : null,
        onTapUp: _isEnabled ? (details) => _onUpdatePressed(value: false) : null,
        onTapCancel: _isEnabled ? () => _onUpdatePressed(value: false) : null,
        onTap: _isEnabled ? () => widget.onChanged?.call(widget.value) : null,
        child: widget.builder(context, states),
      );
    }
  }
}

// Holds a radio button style while the animation is playing
@immutable
final class _OdinRadioButtonInternalState {
  const _OdinRadioButtonInternalState({
    required this.isSelected,
    required this.size,
    required this.innerRadius,
    required this.outerRadius,
    required this.radioColor,
    required this.backgroundColor,
    required this.border,
  });

  final bool isSelected;
  final Size size;
  final double innerRadius;
  final double outerRadius;
  final Color radioColor;
  final Color backgroundColor;
  final Border border;

  static _OdinRadioButtonInternalState from({
    required OdinRadioButtonStyle style,
    required Set<WidgetState> states,
    required bool isSelected,
  }) {
    return _OdinRadioButtonInternalState(
      isSelected: isSelected,
      size: style.radioSize,
      innerRadius: style.innerRadius,
      outerRadius: style.outerRadius,
      radioColor: style.radioColor.resolve(states),
      backgroundColor: style.radioBackgroundColor.resolve(states),
      border: style.radioBorder.resolve(states),
    );
  }

  static _OdinRadioButtonInternalState lerp(
    _OdinRadioButtonInternalState a,
    _OdinRadioButtonInternalState b,
    double t,
  ) {
    return _OdinRadioButtonInternalState(
      isSelected: t < 0.5 ? a.isSelected : b.isSelected,
      size: t < 0.5 ? a.size : b.size,
      innerRadius: lerpDouble(a.innerRadius, b.innerRadius, t),
      outerRadius: lerpDouble(a.outerRadius, b.outerRadius, t),
      radioColor: Color.lerp(a.radioColor, b.radioColor, t)!,
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      border: Border.lerp(a.border, b.border, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _OdinRadioButtonInternalState && //
        isSelected == other.isSelected &&
        size == other.size &&
        innerRadius == other.innerRadius &&
        outerRadius == other.outerRadius &&
        radioColor == other.radioColor &&
        backgroundColor == other.backgroundColor &&
        border == other.border;
  }

  @override
  int get hashCode {
    return Object.hash(
      isSelected,
      size,
      innerRadius,
      outerRadius,
      radioColor,
      backgroundColor,
      border,
    );
  }
}

class _OdinRadioButton extends StatefulWidget {
  const _OdinRadioButton({
    required this.state,
    required this.isEnabled,
  });

  final _OdinRadioButtonInternalState state;
  final bool isEnabled;

  @override
  State<_OdinRadioButton> createState() => __OdinRadioButtonState();
}

class __OdinRadioButtonState extends State<_OdinRadioButton> with SingleTickerProviderStateMixin {
  late final AnimationController _toggleController;
  late final CurvedAnimation _toggleAnimation;
  late _OdinRadioButtonInternalState _previousState;

  @override
  void initState() {
    super.initState();

    _toggleController = AnimationController(
      vsync: this,
      duration: _kToggleDuration,
      value: widget.state.isSelected ? 1.0 : 0.0,
    );

    _toggleAnimation = CurvedAnimation(
      parent: _toggleController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );

    _previousState = widget.state;
  }

  @override
  void didUpdateWidget(_OdinRadioButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    _previousState = oldWidget.state;

    if (oldWidget.state != widget.state) {
      _toggleController.value = 0.0;
      _toggleController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _toggleAnimation,
      builder: (context, child) {
        final state = _OdinRadioButtonInternalState.lerp(
          _previousState,
          widget.state,
          _toggleAnimation.value,
        );

        return CustomPaint(
          size: state.size,
          painter: _RadioButtonPainter(
            innerRadius: state.innerRadius,
            outerRadius: state.outerRadius,
            border: state.border,
            radioColor: state.radioColor,
            backgroundColor: state.backgroundColor,
          ),
        );
      },
    );
  }
}

class _RadioButtonPainter extends CustomPainter {
  _RadioButtonPainter({
    required this.innerRadius,
    required this.outerRadius,
    required this.radioColor,
    required this.backgroundColor,
    required this.border,
  });

  final double innerRadius;
  final double outerRadius;
  final Color radioColor;
  final Color backgroundColor;
  final Border border;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;

    // Background
    canvas.drawCircle(
      center,
      outerRadius,
      Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.fill,
    );

    if (border.top.color case final borderColor when border.top.style == BorderStyle.solid) {
      // Outer circle
      canvas.drawCircle(
        center,
        outerRadius,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );
    }

    // Inner circle
    canvas.drawCircle(
      center,
      innerRadius,
      Paint()
        ..color = radioColor
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _RadioButtonPainter oldDelegate) {
    return oldDelegate.innerRadius != innerRadius || //
        oldDelegate.outerRadius != outerRadius ||
        oldDelegate.radioColor != radioColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.border != border;
  }
}

final class OdinRadioButtonTheme extends InheritedTheme {
  const OdinRadioButtonTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinRadioButtonThemeData data;

  static OdinRadioButtonThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinRadioButtonTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).radioButtonTheme;
  }

  @override
  bool updateShouldNotify(OdinRadioButtonTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinRadioButtonTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinRadioButtonThemeData {
  OdinRadioButtonThemeData({
    required this.radioButtonStyle,
    required this.radioButtonCardStyle,
    required this.radioButtonBoxStyle,
  });

  final OdinRadioButtonStyle radioButtonStyle;
  final OdinRadioButtonStyle radioButtonCardStyle;
  final OdinRadioButtonStyle radioButtonBoxStyle;

  static OdinRadioButtonThemeData lerp(
    OdinRadioButtonThemeData a,
    OdinRadioButtonThemeData b,
    double t,
  ) {
    return OdinRadioButtonThemeData(
      radioButtonStyle: OdinRadioButtonStyle.lerp(a.radioButtonStyle, b.radioButtonStyle, t),
      radioButtonCardStyle: OdinRadioButtonStyle.lerp(
        a.radioButtonCardStyle,
        b.radioButtonCardStyle,
        t,
      ),
      radioButtonBoxStyle: OdinRadioButtonStyle.lerp(
        a.radioButtonBoxStyle,
        b.radioButtonBoxStyle,
        t,
      ),
    );
  }

  OdinRadioButtonThemeData copyWith({
    OdinRadioButtonStyle? radioButtonStyle,
    OdinRadioButtonStyle? radioButtonCardStyle,
    OdinRadioButtonStyle? radioButtonBoxStyle,
  }) {
    return OdinRadioButtonThemeData(
      radioButtonStyle: radioButtonStyle ?? this.radioButtonStyle,
      radioButtonCardStyle: radioButtonCardStyle ?? this.radioButtonCardStyle,
      radioButtonBoxStyle: radioButtonBoxStyle ?? this.radioButtonBoxStyle,
    );
  }

  OdinRadioButtonThemeData copyAllStylesWith({
    Size? radioSize,
    double? innerRadius,
    double? outerRadius,
    WidgetStateProperty<Color>? radioColor,
    WidgetStateProperty<Color>? backgroundColor,
    WidgetStateProperty<Color>? labelColor,
    Radius? borderRadius,
    EdgeInsets? padding,
    WidgetStateProperty<Color>? radioBackgroundColor,
    WidgetStateProperty<Border>? border,
    WidgetStateProperty<Border>? radioBorder,
  }) {
    return OdinRadioButtonThemeData(
      radioButtonStyle: radioButtonStyle.copyWith(
        radioSize: radioSize ?? radioButtonStyle.radioSize,
        innerRadius: innerRadius ?? radioButtonStyle.innerRadius,
        outerRadius: outerRadius ?? radioButtonStyle.outerRadius,
        radioColor: radioColor ?? radioButtonStyle.radioColor,
        backgroundColor: backgroundColor ?? radioButtonStyle.backgroundColor,
        labelColor: labelColor ?? radioButtonStyle.labelColor,
        borderRadius: borderRadius ?? radioButtonStyle.borderRadius,
        padding: padding ?? radioButtonStyle.padding,
        radioBackgroundColor: radioBackgroundColor ?? radioButtonStyle.radioBackgroundColor,
        border: border ?? radioButtonStyle.border,
        radioBorder: radioBorder ?? radioButtonStyle.radioBorder,
      ),
      radioButtonCardStyle: radioButtonCardStyle.copyWith(
        radioSize: radioSize ?? radioButtonCardStyle.radioSize,
        innerRadius: innerRadius ?? radioButtonCardStyle.innerRadius,
        outerRadius: outerRadius ?? radioButtonCardStyle.outerRadius,
        radioColor: radioColor ?? radioButtonCardStyle.radioColor,
        backgroundColor: backgroundColor ?? radioButtonCardStyle.backgroundColor,
        labelColor: labelColor ?? radioButtonCardStyle.labelColor,
        borderRadius: borderRadius ?? radioButtonCardStyle.borderRadius,
        padding: padding ?? radioButtonCardStyle.padding,
        radioBackgroundColor: radioBackgroundColor ?? radioButtonCardStyle.radioBackgroundColor,
        border: border ?? radioButtonCardStyle.border,
        radioBorder: radioBorder ?? radioButtonCardStyle.radioBorder,
      ),
      radioButtonBoxStyle: radioButtonBoxStyle.copyWith(
        radioSize: radioSize ?? radioButtonBoxStyle.radioSize,
        innerRadius: innerRadius ?? radioButtonBoxStyle.innerRadius,
        outerRadius: outerRadius ?? radioButtonBoxStyle.outerRadius,
        radioColor: radioColor ?? radioButtonBoxStyle.radioColor,
        backgroundColor: backgroundColor ?? radioButtonBoxStyle.backgroundColor,
        labelColor: labelColor ?? radioButtonBoxStyle.labelColor,
        borderRadius: borderRadius ?? radioButtonBoxStyle.borderRadius,
        padding: padding ?? radioButtonBoxStyle.padding,
        radioBackgroundColor: radioBackgroundColor ?? radioButtonBoxStyle.radioBackgroundColor,
        border: border ?? radioButtonBoxStyle.border,
        radioBorder: radioBorder ?? radioButtonBoxStyle.radioBorder,
      ),
    );
  }
}

final class OdinRadioButtonStyle {
  const OdinRadioButtonStyle({
    required this.radioSize,
    required this.innerRadius,
    required this.outerRadius,
    required this.radioColor,
    required this.backgroundColor,
    required this.labelColor,
    required this.borderRadius,
    required this.padding,
    required this.radioBackgroundColor,
    required this.border,
    required this.radioBorder,
  });

  final Size radioSize;
  final double innerRadius;
  final double outerRadius;
  final Radius borderRadius;
  final EdgeInsets padding;
  final WidgetStateProperty<Color> radioColor;
  final WidgetStateProperty<Color> backgroundColor;
  final WidgetStateProperty<Color> radioBackgroundColor;
  final WidgetStateProperty<Border> border;
  final WidgetStateProperty<Border> radioBorder;
  final WidgetStateProperty<Color> labelColor;

  static OdinRadioButtonStyle lerp(OdinRadioButtonStyle a, OdinRadioButtonStyle b, double t) {
    return OdinRadioButtonStyle(
      radioSize: Size.lerp(a.radioSize, b.radioSize, t)!,
      innerRadius: lerpDouble(a.innerRadius, b.innerRadius, t),
      outerRadius: lerpDouble(a.outerRadius, b.outerRadius, t),
      radioColor: WidgetStateProperty.lerp(a.radioColor, b.radioColor, t, Color.lerp)! as WidgetStateProperty<Color>,
      backgroundColor: WidgetStateProperty.lerp(a.backgroundColor, b.backgroundColor, t, Color.lerp)! as WidgetStateProperty<Color>,
      labelColor: WidgetStateProperty.lerp(a.labelColor, b.labelColor, t, Color.lerp)! as WidgetStateProperty<Color>,
      borderRadius: Radius.lerp(a.borderRadius, b.borderRadius, t)!,
      padding: EdgeInsets.lerp(a.padding, b.padding, t)!,
      radioBackgroundColor: WidgetStateProperty.lerp(a.radioBackgroundColor, b.radioBackgroundColor, t, Color.lerp)! as WidgetStateProperty<Color>,
      border: WidgetStateProperty.lerp(a.border, b.border, t, Border.lerp)! as WidgetStateProperty<Border>,
      radioBorder: WidgetStateProperty.lerp(a.radioBorder, b.radioBorder, t, Border.lerp)! as WidgetStateProperty<Border>,
    );
  }

  OdinRadioButtonStyle copyWith({
    Size? radioSize,
    double? innerRadius,
    double? outerRadius,
    WidgetStateProperty<Color>? radioColor,
    WidgetStateProperty<Color>? backgroundColor,
    WidgetStateProperty<Color>? labelColor,
    Radius? borderRadius,
    EdgeInsets? padding,
    WidgetStateProperty<Color>? radioBackgroundColor,
    WidgetStateProperty<Border>? border,
    WidgetStateProperty<Border>? radioBorder,
  }) {
    return OdinRadioButtonStyle(
      radioSize: radioSize ?? this.radioSize,
      innerRadius: innerRadius ?? this.innerRadius,
      outerRadius: outerRadius ?? this.outerRadius,
      radioColor: radioColor ?? this.radioColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      labelColor: labelColor ?? this.labelColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      radioBackgroundColor: radioBackgroundColor ?? this.radioBackgroundColor,
      border: border ?? this.border,
      radioBorder: radioBorder ?? this.radioBorder,
    );
  }
}

OdinRadioButtonThemeData createDefaultRadioButtonTheme({
  required OdinColorScheme colorScheme,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  final radioButtonStyle = OdinRadioButtonStyle(
    radioSize: const Size.square(24.0),
    borderRadius: const Radius.circular(OdinGapValue.xxxs),
    padding: const EdgeInsets.all(OdinPaddingValue.xxs),
    backgroundColor: generateState(kTransparentColor),
    radioBackgroundColor: generateState(
      kTransparentColor,
      pressed: kTransparentColor,
      selected: kTransparentColor,
      disabledAndSelected: colorScheme.actionDisabledBase,
      disabled: colorScheme.actionDisabledBase,
    ),
    border: generateState(const Border()),
    radioBorder: generateState(
      Border.all(color: colorScheme.actionSecondaryEnabled),
      pressed: Border.all(color: colorScheme.actionSecondaryEnabled),
      selected: Border.all(color: colorScheme.actionSecondarySelected),
      disabledAndSelected: const Border(),
      disabled: Border.all(color: colorScheme.outlineBase),
    ),
    radioColor: generateState(
      kTransparentColor,
      pressed: kTransparentColor,
      selected: colorScheme.actionSecondarySelected,
      pressedAndSelected: colorScheme.actionSecondarySelected,
      disabledAndSelected: colorScheme.onColorEmphasisDisabled,
      disabled: kTransparentColor,
    ),
    labelColor: generateState(
      colorScheme.onColorEmphasisHigh,
      pressed: colorScheme.onColorEmphasisHigh,
      selected: colorScheme.onColorEmphasisHigh,
      disabledAndSelected: colorScheme.onColorEmphasisDisabled,
      disabled: colorScheme.onColorEmphasisDisabled,
    ),
    innerRadius: 4.0,
    outerRadius: 12.0,
  );

  final radioButtonCardStyle = radioButtonStyle.copyWith(
    padding: const EdgeInsets.all(OdinPaddingValue.sm),
    backgroundColor: generateState(
      colorScheme.actionNeutralEnabled,
      // We apply a little transparency so that the splash can appear
      pressed: colorScheme.actionNeutralPressed.withValues(alpha: 0.5),
      selected: colorScheme.actionNeutralEnabled,
      disabledAndSelected: colorScheme.actionDisabledBase,
      disabled: colorScheme.actionDisabledBase,
    ),
    border: generateState(
      Border.all(color: colorScheme.outlineBase),
      pressed: Border.all(color: colorScheme.outlineBase),
      selected: Border.all(color: colorScheme.actionMainSelected, width: 2.0),
      pressedAndSelected: Border.all(color: colorScheme.actionMainSelected, width: 2.0),
      disabledAndSelected: Border.all(color: colorScheme.outlineBase),
      disabled: Border.all(color: colorScheme.outlineBase),
    ),
    labelColor: generateState(
      colorScheme.onColorEmphasisHigh,
      pressed: colorScheme.onColorEmphasisHigh,
      selected: colorScheme.onColorEmphasisHigh,
      disabledAndSelected: colorScheme.onColorEmphasisDisabled,
      disabled: colorScheme.onColorEmphasisDisabled,
    ),
  );

  final radioButtonBoxStyle = radioButtonStyle.copyWith(
    padding: const EdgeInsets.symmetric(
      horizontal: OdinPaddingValue.sm,
      vertical: OdinPaddingValue.xs,
    ),
    backgroundColor: generateState(
      colorScheme.actionNeutralEnabled,
      // We apply a little transparency so that the splash can appear
      pressed: colorScheme.actionNeutralPressed.withValues(alpha: 0.5),
      selected: colorScheme.actionNeutralEnabled,
      disabledAndSelected: colorScheme.actionDisabledBase,
      disabled: colorScheme.actionDisabledBase,
    ),
    border: generateState(
      Border.all(color: colorScheme.outlineBase),
      pressed: Border.all(color: colorScheme.outlineBase),
      selected: Border.all(color: colorScheme.actionMainSelected, width: 2.0),
      pressedAndSelected: Border.all(color: colorScheme.actionMainSelected, width: 2.0),
      disabledAndSelected: const Border(),
      disabled: const Border(),
    ),
  );

  return OdinRadioButtonThemeData(
    radioButtonStyle: radioButtonStyle,
    radioButtonCardStyle: radioButtonCardStyle,
    radioButtonBoxStyle: radioButtonBoxStyle,
  );
}
