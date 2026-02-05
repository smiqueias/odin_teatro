import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

const _kToggleDuration = Duration(milliseconds: 150);

enum OdinCheckboxPosition {
  left,
  right,
}

class OdinCheckbox extends StatelessWidget {
  const OdinCheckbox({
    required this.selection,
    super.key,
    this.isTristate = false,
    this.autofocus = false,
    this.focusNode,
    this.mouseCursor,
    this.onChanged,
  }) : assert(
         isTristate || selection != OdinToggleableSelection.indeterminate,
         "The selection can't be [OdinToggleableSelection.indeterminate] when [isTristate] is false",
       );

  final OdinToggleableSelection selection;
  final bool isTristate;
  final bool autofocus;
  final FocusNode? focusNode;
  final MouseCursor? mouseCursor;
  final ValueChanged<OdinToggleableSelection>? onChanged;

  @override
  Widget build(BuildContext context) {
    final style = OdinCheckboxTheme.of(context).checkboxStyle;

    return _OdinCheckboxActionHandler(
      selection: selection,
      isTristate: isTristate,
      onChanged: onChanged,
      style: style,
      builder: (context, states) {
        return Padding(
          padding: style.padding,
          child: _OdinCheckbox(
            isEnabled: onChanged != null,
            state: _OdinCheckboxInternalState.from(style, states, selection),
          ),
        );
      },
    );
  }
}

class OdinCheckboxLabel extends StatelessWidget {
  const OdinCheckboxLabel({
    required this.label,
    required this.selection,
    super.key,
    this.position = OdinCheckboxPosition.right,
    this.isTristate = false,
    this.onChanged,
  }) : assert(
         isTristate || selection != OdinToggleableSelection.indeterminate,
         "The selection can't be [OdinToggleableSelection.indeterminate] when [isTristate] is false",
       );

  final String label;
  final OdinToggleableSelection selection;
  final OdinCheckboxPosition position;
  final bool isTristate;
  final ValueChanged<OdinToggleableSelection>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final style = theme.checkboxTheme.checkboxStyle;

    return _OdinCheckboxActionHandler(
      selection: selection,
      isTristate: isTristate,
      style: style,
      onChanged: onChanged,
      shouldUseOutsideInkResponse: true,
      builder: (context, states) {
        return Padding(
          padding: EdgeInsets.only(top: style.padding.top, bottom: style.padding.bottom),
          child: Row(
            textDirection: position == OdinCheckboxPosition.left
                ? (TextDirection.ltr) //
                : TextDirection.rtl,
            children: [
              _OdinCheckbox(
                isEnabled: onChanged != null,
                state: _OdinCheckboxInternalState.from(style, states, selection),
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

class OdinCheckboxCard extends StatelessWidget {
  const OdinCheckboxCard({
    required this.selection,
    super.key,
    this.number,
    this.label,
    this.icon,
    this.onChanged,
  }) : assert(
         number != null || label != null,
         'At least one of `number` or `label` must be provided!',
       );

  final Widget? number;
  final Widget? label;
  final OdinIconContainer? icon;
  final OdinToggleableSelection selection;
  final ValueChanged<OdinToggleableSelection>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final style = theme.checkboxTheme.checkboxCardStyle;

    return _OdinCheckboxActionHandler(
      selection: selection,
      isTristate: false,
      onChanged: onChanged,
      style: style,
      builder: (context, states) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: style.backgroundColor.resolve(states),
            borderRadius: BorderRadius.all(style.borderRadius),
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
                            foregroundColor: style.labelColor.resolve(states),
                            backgroundColor: theme.appColorScheme.onColorEmphasisHigh,
                            size: OdinIconContainerSize.size32,
                          ),
                          child: icon,
                        ),
                      Align(
                        alignment: Alignment.topRight,
                        child: _OdinCheckbox(
                          isEnabled: onChanged != null,
                          state: _OdinCheckboxInternalState.from(style, states, selection),
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

class OdinCheckboxBox extends StatelessWidget {
  const OdinCheckboxBox({
    required this.label,
    required this.selection,
    super.key,
    this.paragraph,
    this.onChanged,
  });

  final String label;
  final String? paragraph;
  final OdinToggleableSelection selection;
  final ValueChanged<OdinToggleableSelection>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final style = theme.checkboxTheme.checkboxBoxStyle;

    return _OdinCheckboxActionHandler(
      selection: selection,
      isTristate: false,
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
                    mainAxisSize: MainAxisSize.min,
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
                _OdinCheckbox(
                  isEnabled: onChanged != null,
                  state: _OdinCheckboxInternalState.from(style, states, selection),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

typedef _OdinCheckboxBuilder = Widget Function(BuildContext context, Set<WidgetState> states);

class _OdinCheckboxActionHandler extends StatefulWidget {
  const _OdinCheckboxActionHandler({
    required this.builder,
    required this.selection,
    required this.isTristate,
    required this.style,
    this.shouldUseOutsideInkResponse = false,
    this.onChanged,
  });

  final _OdinCheckboxBuilder builder;
  final OdinToggleableSelection selection;
  final bool isTristate;
  final bool shouldUseOutsideInkResponse;
  final ValueChanged<OdinToggleableSelection>? onChanged;
  final OdinCheckboxStyle style;

  @override
  State<_OdinCheckboxActionHandler> createState() => _OdinCheckboxActionHandlerState();
}

class _OdinCheckboxActionHandlerState extends State<_OdinCheckboxActionHandler> {
  late bool _isEnabled = widget.onChanged != null;
  bool _isPressed = false;
  late OdinToggleableSelection _selection;

  @override
  void initState() {
    super.initState();

    _selection = widget.selection;
  }

  @override
  void didUpdateWidget(_OdinCheckboxActionHandler oldWidget) {
    super.didUpdateWidget(oldWidget);

    final isEnabled = widget.onChanged != null;
    if (_isEnabled != isEnabled) {
      setState(() {
        _isEnabled = isEnabled;
        if (!isEnabled) {
          _isPressed = false;
        }
      });
    }

    if (oldWidget.selection != widget.selection) {
      setState(() {
        _selection = widget.selection;
      });
    }
  }

  void _onUpdatePressed({required bool value}) {
    if (_isEnabled && (_isPressed != value)) {
      setState(() => _isPressed = value);
    }
  }

  OdinToggleableSelection _getNextSelection() {
    return switch (_selection) {
      OdinToggleableSelection.unselected => OdinToggleableSelection.selected,
      OdinToggleableSelection.selected =>
        widget.isTristate
            ? (OdinToggleableSelection.indeterminate) //
            : OdinToggleableSelection.unselected,
      OdinToggleableSelection.indeterminate => OdinToggleableSelection.unselected,
    };
  }

  @override
  Widget build(BuildContext context) {
    final states = <WidgetState>{
      if (_selection != OdinToggleableSelection.unselected) WidgetState.selected,
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
        onTap: _isEnabled ? () => widget.onChanged?.call(_getNextSelection()) : null,
        child: widget.builder(context, states),
      );
    } else {
      return OdinInkWell(
        borderRadius: BorderRadius.all(widget.style.borderRadius),
        onTapDown: _isEnabled ? (details) => _onUpdatePressed(value: true) : null,
        onTapUp: _isEnabled ? (details) => _onUpdatePressed(value: false) : null,
        onTapCancel: _isEnabled ? () => _onUpdatePressed(value: false) : null,
        onTap: _isEnabled ? () => widget.onChanged?.call(_getNextSelection()) : null,
        child: widget.builder(context, states),
      );
    }
  }
}

// Holds a checkbox style while the animation is playing
@immutable
final class _OdinCheckboxInternalState {
  const _OdinCheckboxInternalState({
    required this.selection,
    required this.size,
    required this.color,
    required this.backgroundColor,
    required this.border,
    required this.borderRadius,
  });

  final OdinToggleableSelection selection;
  final Size size;
  final Color color;
  final Color backgroundColor;
  final Border border;
  final Radius borderRadius;

  static _OdinCheckboxInternalState from(
    OdinCheckboxStyle style,
    Set<WidgetState> states,
    OdinToggleableSelection selection,
  ) {
    return _OdinCheckboxInternalState(
      selection: selection,
      size: style.checkboxSize,
      color: style.checkColor.resolve(states),
      backgroundColor: style.checkboxBackgroundColor.resolve(states),
      border: style.checkboxBorder.resolve(states),
      borderRadius: style.borderRadius,
    );
  }
}

class _OdinCheckbox extends StatefulWidget {
  const _OdinCheckbox({
    required this.state,
    required this.isEnabled,
  });

  final _OdinCheckboxInternalState state;
  final bool isEnabled;

  @override
  State<_OdinCheckbox> createState() => __OdinCheckboxState();
}

class __OdinCheckboxState extends State<_OdinCheckbox> with SingleTickerProviderStateMixin {
  late final AnimationController _toggleController;
  late final CurvedAnimation _toggleAnimation;

  late _OdinCheckboxInternalState _currentState;

  @override
  void initState() {
    super.initState();

    _currentState = widget.state;

    _toggleController = AnimationController(
      vsync: this,
      duration: _kToggleDuration,
      value: widget.state.selection == OdinToggleableSelection.selected ? 1.0 : 0.0,
    );

    _toggleAnimation = CurvedAnimation(
      parent: _toggleController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(_OdinCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.state != widget.state) {
      setState(() => _currentState = widget.state);

      if (oldWidget.state.selection != widget.state.selection) {
        switch (widget.state.selection) {
          case OdinToggleableSelection.unselected:
            unawaited(_toggleController.reverse());
          case OdinToggleableSelection.selected:
            unawaited(_toggleController.forward());
          case OdinToggleableSelection.indeterminate:
            _toggleController.value = 0.0;
            unawaited(_toggleController.forward());
        }
      }
    }
  }

  @override
  void dispose() {
    _toggleController.dispose();
    _toggleAnimation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: _currentState.size,
      painter: _CheckboxPainter(
        animation: _toggleAnimation,
        selection: _currentState.selection,
        color: _currentState.color,
        backgroundColor: _currentState.backgroundColor,
        border: _currentState.border,
        borderRadius: _currentState.borderRadius,
        strokeWidth: 1.5,
        padding: OdinGapValue.xxxs,
      ),
    );
  }
}

class _CheckboxPainter extends CustomPainter {
  _CheckboxPainter({
    required this.animation,
    required this.selection,
    required this.color,
    required this.backgroundColor,
    required this.border,
    required this.borderRadius,
    required this.strokeWidth,
    required this.padding,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final OdinToggleableSelection selection;
  final Color color;
  final Color backgroundColor;
  final Border border;
  final Radius borderRadius;
  final double strokeWidth;
  final double padding;

  void _drawAnimatedIcon(Canvas canvas, Size size, Offset offset) {
    final interpolation = animation.value;
    assert(0 <= interpolation && interpolation <= 1.0);

    // Avoid drawing the check icon when the interpolation is 0.0
    if (interpolation == 0) {
      return;
    }

    final centeredOffset = offset + Offset(padding, padding);
    final checkSizeWithoutPadding = Size(size.width - padding * 2, size.height - padding * 2);

    if (selection == OdinToggleableSelection.selected) {
      // Draw check
      final checkSizeWithoutPadding = Size(size.width - padding * 2, size.height - padding * 2);
      final startPoint = Offset(
        checkSizeWithoutPadding.width * 0.08,
        checkSizeWithoutPadding.height * 0.50,
      );
      final middlePoint = Offset(
        checkSizeWithoutPadding.width * 0.40,
        checkSizeWithoutPadding.height * 0.8,
      );
      final endPoint = Offset(
        checkSizeWithoutPadding.width * 0.92,
        checkSizeWithoutPadding.height * 0.2,
      );

      final path = Path();

      if (interpolation < 0.5) {
        final interpolatedStroke = interpolation * 2.0;
        final interpolatedMiddlePoint = Offset.lerp(startPoint, middlePoint, interpolatedStroke)!;

        path.moveTo(centeredOffset.dx + startPoint.dx, centeredOffset.dy + startPoint.dy);
        path.lineTo(
          centeredOffset.dx + interpolatedMiddlePoint.dx,
          centeredOffset.dy + interpolatedMiddlePoint.dy,
        );
      } else {
        final interpolatedStroke = (interpolation - 0.5) * 2.0;
        final interpolatedEndPoint = Offset.lerp(middlePoint, endPoint, interpolatedStroke)!;

        path.moveTo(centeredOffset.dx + startPoint.dx, centeredOffset.dy + startPoint.dy);
        path.lineTo(centeredOffset.dx + middlePoint.dx, centeredOffset.dy + middlePoint.dy);
        path.lineTo(
          centeredOffset.dx + interpolatedEndPoint.dx,
          centeredOffset.dy + interpolatedEndPoint.dy,
        );
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
    } else if (selection == OdinToggleableSelection.indeterminate) {
      // Draw dash
      final startPoint = Offset(
        checkSizeWithoutPadding.width * 0.2,
        checkSizeWithoutPadding.height * 0.5,
      );
      final middlePoint = Offset(
        checkSizeWithoutPadding.width * 0.5,
        checkSizeWithoutPadding.height * 0.5,
      );
      final endPoint = Offset(
        checkSizeWithoutPadding.width * 0.8,
        checkSizeWithoutPadding.height * 0.5,
      );
      final interpolatedStartPoint = Offset.lerp(startPoint, middlePoint, 1.0 - interpolation)!;
      final interpolatedEndPoint = Offset.lerp(middlePoint, endPoint, interpolation)!;

      canvas.drawLine(
        centeredOffset + interpolatedStartPoint,
        centeredOffset + interpolatedEndPoint,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final checkRect = RRect.fromRectAndRadius(Offset.zero & size, borderRadius);
    canvas.drawRRect(checkRect, Paint()..color = backgroundColor);

    if (border.top.color case final borderColor when border.top.style == BorderStyle.solid) {
      canvas.drawRRect(
        checkRect,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = border.top.width,
      );
    }

    _drawAnimatedIcon(canvas, size, Offset.zero);
  }

  @override
  bool shouldRepaint(covariant _CheckboxPainter oldDelegate) {
    return oldDelegate.animation != animation || //
        oldDelegate.selection != selection ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.border != border ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.padding != padding;
  }
}

final class OdinCheckboxTheme extends InheritedTheme {
  const OdinCheckboxTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinCheckboxThemeData data;

  static OdinCheckboxThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinCheckboxTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).checkboxTheme;
  }

  @override
  bool updateShouldNotify(OdinCheckboxTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinCheckboxTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinCheckboxThemeData {
  OdinCheckboxThemeData({
    required this.checkboxStyle,
    required this.checkboxCardStyle,
    required this.checkboxBoxStyle,
  });

  final OdinCheckboxStyle checkboxStyle;
  final OdinCheckboxStyle checkboxCardStyle;
  final OdinCheckboxStyle checkboxBoxStyle;

  static OdinCheckboxThemeData lerp(OdinCheckboxThemeData a, OdinCheckboxThemeData b, double t) {
    return OdinCheckboxThemeData(
      checkboxStyle: OdinCheckboxStyle.lerp(a.checkboxStyle, b.checkboxStyle, t),
      checkboxCardStyle: OdinCheckboxStyle.lerp(a.checkboxCardStyle, b.checkboxCardStyle, t),
      checkboxBoxStyle: OdinCheckboxStyle.lerp(a.checkboxBoxStyle, b.checkboxBoxStyle, t),
    );
  }

  OdinCheckboxThemeData copyWith({
    OdinCheckboxStyle? checkboxStyle,
    OdinCheckboxStyle? checkboxCardStyle,
    OdinCheckboxStyle? checkboxBoxStyle,
  }) {
    return OdinCheckboxThemeData(
      checkboxStyle: checkboxStyle ?? this.checkboxStyle,
      checkboxCardStyle: checkboxCardStyle ?? this.checkboxCardStyle,
      checkboxBoxStyle: checkboxBoxStyle ?? this.checkboxBoxStyle,
    );
  }

  OdinCheckboxThemeData copyAllStylesWith({
    Size? checkboxSize,
    Radius? borderRadius,
    EdgeInsets? padding,
    WidgetStateProperty<Color>? backgroundColor,
    WidgetStateProperty<Color>? checkboxBackgroundColor,
    WidgetStateProperty<Border>? border,
    WidgetStateProperty<Border>? checkboxBorder,
    WidgetStateProperty<Color>? checkColor,
    WidgetStateProperty<Color>? labelColor,
  }) {
    return OdinCheckboxThemeData(
      checkboxStyle: checkboxStyle.copyWith(
        checkboxSize: checkboxSize ?? checkboxStyle.checkboxSize,
        borderRadius: borderRadius ?? checkboxStyle.borderRadius,
        padding: padding ?? checkboxStyle.padding,
        backgroundColor: backgroundColor ?? checkboxStyle.backgroundColor,
        checkboxBackgroundColor: checkboxBackgroundColor ?? checkboxStyle.checkboxBackgroundColor,
        border: border ?? checkboxStyle.border,
        checkboxBorder: checkboxBorder ?? checkboxStyle.checkboxBorder,
        checkColor: checkColor ?? checkboxStyle.checkColor,
        labelColor: labelColor ?? checkboxStyle.labelColor,
      ),
      checkboxCardStyle: checkboxCardStyle.copyWith(
        checkboxSize: checkboxSize ?? checkboxCardStyle.checkboxSize,
        borderRadius: borderRadius ?? checkboxCardStyle.borderRadius,
        padding: padding ?? checkboxCardStyle.padding,
        backgroundColor: backgroundColor ?? checkboxCardStyle.backgroundColor,
        checkboxBackgroundColor: checkboxBackgroundColor ?? checkboxCardStyle.checkboxBackgroundColor,
        border: border ?? checkboxCardStyle.border,
        checkboxBorder: checkboxBorder ?? checkboxCardStyle.checkboxBorder,
        checkColor: checkColor ?? checkboxCardStyle.checkColor,
        labelColor: labelColor ?? checkboxCardStyle.labelColor,
      ),
      checkboxBoxStyle: checkboxBoxStyle.copyWith(
        checkboxSize: checkboxSize ?? checkboxBoxStyle.checkboxSize,
        borderRadius: borderRadius ?? checkboxBoxStyle.borderRadius,
        padding: padding ?? checkboxBoxStyle.padding,
        backgroundColor: backgroundColor ?? checkboxBoxStyle.backgroundColor,
        checkboxBackgroundColor: checkboxBackgroundColor ?? checkboxBoxStyle.checkboxBackgroundColor,
        border: border ?? checkboxBoxStyle.border,
        checkboxBorder: checkboxBorder ?? checkboxBoxStyle.checkboxBorder,
        checkColor: checkColor ?? checkboxBoxStyle.checkColor,
        labelColor: labelColor ?? checkboxBoxStyle.labelColor,
      ),
    );
  }
}

final class OdinCheckboxStyle {
  const OdinCheckboxStyle({
    required this.checkboxSize,
    required this.borderRadius,
    required this.padding,
    required this.backgroundColor,
    required this.checkboxBackgroundColor,
    required this.border,
    required this.checkboxBorder,
    required this.checkColor,
    required this.labelColor,
  });

  final Size checkboxSize;
  final Radius borderRadius;
  final EdgeInsets padding;
  final WidgetStateProperty<Color> backgroundColor;
  final WidgetStateProperty<Color> checkboxBackgroundColor;
  final WidgetStateProperty<Border> border;
  final WidgetStateProperty<Border> checkboxBorder;
  final WidgetStateProperty<Color> checkColor;
  final WidgetStateProperty<Color> labelColor;

  static OdinCheckboxStyle lerp(OdinCheckboxStyle a, OdinCheckboxStyle b, double t) {
    return OdinCheckboxStyle(
      checkboxSize: Size.lerp(a.checkboxSize, b.checkboxSize, t)!,
      borderRadius: Radius.lerp(a.borderRadius, b.borderRadius, t)!,
      padding: EdgeInsets.lerp(a.padding, b.padding, t)!,
      backgroundColor: WidgetStateProperty.lerp(a.backgroundColor, b.backgroundColor, t, Color.lerp)! as WidgetStateProperty<Color>,
      checkboxBackgroundColor:
          WidgetStateProperty.lerp(
                a.checkboxBackgroundColor,
                b.checkboxBackgroundColor,
                t,
                Color.lerp,
              )!
              as WidgetStateProperty<Color>,
      border: WidgetStateProperty.lerp(a.border, b.border, t, Border.lerp)! as WidgetStateProperty<Border>,
      checkboxBorder: WidgetStateProperty.lerp(a.checkboxBorder, b.checkboxBorder, t, Border.lerp)! as WidgetStateProperty<Border>,
      checkColor: WidgetStateProperty.lerp(a.checkColor, b.checkColor, t, Color.lerp)! as WidgetStateProperty<Color>,
      labelColor: WidgetStateProperty.lerp(a.labelColor, b.labelColor, t, Color.lerp)! as WidgetStateProperty<Color>,
    );
  }

  OdinCheckboxStyle copyWith({
    Size? checkboxSize,
    Radius? borderRadius,
    EdgeInsets? padding,
    WidgetStateProperty<Color>? backgroundColor,
    WidgetStateProperty<Color>? checkboxBackgroundColor,
    WidgetStateProperty<Border>? border,
    WidgetStateProperty<Border>? checkboxBorder,
    WidgetStateProperty<Color>? checkColor,
    WidgetStateProperty<Color>? labelColor,
  }) {
    return OdinCheckboxStyle(
      checkboxSize: checkboxSize ?? this.checkboxSize,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      checkboxBackgroundColor: checkboxBackgroundColor ?? this.checkboxBackgroundColor,
      border: border ?? this.border,
      checkboxBorder: checkboxBorder ?? this.checkboxBorder,
      checkColor: checkColor ?? this.checkColor,
      labelColor: labelColor ?? this.labelColor,
    );
  }
}

OdinCheckboxThemeData createDefaultCheckboxTheme({
  required OdinColorScheme colorScheme,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  final checkboxStyle = OdinCheckboxStyle(
    checkboxSize: const Size.square(24.0),
    borderRadius: const Radius.circular(OdinGapValue.xxxs),
    padding: const EdgeInsets.all(OdinPaddingValue.xxs),
    backgroundColor: generateState(kTransparentColor),
    checkboxBackgroundColor: generateState(
      kTransparentColor,
      pressed: kTransparentColor,
      selected: colorScheme.actionSecondarySelected,
      pressedAndSelected: colorScheme.actionSecondarySelected,
      disabled: colorScheme.actionDisabledBase,
      disabledAndSelected: colorScheme.actionDisabledBase,
    ),
    border: generateState(const Border()),
    checkboxBorder: generateState(
      Border.all(color: colorScheme.actionSecondaryEnabled),
      pressed: Border.all(color: colorScheme.actionSecondaryEnabled),
      selected: const Border(),
      pressedAndSelected: const Border(),
      disabled: Border.all(color: colorScheme.outlineBase),
      disabledAndSelected: const Border(),
    ),
    checkColor: generateState(
      kTransparentColor,
      pressed: kTransparentColor,
      selected: colorScheme.onColorEmphasisHighInverse,
      pressedAndSelected: colorScheme.onColorEmphasisHighInverse,
      disabled: kTransparentColor,
      disabledAndSelected: colorScheme.onColorEmphasisDisabled,
    ),
    labelColor: generateState(
      colorScheme.onColorEmphasisHigh,
      pressed: colorScheme.onColorEmphasisHigh,
      selected: colorScheme.onColorEmphasisHigh,
      disabled: colorScheme.onColorEmphasisDisabled,
      disabledAndSelected: colorScheme.onColorEmphasisDisabled,
    ),
  );

  final checkboxCardStyle = checkboxStyle.copyWith(
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

  final checkboxBoxStyle = checkboxStyle.copyWith(
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

  return OdinCheckboxThemeData(
    checkboxStyle: checkboxStyle,
    checkboxCardStyle: checkboxCardStyle,
    checkboxBoxStyle: checkboxBoxStyle,
  );
}
