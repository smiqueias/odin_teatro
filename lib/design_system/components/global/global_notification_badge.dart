import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/color_scheme/color_scheme_provider.dart';
import 'package:odin_teatro/design_system/components/ui/odin_border.dart';
import 'package:odin_teatro/design_system/foundation/constants.dart';

sealed class OdinGlobalNotificationBadgeKind {
  const factory OdinGlobalNotificationBadgeKind.bullet() = OdinGlobalNotificationBadgeKindBullet;

  const factory OdinGlobalNotificationBadgeKind.counter({
    required int count,
    int? maxCount,
  }) = OdinGlobalNotificationBadgeKindCounter;
}

final class OdinGlobalNotificationBadgeKindBullet implements OdinGlobalNotificationBadgeKind {
  const OdinGlobalNotificationBadgeKindBullet();
}

@immutable
final class OdinGlobalNotificationBadgeKindCounter implements OdinGlobalNotificationBadgeKind {
  const OdinGlobalNotificationBadgeKindCounter({
    required this.count,
    this.maxCount,
  });

  final int count;
  final int? maxCount;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else {
      return other is OdinGlobalNotificationBadgeKindCounter && //
          other.count == count &&
          other.maxCount == maxCount;
    }
  }

  @override
  int get hashCode {
    return Object.hashAll([OdinGlobalNotificationBadgeKindCounter, count, maxCount]);
  }
}

final class OdinGlobalNotificationBadge extends StatelessWidget {
  const OdinGlobalNotificationBadge({
    required this.kind,
    super.key,
  });

  const OdinGlobalNotificationBadge.bullet({
    super.key,
  }) : kind = const OdinGlobalNotificationBadgeKind.bullet();

  OdinGlobalNotificationBadge.counter({
    required int count,
    super.key,
    int? maxCount,
  }) : kind = OdinGlobalNotificationBadgeKind.counter(
         count: count,
         maxCount: maxCount,
       );

  final OdinGlobalNotificationBadgeKind kind;

  @override
  Widget build(BuildContext context) {
    final colors = OdinThemeProvider.of(context).appColorScheme;
    final typography = OdinThemeProvider.of(context).typography;

    switch (kind) {
      case OdinGlobalNotificationBadgeKindBullet():
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colors.statusErrorBase,
            shape: BoxShape.circle,
            border: OdinBorder.all(
              color: kTransparentColor,
              stroke: defaultBorderTheme.strokeHairline,
            ),
          ),
          child: SizedBox.square(dimension: 8.0),
        );
      case OdinGlobalNotificationBadgeKindCounter(:final count, :final maxCount):
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colors.statusInformativeBase,
            borderRadius: BorderRadius.circular(16.0 / 2),
            border: OdinBorder.all(
              color: kTransparentColor,
              stroke: 16.0,
            ),
          ),
          child: FittedBox(
            child: Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                minHeight: 16.0,
                minWidth: 16.0,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0 / 6),
              child: Text(
                maxCount == null || maxCount >= count ? '$count' : '$maxCount+',
                style: typography.labelMicro.copyWith(
                  color: colors.onColorEmphasisHighInverse,
                ),
              ),
            ),
          ),
        );
    }
  }
}
