import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/color_scheme/color_scheme.dart';
import 'package:odin_teatro/design_system/color_scheme/color_scheme_provider.dart';
import 'package:odin_teatro/design_system/components/ui/odin_border.dart';
import 'package:odin_teatro/design_system/foundation/typography.dart';

enum OdinGlobalProgressBarKind { rounded, squared }

enum OdinGlobalProgressBarStatus { normal, error }

enum OdinGlobalProgressBarSize { small, large }

class OdinGlobalProgressBar extends StatefulWidget {
  const OdinGlobalProgressBar({
    required this.value,
    super.key,
    this.size = .small,
    this.kind = .rounded,
    this.status = .normal,
  }) : assert(
         value >= 0 && value <= 1,
         'The GlobalProgressBar value must be between the range [0,1]',
       );

  final double value;
  final OdinGlobalProgressBarSize size;
  final OdinGlobalProgressBarKind kind;
  final OdinGlobalProgressBarStatus status;

  @override
  State<OdinGlobalProgressBar> createState() => _OdinGlobalProgressBarState();
}

class _OdinGlobalProgressBarState extends State<OdinGlobalProgressBar> with SingleTickerProviderStateMixin {
  late double initialValue;
  late OdinGlobalProgressBarStatus? initialStatus;

  @override
  void initState() {
    super.initState();

    initialValue = widget.value;
    initialStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context).appColorScheme;

    final radius = switch (widget.kind) {
      OdinGlobalProgressBarKind.rounded => 100.0,
      OdinGlobalProgressBarKind.squared => 0.0,
    };

    final height = switch (widget.size) {
      OdinGlobalProgressBarSize.small => 4.0,
      OdinGlobalProgressBarSize.large => 8.0,
    };

    final resolvedStatus = widget.status;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: TweenAnimationBuilder(
        tween: Tween<double>(
          begin: initialValue,
          end: widget.value,
        ),
        duration: const Duration(milliseconds: 200),
        builder: (context, value, child) {
          return TweenAnimationBuilder(
            tween: ColorTween(
              begin: _getColorFromStatus(context, widget.status),
              end: _getColorFromStatus(context, resolvedStatus),
            ),
            duration: const Duration(milliseconds: 200),
            builder: (context, color, child) {
              return LinearProgressIndicator(
                value: value,
                color: color,
                minHeight: height,
                backgroundColor: theme.neutralExtended40,
              );
            },
          );
        },
      ),
    );
  }

  Color _getColorFromStatus(BuildContext context, OdinGlobalProgressBarStatus status) {
    final colorScheme = OdinThemeProvider.of(context).appColorScheme;

    return switch (status) {
      OdinGlobalProgressBarStatus.normal => colorScheme.statusInformativeBase,
      OdinGlobalProgressBarStatus.error => colorScheme.statusErrorBase,
    };
  }
}

final class OdinGlobalProgressBarTheme extends InheritedTheme {
  const OdinGlobalProgressBarTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinGlobalProgressBarThemeData data;

  static OdinGlobalProgressBarThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinGlobalProgressBarTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).globalProgressBarTheme;
  }

  @override
  bool updateShouldNotify(OdinGlobalProgressBarTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinGlobalProgressBarTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinGlobalProgressBarThemeData {
  OdinGlobalProgressBarThemeData({
    required this.size,
    required this.kind,
    required this.status,
  });

  final OdinGlobalProgressBarSize size;
  final OdinGlobalProgressBarKind kind;
  final OdinGlobalProgressBarStatus status;

  static OdinGlobalProgressBarThemeData lerp(
    OdinGlobalProgressBarThemeData a,
    OdinGlobalProgressBarThemeData b,
    double t,
  ) {
    return OdinGlobalProgressBarThemeData(
      size: t < 0.5 ? a.size : b.size,
      kind: t < 0.5 ? a.kind : b.kind,
      status: t < 0.5 ? a.status : b.status,
    );
  }

  OdinGlobalProgressBarThemeData copyWith({
    OdinGlobalProgressBarSize? size,
    OdinGlobalProgressBarKind? kind,
    OdinGlobalProgressBarStatus? status,
  }) {
    return OdinGlobalProgressBarThemeData(
      size: size ?? this.size,
      kind: kind ?? this.kind,
      status: status ?? this.status,
    );
  }
}

OdinGlobalProgressBarThemeData createDefaultGlobalProgressBarTheme({
  required OdinColorScheme colorScheme,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  return OdinGlobalProgressBarThemeData(
    size: OdinGlobalProgressBarSize.small,
    kind: OdinGlobalProgressBarKind.rounded,
    status: OdinGlobalProgressBarStatus.normal,
  );
}
