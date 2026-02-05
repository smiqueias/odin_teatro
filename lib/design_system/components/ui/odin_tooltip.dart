import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

enum OdinTooltipPosition {
  left,
  right,
  top,
  bottom,
}

enum OdinTooltipAlignment {
  start,
  center,
  end,
}

typedef TooltipWidgetBuilder = Widget Function(BuildContext context, VoidCallback onHide);

final class OdinTooltip extends StatefulWidget {
  const OdinTooltip({
    required this.position,
    required this.alignment,
    required this.child,
    required this.builder,
    super.key,
    this.isDismissible = true,
    this.displayDuration = const Duration(seconds: 3),
  }) : hasLockScreen = false;

  OdinTooltip.defaultContent({
    required this.position,
    required this.alignment,
    required this.child,
    required String label,
    super.key,
    this.isDismissible = true,
    this.displayDuration = const Duration(seconds: 3),
    String? caption,
  }) : builder = ((context, onHide) {
         return OdinTooltipDefaultContent(
           label: label,
           caption: caption,
         );
       }),
       hasLockScreen = false;

  OdinTooltip.coachmarkContent({
    required this.position,
    required this.alignment,
    required this.child,
    super.key,
    this.isDismissible = true,
    this.displayDuration,
    String? title,
    String? paragraph,
    OdinActionSettings<VoidCallback>? primaryActionSettings,
    OdinActionSettings<VoidCallback>? secondaryActionSettings,
  }) : builder = ((context, onHide) {
         return OdinCoachmark(
           title: title,
           paragraph: paragraph,
           primaryActionSettings: primaryActionSettings?.copyWith(
             onPress: () {
               onHide();
               primaryActionSettings.onPress?.call();
             },
           ),
           secondaryActionSettings: secondaryActionSettings?.copyWith(
             onPress: () {
               onHide();
               secondaryActionSettings.onPress?.call();
             },
           ),
         );
       }),
       hasLockScreen = true;

  final OdinTooltipPosition position;
  final OdinTooltipAlignment alignment;
  final Widget child;
  final TooltipWidgetBuilder builder;
  final bool isDismissible;
  final bool hasLockScreen;
  final Duration? displayDuration;

  @override
  State<OdinTooltip> createState() => _OdinTooltipState();
}

final class _OdinTooltipState extends State<OdinTooltip> with SingleTickerProviderStateMixin {
  OverlayEntry? _entry;
  Timer? _displayTimer;
  late final AnimationController _controller;
  late bool _isMouseConnected;

  @override
  void initState() {
    super.initState();

    _isMouseConnected = RendererBinding.instance.mouseTracker.mouseIsConnected;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 100),
      vsync: this,
    )..addStatusListener(_handleStatusChanged);

    // Listen to see when a mouse is added.
    RendererBinding.instance.mouseTracker.addListener(_handleMouseTrackerChange);
  }

  @override
  void deactivate() {
    hideTooltip();
    super.deactivate();
  }

  @override
  void dispose() {
    hideTooltip();
    RendererBinding.instance.mouseTracker.removeListener(_handleMouseTrackerChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      excludeFromSemantics: true,
      child: widget.child,
    );

    // Only check for hovering if there is a mouse connected.
    if (_isMouseConnected) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => showTooltip(),
        onExit: (event) => hideTooltip(),
        child: result,
      );
    } else {
      return result;
    }
  }

  void showTooltip() => _ensureTooltipVisible();

  TickerFuture hideTooltip() => _controller.reverse();

  /// Shows the tooltip if it is not already visible.
  ///
  /// Returns `false` when the tooltip was already visible or if the context has
  /// become null.
  bool _ensureTooltipVisible() {
    _displayTimer?.cancel();

    if (widget.displayDuration case final displayDuration?) {
      _displayTimer = Timer(
        displayDuration,
        () {
          if (_controller.status == AnimationStatus.dismissed || _controller.status == AnimationStatus.completed) {
            hideTooltip();
          }
        },
      );
    }

    if (_entry != null) {
      // It is already visible.
      _controller.forward();
      return false;
    } else {
      _createNewEntry();
      _controller.forward();
      return true;
    }
  }

  void _createNewEntry() {
    final overlayState = Overlay.of(
      context,
      debugRequiredFor: widget,
    );

    final box = context.findRenderObject()! as RenderBox;
    final targetOffset = box.localToGlobal(
      _getPositionOffset(box),
      ancestor: overlayState.context.findRenderObject(),
    );

    // It create this widget outside of the overlay entry's builder to prevent
    // updated values from happening to leak into the overlay when the overlay
    // rebuilds.
    final overlay = _OdinTooltipOverlay(
      position: widget.position,
      alignment: widget.alignment,
      builder: widget.builder,
      onHide: hideTooltip,
      animation: CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
      targetOffset: targetOffset,
      isDismissible: widget.isDismissible,
      hasLockScreen: widget.hasLockScreen,
    );

    final entry = _entry = OverlayEntry(
      builder: (context) => overlay,
    );

    overlayState.insert(entry);
  }

  Offset _getPositionOffset(RenderBox box) {
    return switch ((widget.position, widget.alignment)) {
      (OdinTooltipPosition.left, OdinTooltipAlignment.start) => box.size.topLeft(Offset.zero),
      (OdinTooltipPosition.left, OdinTooltipAlignment.center) => box.size.centerLeft(Offset.zero),
      (OdinTooltipPosition.left, OdinTooltipAlignment.end) => box.size.bottomLeft(Offset.zero),
      (OdinTooltipPosition.right, OdinTooltipAlignment.start) => box.size.topRight(Offset.zero),
      (OdinTooltipPosition.right, OdinTooltipAlignment.center) => box.size.centerRight(Offset.zero),
      (OdinTooltipPosition.right, OdinTooltipAlignment.end) => box.size.bottomRight(Offset.zero),
      (OdinTooltipPosition.top, OdinTooltipAlignment.start) => box.size.topLeft(Offset.zero),
      (OdinTooltipPosition.top, OdinTooltipAlignment.center) => box.size.topCenter(Offset.zero),
      (OdinTooltipPosition.top, OdinTooltipAlignment.end) => box.size.topRight(Offset.zero),
      (OdinTooltipPosition.bottom, OdinTooltipAlignment.start) => box.size.bottomLeft(Offset.zero),
      (OdinTooltipPosition.bottom, OdinTooltipAlignment.center) => box.size.bottomCenter(Offset.zero),
      (OdinTooltipPosition.bottom, OdinTooltipAlignment.end) => box.size.bottomRight(Offset.zero),
    };
  }

  void _handleMouseTrackerChange() {
    final isMouseConnected = RendererBinding.instance.mouseTracker.mouseIsConnected;
    if (mounted && isMouseConnected != _isMouseConnected) {
      setState(() => _isMouseConnected = isMouseConnected);
    }
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      _removeEntry();
    }
  }

  void _handleTap() {
    final tooltipCreated = _ensureTooltipVisible();
    if (tooltipCreated) {
      unawaited(
        Feedback.forLongPress(context),
      );
    }
  }

  void _removeEntry() {
    _entry?.remove();
    _entry = null;
  }
}

class OdinTooltipDefaultContent extends StatelessWidget {
  const OdinTooltipDefaultContent({
    required this.label,
    super.key,
    this.caption,
  });

  final String label;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);

    return Padding(
      padding: const EdgeInsets.all(OdinPaddingValue.xxs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (caption case final caption?) ...[
            Flexible(
              child: Text(
                caption,
                style: theme.typography.bodySmall.copyWith(
                  color: theme.appColorScheme.onColorEmphasisHigh,
                ),
              ),
            ),
            OdinGap.xxxs,
          ],
          Flexible(
            child: Text(
              label,
              style: theme.typography.labelTiny.copyWith(
                color: theme.appColorScheme.onColorEmphasisHigh,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _OdinTooltipOverlay extends StatelessWidget {
  const _OdinTooltipOverlay({
    required this.position,
    required this.alignment,
    required this.animation,
    required this.targetOffset,
    required this.onHide,
    required this.builder,
    required this.isDismissible,
    required this.hasLockScreen,
  });

  final OdinTooltipPosition position;
  final OdinTooltipAlignment alignment;
  final Animation<double> animation;
  final Offset targetOffset;
  final bool isDismissible;
  final bool hasLockScreen;
  final VoidCallback onHide;
  final TooltipWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final tooltipTheme = OdinTooltipTheme.of(context);

    final child = Stack(
      children: [
        if (isDismissible)
          // GestureDetector to close the tooltip when touching outside.
          Positioned.fill(
            child: GestureDetector(
              onTap: onHide,
              behavior: HitTestBehavior.translucent,
            ),
          ),
        FadeTransition(
          opacity: animation,
          child: CustomSingleChildLayout(
            delegate: _TooltipPositionDelegate(
              position: position,
              alignment: alignment,
              targetOffset: targetOffset,
              targetMargin: tooltipTheme.targetMargin,
              sideMargin: tooltipTheme.sideMargin,
              bevelSize: tooltipTheme.bevelSize,
            ),
            child: Padding(
              padding: switch (position) {
                OdinTooltipPosition.left => const EdgeInsets.only(right: OdinPaddingValue.xxs),
                OdinTooltipPosition.right => const EdgeInsets.only(left: OdinPaddingValue.xxs),
                OdinTooltipPosition.top => const EdgeInsets.only(bottom: OdinPaddingValue.xxxs),
                OdinTooltipPosition.bottom => const EdgeInsets.only(top: OdinPaddingValue.xxxs),
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: tooltipTheme.boxShadow,
                ),
                child: Material(
                  color: kTransparentColor,
                  child: CustomPaint(
                    painter: _TooltipPainter(
                      backgroundColor: tooltipTheme.backgroundColor,
                      borderColor: tooltipTheme.borderColor,
                      borderWidth: tooltipTheme.borderWidth,
                      radius: tooltipTheme.radius,
                      bevelSize: tooltipTheme.bevelSize,
                      position: position,
                      alignment: alignment,
                    ),
                    child: Material(
                      color: kTransparentColor,
                      child: builder(context, onHide),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return hasLockScreen
        ? OdinGlobalLockScreen(child: child) //
        : child;
  }
}

/// A delegate for computing the layout of a tooltip to be displayed above or
/// bellow a target specified in the global coordinate system.
final class _TooltipPositionDelegate extends SingleChildLayoutDelegate {
  const _TooltipPositionDelegate({
    required this.position,
    required this.alignment,
    required this.targetOffset,
    required this.targetMargin,
    required this.sideMargin,
    required this.bevelSize,
  });

  final OdinTooltipPosition position;

  final OdinTooltipAlignment alignment;

  /// The offset of the target the tooltip is positioned near in the global
  /// coordinate system.
  final Offset targetOffset;

  /// The amount of distance between the target and the displayed tooltip.
  final double targetMargin;

  final double sideMargin;

  final Size bevelSize;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return switch ((position, alignment)) {
      (OdinTooltipPosition.left, _) => BoxConstraints(
        maxWidth: max(0.0, targetOffset.dx - targetMargin - bevelSize.height - sideMargin),
      ),
      (OdinTooltipPosition.right, _) => BoxConstraints(
        maxWidth: max(0.0, constraints.maxWidth - targetOffset.dx - bevelSize.height - sideMargin),
      ),
      (OdinTooltipPosition.top, OdinTooltipAlignment.start) ||
      (
        OdinTooltipPosition.bottom,
        OdinTooltipAlignment.start,
      ) => BoxConstraints(maxWidth: constraints.maxWidth - targetOffset.dx - sideMargin),
      (OdinTooltipPosition.top, OdinTooltipAlignment.center) || (OdinTooltipPosition.bottom, OdinTooltipAlignment.center) => BoxConstraints(
        maxWidth: (min(targetOffset.dx, constraints.maxWidth - targetOffset.dx) - sideMargin) * 2,
      ),
      (OdinTooltipPosition.top, OdinTooltipAlignment.end) ||
      (
        OdinTooltipPosition.bottom,
        OdinTooltipAlignment.end,
      ) => BoxConstraints(maxWidth: targetOffset.dx - sideMargin),
    };
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final x = switch ((position, alignment)) {
      (OdinTooltipPosition.left, _) => targetOffset.dx - childSize.width - targetMargin - bevelSize.height,
      (OdinTooltipPosition.right, _) => targetOffset.dx + bevelSize.height,
      (OdinTooltipPosition.top, OdinTooltipAlignment.start) => targetOffset.dx,
      (OdinTooltipPosition.top, OdinTooltipAlignment.center) => targetOffset.dx - childSize.width / 2,
      (OdinTooltipPosition.top, OdinTooltipAlignment.end) => targetOffset.dx - childSize.width,
      (OdinTooltipPosition.bottom, OdinTooltipAlignment.start) => targetOffset.dx,
      (OdinTooltipPosition.bottom, OdinTooltipAlignment.center) => targetOffset.dx - childSize.width / 2,
      (OdinTooltipPosition.bottom, OdinTooltipAlignment.end) => targetOffset.dx - childSize.width,
    };

    final y = switch ((position, alignment)) {
      (OdinTooltipPosition.left, OdinTooltipAlignment.start) => targetOffset.dy,
      (OdinTooltipPosition.left, OdinTooltipAlignment.center) => targetOffset.dy - childSize.height / 2,
      (OdinTooltipPosition.left, OdinTooltipAlignment.end) => targetOffset.dy - childSize.height,
      (OdinTooltipPosition.right, OdinTooltipAlignment.start) => targetOffset.dy,
      (OdinTooltipPosition.right, OdinTooltipAlignment.center) => targetOffset.dy - childSize.height / 2,
      (OdinTooltipPosition.right, OdinTooltipAlignment.end) => targetOffset.dy - childSize.height,
      (OdinTooltipPosition.top, _) => targetOffset.dy - childSize.height - targetMargin - bevelSize.height,
      (OdinTooltipPosition.bottom, _) => targetOffset.dy + targetMargin + bevelSize.height,
    };

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_TooltipPositionDelegate oldDelegate) {
    return position != oldDelegate.position || //
        alignment != oldDelegate.alignment ||
        targetOffset != oldDelegate.targetOffset ||
        targetMargin != oldDelegate.targetMargin;
  }
}

class _TooltipPainter extends CustomPainter {
  const _TooltipPainter({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.radius,
    required this.bevelSize,
    required this.position,
    required this.alignment,
  });

  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Radius radius;
  final Size bevelSize;
  final OdinTooltipPosition position;
  final OdinTooltipAlignment alignment;

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()..color = backgroundColor;
    final bevelPosition = _normalizeBevelPosition(size);
    final halfBevelWidth = bevelSize.width / 2;

    final path = Path();
    path.moveTo(radius.x, 0);

    // Draw the top bevel
    if (position == OdinTooltipPosition.bottom) {
      path.lineTo(size.width * bevelPosition - halfBevelWidth, 0);
      path.relativeLineTo(bevelSize.width * 0.3, -bevelSize.height * 0.7);
      path.relativeQuadraticBezierTo(
        bevelSize.width * 0.15,
        -bevelSize.height * 0.3,
        bevelSize.width * 0.3,
        0,
      );
      path.lineTo(size.width * bevelPosition + halfBevelWidth, 0);
    }

    path.lineTo(size.width - radius.x, 0);
    path.arcToPoint(Offset(size.width, radius.y), radius: radius);

    // Draw the right bevel
    if (position == OdinTooltipPosition.left) {
      path.lineTo(size.width, size.height * bevelPosition - halfBevelWidth);
      path.relativeLineTo(bevelSize.height * 0.7, bevelSize.width * 0.35);
      path.relativeQuadraticBezierTo(
        bevelSize.height * 0.3,
        bevelSize.width * 0.15,
        0,
        bevelSize.width * 0.3,
      );
      path.lineTo(size.width, size.height * bevelPosition + halfBevelWidth);
    }

    path.lineTo(size.width, size.height - radius.y);
    path.arcToPoint(Offset(size.width - radius.x, size.height), radius: radius);

    // Draw the bottom bevel
    if (position == OdinTooltipPosition.top) {
      path.lineTo(size.width * bevelPosition + halfBevelWidth, size.height);
      path.relativeLineTo(-bevelSize.width * 0.35, bevelSize.height * 0.7);
      path.relativeQuadraticBezierTo(
        -bevelSize.width * 0.15,
        bevelSize.height * 0.3,
        -bevelSize.width * 0.3,
        0.0,
      );
      path.lineTo(size.width * bevelPosition - halfBevelWidth, size.height);
    }

    path.lineTo(radius.x, size.height);
    path.arcToPoint(Offset(0, size.height - radius.y), radius: radius);

    // Draw the left bevel
    if (position == OdinTooltipPosition.right) {
      path.lineTo(0, size.height * bevelPosition + halfBevelWidth);
      path.relativeLineTo(-bevelSize.height * 0.7, -bevelSize.width * 0.35);
      path.relativeQuadraticBezierTo(
        -bevelSize.height * 0.30,
        -bevelSize.width * 0.15,
        0.0,
        -bevelSize.width * 0.3,
      );
      path.lineTo(0, size.height * bevelPosition - halfBevelWidth);
    }

    path.lineTo(0, radius.y);
    path.arcToPoint(Offset(radius.x, 0), radius: radius);

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _TooltipPainter || //
        backgroundColor != oldDelegate.backgroundColor ||
        borderColor != oldDelegate.borderColor ||
        borderWidth != oldDelegate.borderWidth ||
        radius != oldDelegate.radius;
  }

  double _normalizeBevelPosition(Size size) {
    final relativeAxisPosition = switch (alignment) {
      OdinTooltipAlignment.start => 0.0,
      OdinTooltipAlignment.center => 0.5,
      OdinTooltipAlignment.end => 1.0,
    };
    switch (position) {
      case OdinTooltipPosition.left:
      case OdinTooltipPosition.right:
        final minPosition = (radius.y + (bevelSize.width / 2)) / size.height;
        final maxPosition = max(minPosition, 1 - minPosition);
        return relativeAxisPosition.clamp(minPosition, maxPosition);
      case OdinTooltipPosition.top:
      case OdinTooltipPosition.bottom:
        final minPosition = (radius.x + (bevelSize.width / 2)) / size.width;
        final maxPosition = max(minPosition, 1 - minPosition);
        return relativeAxisPosition.clamp(minPosition, maxPosition);
    }
  }
}

final class OdinTooltipTheme extends InheritedTheme {
  const OdinTooltipTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinTooltipThemeData data;

  static OdinTooltipThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinTooltipTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).tooltipTheme;
  }

  @override
  bool updateShouldNotify(OdinTooltipTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinTooltipTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinTooltipThemeData {
  OdinTooltipThemeData({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.targetMargin,
    required this.sideMargin,
    required this.radius,
    required this.bevelSize,
    required this.boxShadow,
  });

  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double targetMargin;
  final double sideMargin;
  final Radius radius;
  final Size bevelSize;
  final List<BoxShadow> boxShadow;

  static OdinTooltipThemeData lerp(
    OdinTooltipThemeData a,
    OdinTooltipThemeData b,
    double t,
  ) {
    return OdinTooltipThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t)!,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      targetMargin: lerpDouble(a.targetMargin, b.targetMargin, t),
      sideMargin: lerpDouble(a.sideMargin, b.sideMargin, t),
      radius: Radius.lerp(a.radius, b.radius, t)!,
      bevelSize: Size.lerp(a.bevelSize, b.bevelSize, t)!,
      boxShadow: t < 0.5 ? a.boxShadow : b.boxShadow,
    );
  }

  OdinTooltipThemeData copyWith({
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    double? targetMargin,
    double? sideMargin,
    Radius? radius,
    Size? bevelSize,
    List<BoxShadow>? boxShadow,
  }) {
    return OdinTooltipThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      targetMargin: targetMargin ?? this.targetMargin,
      sideMargin: sideMargin ?? this.sideMargin,
      radius: radius ?? this.radius,
      bevelSize: bevelSize ?? this.bevelSize,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }
}

OdinTooltipThemeData createDefaultTooltipTheme({
  required OdinColorScheme colorScheme,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  return OdinTooltipThemeData(
    backgroundColor: colorScheme.neutralBase,
    borderColor: colorScheme.outlineBase,
    borderWidth: borderTheme.strokeThin,
    targetMargin: OdinGapValue.xxxs,
    sideMargin: OdinGapValue.sm,
    radius: borderTheme.radiusSmall,
    bevelSize: const Size(16, 8),
    boxShadow: colorScheme.elevationMedium,
  );
}
