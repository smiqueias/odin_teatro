import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

enum OdinBadgeStatusKind {
  positive,
  warning,
  negative,
  informative,
  neutral,
}

enum OdinBadgeSuitabilityKind {
  conservative,
  moderate,
  sophisticated,
}

sealed class OdinBadgeWidget extends StatelessWidget {
  const OdinBadgeWidget({super.key});
}

final class OdinBadgeStatus extends OdinBadgeWidget {
  const OdinBadgeStatus({
    required this.kind,
    required this.label,
    super.key,
    this.hasOutline = false,
    this.isLoading = false,
    this.semanticsLabel,
    this.semanticsHint,
    this.onPress,
  });

  const OdinBadgeStatus.positive({
    required this.label,
    super.key,
    this.hasOutline = false,
    this.isLoading = false,
    this.semanticsLabel,
    this.semanticsHint,
    this.onPress,
  }) : kind = OdinBadgeStatusKind.positive;

  const OdinBadgeStatus.warning({
    required this.label,
    super.key,
    this.hasOutline = false,
    this.isLoading = false,
    this.semanticsLabel,
    this.semanticsHint,
    this.onPress,
  }) : kind = OdinBadgeStatusKind.warning;

  const OdinBadgeStatus.negative({
    required this.label,
    super.key,
    this.hasOutline = false,
    this.isLoading = false,
    this.semanticsLabel,
    this.semanticsHint,
    this.onPress,
  }) : kind = OdinBadgeStatusKind.negative;

  const OdinBadgeStatus.informative({
    required this.label,
    super.key,
    this.hasOutline = false,
    this.isLoading = false,
    this.semanticsLabel,
    this.semanticsHint,
    this.onPress,
  }) : kind = OdinBadgeStatusKind.informative;

  const OdinBadgeStatus.neutral({
    required this.label,
    super.key,
    this.hasOutline = false,
    this.isLoading = false,
    this.semanticsLabel,
    this.semanticsHint,
    this.onPress,
  }) : kind = OdinBadgeStatusKind.neutral;

  final OdinBadgeStatusKind kind;
  final Widget label;
  final bool hasOutline;
  final bool isLoading;
  final String? semanticsLabel;
  final String? semanticsHint;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);

    final icon = _getIcon();
    final iconColor = _getIconColorOf(theme.appColorScheme);
    final backgroundColor = _getBackgroundColorOf(theme.appColorScheme);

    return OdinBadge(
      backgroundColor: backgroundColor,
      label: label,
      iconContainer: OdinIconContainer(
        icon: icon,
        color: iconColor,
      ),
      hasOutline: hasOutline,
      isLoading: isLoading,
      semanticsLabel: semanticsLabel,
      semanticsHint: semanticsHint,
      onPress: onPress,
    );
  }

  IconData _getIcon() {
    return switch (kind) {
      OdinBadgeStatusKind.positive => OdinIcons.statusSuccess,
      OdinBadgeStatusKind.warning => OdinIcons.statusWarning,
      OdinBadgeStatusKind.negative => OdinIcons.statusDisapproved,
      OdinBadgeStatusKind.informative => OdinIcons.infoOn,
      OdinBadgeStatusKind.neutral => OdinIcons.infoOn,
    };
  }

  Color _getIconColorOf(OdinColorScheme colorScheme) {
    return switch (kind) {
      OdinBadgeStatusKind.positive => colorScheme.statusSuccessBase,
      OdinBadgeStatusKind.warning => colorScheme.statusWarningBase,
      OdinBadgeStatusKind.negative => colorScheme.statusErrorBase,
      OdinBadgeStatusKind.informative => colorScheme.statusInformativeBase,
      OdinBadgeStatusKind.neutral => colorScheme.neutralExtended70,
    };
  }

  Color _getBackgroundColorOf(OdinColorScheme colorScheme) {
    return switch (kind) {
      OdinBadgeStatusKind.positive => colorScheme.statusSuccessBaseSurface,
      OdinBadgeStatusKind.warning => colorScheme.statusWarningBaseSurface,
      OdinBadgeStatusKind.negative => colorScheme.statusErrorBaseSurface,
      OdinBadgeStatusKind.informative => colorScheme.statusInformativeBaseSurface,
      OdinBadgeStatusKind.neutral => colorScheme.neutralExtended30,
    };
  }
}

final class OdinBadgeSuitability extends OdinBadgeWidget {
  const OdinBadgeSuitability({
    required this.kind,
    super.key,
    this.hasOutline = false,
    this.isLoading = false,
    this.semanticsLabel,
    this.semanticsHint,
    this.onPress,
  });

  const OdinBadgeSuitability.conservative({
    super.key,
    this.hasOutline = false,
    this.isLoading = false,
    this.semanticsLabel,
    this.semanticsHint,
    this.onPress,
  }) : kind = OdinBadgeSuitabilityKind.conservative;

  const OdinBadgeSuitability.moderate({
    super.key,
    this.hasOutline = false,
    this.isLoading = false,
    this.semanticsLabel,
    this.semanticsHint,
    this.onPress,
  }) : kind = OdinBadgeSuitabilityKind.moderate;

  const OdinBadgeSuitability.sophisticated({
    super.key,
    this.hasOutline = false,
    this.isLoading = false,
    this.semanticsLabel,
    this.semanticsHint,
    this.onPress,
  }) : kind = OdinBadgeSuitabilityKind.sophisticated;

  final OdinBadgeSuitabilityKind kind;
  final bool hasOutline;
  final bool isLoading;
  final String? semanticsLabel;
  final String? semanticsHint;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);

    return OdinBadge(
      backgroundColor: _getBackgroundColor(theme.appColorScheme),
      hasOutline: hasOutline,
      isLoading: isLoading,
      iconContainer: OdinIconContainer(
        icon: _getIcon(),
        color: theme.appColorScheme.onColorEmphasisMedium,
      ),
      label: Text(
        _getText(),
        style: theme.typography.labelMicro,
      ),
      semanticsLabel: semanticsLabel,
      semanticsHint: semanticsHint,
      onPress: onPress,
    );
  }

  Color _getBackgroundColor(OdinColorScheme colorScheme) {
    return switch (kind) {
      OdinBadgeSuitabilityKind.conservative => colorScheme.supportAqua10,
      OdinBadgeSuitabilityKind.moderate => colorScheme.supportPink10,
      OdinBadgeSuitabilityKind.sophisticated => colorScheme.supportPurple10,
    };
  }

  IconData _getIcon() {
    return switch (kind) {
      OdinBadgeSuitabilityKind.conservative => OdinIcons.conservative,
      OdinBadgeSuitabilityKind.moderate => OdinIcons.moderate,
      OdinBadgeSuitabilityKind.sophisticated => OdinIcons.aggressive,
    };
  }

  String _getText() {
    return switch (kind) {
      OdinBadgeSuitabilityKind.conservative => 'Conservador',
      OdinBadgeSuitabilityKind.moderate => 'Moderado',
      OdinBadgeSuitabilityKind.sophisticated => 'Sofisticado',
    };
  }
}

final class OdinBadge extends OdinBadgeWidget {
  const OdinBadge({
    required this.backgroundColor,
    required this.label,
    super.key,
    this.iconContainer,
    this.imageContainer,
    this.hasOutline = false,
    this.isLoading = false,
    this.semanticsLabel,
    this.semanticsHint,
    this.onPress,
  });

  static const _radius = 24.0;

  final Color backgroundColor;
  final Widget label;
  final OdinIconContainer? iconContainer;
  final OdinImageContainer? imageContainer;
  final bool hasOutline;
  final bool isLoading;
  final String? semanticsLabel;
  final String? semanticsHint;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colorScheme = theme.appColorScheme;
    final typography = theme.typography;

    return OdinShimmer(
      isLoading: isLoading,
      child: OdinShimmerCover(
        borderRadius: _radius,
        child: Semantics(
          label: semanticsLabel,
          hint: semanticsHint,
          child: Container(
            height: MediaQuery.textScalerOf(context).scale(_radius),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(_radius),
              border: hasOutline
                  ? OdinBorder.all(
                      color: colorScheme.outlineBase,
                      stroke: theme.borderTheme.strokeThin,
                    )
                  : null,
            ),
            child: Material(
              color: kTransparentColor,
              child: OdinInkWell(
                onTap: onPress,
                borderRadius: BorderRadius.circular(_radius),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: OdinPaddingValue.xxs),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: OdinGapValue.xxs,
                    children: [
                      if (imageContainer case final imageContainer?)
                        OdinImageContainerTheme(
                          data: OdinImageContainerTheme.of(context).copyWith(
                            size: OdinImageContainerSize.size16,
                          ),
                          child: imageContainer,
                        ),
                      if (iconContainer case final iconContainer?)
                        OdinIconContainerTheme(
                          data: OdinIconContainerTheme.of(context).copyWith(
                            size: OdinIconContainerSize.size16,
                          ),
                          child: iconContainer,
                        ),
                      Flexible(
                        child: DefaultTextStyle(
                          style: typography.labelMicro.copyWith(
                            color: colorScheme.onColorEmphasisHigh,
                          ),
                          child: label,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum OdinBadgeCountSize {
  large,
  small,
}

final class OdinBadgeCount extends OdinBadgeWidget {
  const OdinBadgeCount({
    required this.count,
    super.key,
    this.size = OdinBadgeCountSize.small,
    this.semanticsLabel,
    this.semanticsHint,
    this.onPress,
  });

  final int count;
  final OdinBadgeCountSize size;
  final String? semanticsLabel;
  final String? semanticsHint;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colorScheme = theme.appColorScheme;
    final typography = theme.typography;

    return OdinBadge(
      backgroundColor: colorScheme.supportGrey20,
      label: Text(
        count <= 0
            ? '$count' //
            : '+$count',
        style: switch (size) {
          OdinBadgeCountSize.large => typography.labelSmall.copyWith(
            color: colorScheme.onColorEmphasisHigh,
          ),
          OdinBadgeCountSize.small => typography.labelMicro.copyWith(
            color: colorScheme.onColorEmphasisHigh,
          ),
        },
      ),
      semanticsLabel: semanticsLabel,
      semanticsHint: semanticsHint,
      onPress: onPress,
    );
  }
}

final class OdinBadgesGroup extends StatelessWidget {
  const OdinBadgesGroup({
    required this.badges,
    super.key,
    this.badgeSurplus,
    this.textDirection = TextDirection.ltr,
  });

  final List<OdinBadgeWidget> badges;
  final OdinBadgeSurplus? badgeSurplus;
  final TextDirection textDirection;

  bool get hasContent {
    final badgeSurplus = this.badgeSurplus;

    return badges.isNotEmpty || (badgeSurplus != null && badgeSurplus.items.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      textDirection: textDirection,
      spacing: OdinGapValue.xxxs,
      runSpacing: OdinGapValue.xxs,
      children: [
        ...badges,
        if (badgeSurplus case final badgeSurplus? when badgeSurplus.items.isNotEmpty) //
          badgeSurplus,
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('badges', badges));
  }
}

final class OdinBadgeSurplus extends StatelessWidget {
  const OdinBadgeSurplus({
    required this.items,
    super.key,
    this.backgroundColor,
    this.hasOutline = false,
    this.tooltipAlignment = OdinTooltipAlignment.center,
    this.tooltipPosition = OdinTooltipPosition.bottom,
  });

  final List<Widget> items;
  final Color? backgroundColor;
  final bool hasOutline;
  final OdinTooltipAlignment tooltipAlignment;
  final OdinTooltipPosition tooltipPosition;

  @override
  Widget build(BuildContext context) {
    final colorScheme = OdinThemeProvider.of(context).appColorScheme;

    return OdinTooltip(
      alignment: tooltipAlignment,
      position: tooltipPosition,
      builder: (context, void Function() onHide) {
        return Padding(
          padding: const EdgeInsets.all(OdinPaddingValue.xxs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items,
          ),
        );
      },
      child: OdinBadge(
        backgroundColor: backgroundColor ?? colorScheme.neutralExtended30,
        hasOutline: hasOutline,
        label: Text('+${items.length}'),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('collapsedItems', items));
  }
}
