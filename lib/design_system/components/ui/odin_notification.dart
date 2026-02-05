import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

sealed class OdinNotificationKind {
  const OdinNotificationKind();

  const factory OdinNotificationKind.placeholder({
    required IconData icon,
    bool isEnabled,
  }) = OdinNotificationKindPlaceholder;

  const factory OdinNotificationKind.success() = OdinNotificationKindSuccess;

  const factory OdinNotificationKind.error() = OdinNotificationKindError;

  const factory OdinNotificationKind.warning() = OdinNotificationKindWarning;

  const factory OdinNotificationKind.info() = OdinNotificationKindInfo;

  const factory OdinNotificationKind.loader() = OdinNotificationKindLoader;
}

final class OdinNotificationKindPlaceholder extends OdinNotificationKind {
  const OdinNotificationKindPlaceholder({
    required this.icon,
    this.isEnabled = true,
  });

  final IconData icon;
  final bool isEnabled;
}

final class OdinNotificationKindSuccess extends OdinNotificationKind {
  const OdinNotificationKindSuccess();

  final IconData icon = OdinIcons.statusSuccess;
}

final class OdinNotificationKindError extends OdinNotificationKind {
  const OdinNotificationKindError();

  final IconData icon = OdinIcons.statusError;
}

final class OdinNotificationKindWarning extends OdinNotificationKind {
  const OdinNotificationKindWarning();

  final IconData icon = OdinIcons.statusWarning;
}

final class OdinNotificationKindInfo extends OdinNotificationKind {
  const OdinNotificationKindInfo();

  final IconData icon = OdinIcons.infoOn;
}

final class OdinNotificationKindLoader extends OdinNotificationKind {
  const OdinNotificationKindLoader();
}

class OdinNotificationInline extends StatelessWidget {
  const OdinNotificationInline({
    required this.kind,
    required this.title,
    super.key,
  });

  OdinNotificationInline.placeholder({
    required this.title,
    required IconData icon,
    super.key,
    bool isEnabled = true,
  }) : kind = OdinNotificationKind.placeholder(icon: icon, isEnabled: isEnabled);

  const OdinNotificationInline.success({
    required this.title,
    super.key,
  }) : kind = const OdinNotificationKind.success();

  const OdinNotificationInline.error({
    required this.title,
    super.key,
  }) : kind = const OdinNotificationKind.error();

  const OdinNotificationInline.warning({
    required this.title,
    super.key,
  }) : kind = const OdinNotificationKind.warning();

  const OdinNotificationInline.info({
    required this.title,
    super.key,
  }) : kind = const OdinNotificationKind.info();

  const OdinNotificationInline.loader({
    super.key,
    Widget? title,
  }) : kind = const OdinNotificationKind.loader(),
       title = title ?? const Text('Loren ipsum');

  final OdinNotificationKind kind;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final appColorScheme = theme.appColorScheme;

    final textColor = switch (kind) {
      OdinNotificationKindPlaceholder(isEnabled: false) => appColorScheme.onColorEmphasisDisabled,
      OdinNotificationKindPlaceholder(isEnabled: true) || //
      OdinNotificationKindSuccess() ||
      OdinNotificationKindError() ||
      OdinNotificationKindWarning() ||
      OdinNotificationKindInfo() ||
      OdinNotificationKindLoader() => appColorScheme.onColorEmphasisHigh,
    };

    final iconColor = switch (kind) {
      OdinNotificationKindPlaceholder(isEnabled: false) => appColorScheme.onColorEmphasisDisabled,
      OdinNotificationKindPlaceholder(isEnabled: true) => appColorScheme.onColorEmphasisHigh,
      OdinNotificationKindSuccess() => appColorScheme.statusSuccessBase,
      OdinNotificationKindError() => appColorScheme.statusErrorBase,
      OdinNotificationKindWarning() => appColorScheme.statusWarningBase,
      OdinNotificationKindInfo() => appColorScheme.statusInformativeBase,
      OdinNotificationKindLoader() => appColorScheme.onColorEmphasisHigh,
    };

    return OdinShimmer(
      isLoading: kind == const OdinNotificationKind.loader(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          OdinShimmerCover(
            child: _NotificationIcon(
              kind: kind,
              color: iconColor,
            ),
          ),
          OdinGap.xxs,
          OdinShimmerCover(
            child: Flexible(
              child: DefaultTextStyle(
                style: theme.typography.bodySmall.copyWith(color: textColor),
                child: title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OdinNotificationFixed extends StatelessWidget {
  const OdinNotificationFixed({
    required this.kind,
    required this.paragraph,
    super.key,
    this.title,
    this.linkActionSettings,
    this.onPressClose,
  });

  OdinNotificationFixed.placeholder({
    required this.paragraph,
    required IconData icon,
    super.key,
    this.title,
    this.linkActionSettings,
    this.onPressClose,
    bool isEnabled = true,
  }) : kind = OdinNotificationKind.placeholder(icon: icon, isEnabled: isEnabled);

  const OdinNotificationFixed.success({
    required this.paragraph,
    super.key,
    this.title,
    this.linkActionSettings,
    this.onPressClose,
  }) : kind = const OdinNotificationKind.success();

  const OdinNotificationFixed.error({
    required this.paragraph,
    super.key,
    this.title,
    this.linkActionSettings,
    this.onPressClose,
  }) : kind = const OdinNotificationKind.error();

  const OdinNotificationFixed.warning({
    required this.paragraph,
    super.key,
    this.title,
    this.linkActionSettings,
    this.onPressClose,
  }) : kind = const OdinNotificationKind.warning();

  const OdinNotificationFixed.info({
    required this.paragraph,
    super.key,
    this.title,
    this.linkActionSettings,
    this.onPressClose,
  }) : kind = const OdinNotificationKind.info();

  const OdinNotificationFixed.loader({
    super.key,
    Widget? title,
    Widget? paragraph,
    this.linkActionSettings,
  }) : kind = const OdinNotificationKind.loader(),
       title = title ?? const Text('Loren ipsum'),
       paragraph = paragraph ?? const Text('Loren ipsum'),
       onPressClose = null;

  final OdinNotificationKind kind;
  final Widget? title;
  final Widget paragraph;
  final OdinActionSettings<VoidCallback>? linkActionSettings;
  final VoidCallback? onPressClose;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final title = this.title;

    return OdinShimmer(
      isLoading: kind == const OdinNotificationKind.loader(),
      child: OdinShimmerCover(
        child: _Notification(
          leading: _NotificationIcon(kind: kind),
          title: title == null
              ? null
              : DefaultTextStyle(
                  style: theme.typography.bodyBase.copyWith(
                    color: theme.appColorScheme.onColorEmphasisHigh,
                  ),
                  child: title,
                ),
          paragraph: DefaultTextStyle(
            style: theme.typography.bodySmall.copyWith(
              color: theme.appColorScheme.onColorEmphasisMedium,
            ),
            child: paragraph,
          ),
          backgroundColor: _getBackgroundColor(kind: kind, appColorScheme: theme.appColorScheme),
          hasCloseButton: onPressClose != null,
          hasShadow: false,
          linkActionSettings: linkActionSettings,
          onPressClose: onPressClose,
        ),
      ),
    );
  }
}

class OdinNotificationFloater extends StatelessWidget {
  const OdinNotificationFloater({
    required this.kind,
    required this.title,
    required this.paragraph,
    super.key,
    this.hasIcon = true,
    this.linkActionSettings,
    this.onPressClose,
  });

  OdinNotificationFloater.placeholder({
    required this.title,
    required this.paragraph,
    required IconData icon,
    super.key,
    this.hasIcon = true,
    this.linkActionSettings,
    this.onPressClose,
    bool isEnabled = true,
  }) : kind = OdinNotificationKind.placeholder(icon: icon, isEnabled: isEnabled);

  const OdinNotificationFloater.success({
    required this.title,
    required this.paragraph,
    super.key,
    this.hasIcon = true,
    this.linkActionSettings,
    this.onPressClose,
  }) : kind = const OdinNotificationKind.success();

  const OdinNotificationFloater.error({
    required this.title,
    required this.paragraph,
    super.key,
    this.hasIcon = true,
    this.linkActionSettings,
    this.onPressClose,
  }) : kind = const OdinNotificationKind.error();

  const OdinNotificationFloater.warning({
    required this.title,
    required this.paragraph,
    super.key,
    this.hasIcon = true,
    this.linkActionSettings,
    this.onPressClose,
  }) : kind = const OdinNotificationKind.warning();

  const OdinNotificationFloater.info({
    required this.title,
    required this.paragraph,
    super.key,
    this.hasIcon = true,
    this.linkActionSettings,
    this.onPressClose,
  }) : kind = const OdinNotificationKind.info();

  const OdinNotificationFloater.loader({
    required this.title,
    required this.paragraph,
    super.key,
    this.hasIcon = true,
    this.linkActionSettings,
    this.onPressClose,
  }) : kind = const OdinNotificationKind.loader();

  final OdinNotificationKind kind;
  final Widget title;
  final Widget? paragraph;
  final OdinActionSettings<VoidCallback>? linkActionSettings;
  final bool hasIcon;
  final VoidCallback? onPressClose;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final paragraph = this.paragraph;

    return _Notification(
      leading: hasIcon
          ? kind == const OdinNotificationKind.loader()
                ? const OdinGlobalLoaderSmall() //
                : _NotificationIcon(kind: kind)
          : null,
      title: DefaultTextStyle(
        style: theme.typography.bodySmall.copyWith(color: theme.appColorScheme.onColorEmphasisHigh),
        child: title,
      ),
      paragraph: paragraph == null
          ? null //
          : DefaultTextStyle(
              style: theme.typography.captionBase.copyWith(
                color: theme.appColorScheme.onColorEmphasisMedium,
              ),
              child: paragraph,
            ),
      backgroundColor: _getBackgroundColor(kind: kind, appColorScheme: theme.appColorScheme),
      hasCloseButton: true,
      hasShadow: true,
      linkActionSettings: linkActionSettings,
      onPressClose: onPressClose,
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({
    required this.kind,
    this.color,
  });

  final OdinNotificationKind kind;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        top: OdinPaddingValue.xxxs,
        right: OdinPaddingValue.xxxs,
      ),
      child: Icon(
        _getDefaultIcon(kind),
        color: color ?? _getDefaultIconColor(kind, theme.appColorScheme),
        size: 16.0,
      ),
    );
  }

  IconData _getDefaultIcon(OdinNotificationKind kind) {
    return switch (kind) {
      OdinNotificationKindPlaceholder(:final icon) => icon,
      OdinNotificationKindSuccess() => OdinIcons.statusSuccess,
      OdinNotificationKindError() => OdinIcons.statusError,
      OdinNotificationKindWarning() => OdinIcons.statusWarning,
      OdinNotificationKindInfo() => OdinIcons.infoOn,
      OdinNotificationKindLoader() => OdinIcons.empty,
    };
  }

  Color _getDefaultIconColor(OdinNotificationKind kind, OdinColorScheme appColorScheme) {
    return switch (kind) {
      OdinNotificationKindPlaceholder() => appColorScheme.onColorEmphasisHigh,
      OdinNotificationKindSuccess() => appColorScheme.statusSuccessBase,
      OdinNotificationKindError() => appColorScheme.statusErrorBase,
      OdinNotificationKindWarning() => appColorScheme.statusWarningBase,
      OdinNotificationKindInfo() => appColorScheme.statusInformativeBase,
      OdinNotificationKindLoader() => appColorScheme.onColorEmphasisHigh,
    };
  }
}

class _Notification extends StatelessWidget {
  const _Notification({
    required this.leading,
    required this.title,
    required this.paragraph,
    required this.backgroundColor,
    required this.hasCloseButton,
    required this.hasShadow,
    required this.linkActionSettings,
    required this.onPressClose,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? paragraph;
  final Color backgroundColor;
  final bool hasCloseButton;
  final bool hasShadow;
  final OdinActionSettings<VoidCallback>? linkActionSettings;
  final VoidCallback? onPressClose;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.appColorScheme.outlineBase,
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            4.0,
          ),
        ),
        boxShadow: hasShadow ? theme.appColorScheme.elevationHigh : null,
        color: backgroundColor,
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.all(OdinPaddingValue.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (leading case final leading?) ...[
                  leading,
                  OdinGap.xs,
                ],
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title case final title?) title,
                      if (title != null && paragraph != null) //
                        OdinGap.xxs,
                      if (paragraph case final paragraph?) paragraph,
                      if ((title != null || paragraph != null) && linkActionSettings != null) //
                        OdinGap.xs,
                      if (linkActionSettings case final linkActionSettings?)
                        OdinLink.fromActionSettings(
                          actionSettings: linkActionSettings.copyWith(
                            rightIcon: OdinIcons.chevronRight,
                          ),
                          size: OdinLinkSize.small,
                        ),
                    ],
                  ),
                ),
                if (hasCloseButton) //
                  OdinGap.md,
              ],
            ),
          ),
          if (hasCloseButton)
            Material(
              color: kTransparentColor,
              child: Padding(
                padding: const EdgeInsets.all(OdinPaddingValue.sm) - const EdgeInsets.all(kIconButtonExtraSpacing),
                child: OdinIconButton(
                  icon: const Icon(OdinIcons.close),
                  onPress: onPressClose,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Color _getBackgroundColor({
  required OdinNotificationKind kind,
  required OdinColorScheme appColorScheme,
}) {
  return switch (kind) {
    OdinNotificationKindPlaceholder() => appColorScheme.neutralBase,
    OdinNotificationKindSuccess() => appColorScheme.statusSuccessBaseSurface,
    OdinNotificationKindError() => appColorScheme.statusErrorBaseSurface,
    OdinNotificationKindWarning() => appColorScheme.statusWarningBaseSurface,
    OdinNotificationKindInfo() => appColorScheme.statusInformativeBaseSurface,
    OdinNotificationKindLoader() => appColorScheme.neutralBase,
  };
}
