import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/color_scheme/color_scheme.dart';
import 'package:odin_teatro/design_system/color_scheme/color_scheme_provider.dart';
import 'package:odin_teatro/design_system/components/ui/odin_border.dart';
import 'package:odin_teatro/design_system/foundation/lerp.dart';
import 'package:odin_teatro/design_system/foundation/spacing.dart';
import 'package:odin_teatro/design_system/foundation/typography.dart';

enum OdinGlobalDividerKind {
  content,
  section,
}

enum OdinGlobalDividerSize {
  thin,
  heavy,
}

final class OdinGlobalDivider extends StatelessWidget {
  const OdinGlobalDivider({
    required this.kind,
    required this.size,
    super.key,
    this.axis = Axis.horizontal,
  });

  final OdinGlobalDividerKind kind;
  final OdinGlobalDividerSize size;
  final Axis axis;

  static const contentThin = OdinGlobalDivider(
    kind: OdinGlobalDividerKind.content,
    size: OdinGlobalDividerSize.thin,
  );
  static const contentHeavy = OdinGlobalDivider(
    kind: OdinGlobalDividerKind.content,
    size: OdinGlobalDividerSize.heavy,
  );
  static const sectionThin = OdinGlobalDivider(
    kind: OdinGlobalDividerKind.section,
    size: OdinGlobalDividerSize.thin,
  );
  static const sectionHeavy = OdinGlobalDivider(
    kind: OdinGlobalDividerKind.section,
    size: OdinGlobalDividerSize.heavy,
  );

  @override
  Widget build(BuildContext context) {
    final theme = OdinDividerTheme.of(context);

    final edgeInsets = switch ((kind, axis)) {
      (OdinGlobalDividerKind.content, Axis.horizontal) => EdgeInsets.only(
        left: theme.indent,
        right: theme.indent,
      ),
      (OdinGlobalDividerKind.content, Axis.vertical) => EdgeInsets.only(
        top: theme.indent,
        bottom: theme.indent,
      ),
      (OdinGlobalDividerKind.section, _) => EdgeInsets.zero,
    };

    final thickness = switch (size) {
      OdinGlobalDividerSize.thin => theme.thinThickness,
      OdinGlobalDividerSize.heavy => theme.heavyThickness,
    };

    return Center(
      child: Container(
        margin: edgeInsets,
        color: theme.color,
        height: axis == Axis.horizontal ? thickness : double.infinity,
        width: axis == Axis.horizontal ? double.infinity : thickness,
      ),
    );
  }
}

final class OdinDividerTheme extends InheritedTheme {
  const OdinDividerTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinDividerThemeData data;

  static OdinDividerThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinDividerTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).dividerTheme;
  }

  @override
  bool updateShouldNotify(OdinDividerTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinDividerTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinDividerThemeData {
  OdinDividerThemeData({
    required this.thinThickness,
    required this.heavyThickness,
    required this.indent,
    required this.color,
  });

  final double thinThickness;
  final double heavyThickness;
  final double indent;
  final Color color;

  static OdinDividerThemeData lerp(
    OdinDividerThemeData a,
    OdinDividerThemeData b,
    double t,
  ) {
    return OdinDividerThemeData(
      thinThickness: lerpDouble(a.thinThickness, b.thinThickness, t),
      heavyThickness: lerpDouble(a.heavyThickness, b.heavyThickness, t),
      indent: lerpDouble(a.indent, b.indent, t),
      color: Color.lerp(a.color, b.color, t)!,
    );
  }

  OdinDividerThemeData copyWith({
    double? thinThickness,
    double? heavyThickness,
    double? indent,
    Color? color,
  }) {
    return OdinDividerThemeData(
      thinThickness: thinThickness ?? this.thinThickness,
      heavyThickness: heavyThickness ?? this.heavyThickness,
      indent: indent ?? this.indent,
      color: color ?? this.color,
    );
  }
}

OdinDividerThemeData createDefaultDividerTheme({
  required OdinColorScheme colorScheme,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  return OdinDividerThemeData(
    thinThickness: 1.0,
    heavyThickness: 4.0,
    indent: OdinGapValue.sm,
    color: colorScheme.outlineBase.withValues(alpha: 0.16),
  );
}
