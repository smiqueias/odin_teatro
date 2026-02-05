import 'dart:math';

import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

final class OdinModal extends StatelessWidget {
  const OdinModal({
    required this.title,
    super.key,
    this.content,
    this.primaryAction,
    this.secondaryAction,
    this.linkAction,
    this.backgroundColor,
    this.contentPadding = const EdgeInsets.all(OdinPaddingValue.sm),
  }) : assert(
         content != null || primaryAction != null || secondaryAction != null || linkAction != null,
         'You have to provide at least one of the following parameters: content, primaryAction, secondaryAction, linkAction',
       );

  OdinModal.defaultContent({
    required this.title,
    super.key,
    Widget? subtitle,
    Widget? paragraph,
    this.linkAction,
    this.primaryAction,
    this.secondaryAction,
    this.backgroundColor,
  }) : content = (subtitle != null || paragraph != null)
           ? _OdinModalDefaultContent(
               subtitle: subtitle,
               paragraph: paragraph,
             )
           : null,
       contentPadding = const EdgeInsets.all(OdinPaddingValue.sm);

  final Widget title;
  final Widget? content;
  final OdinActionSettings<VoidCallback>? linkAction;
  final OdinActionSettings<VoidCallback>? primaryAction;
  final OdinActionSettings<VoidCallback>? secondaryAction;
  final EdgeInsets contentPadding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colorScheme = theme.appColorScheme;

    final primaryAction = this.primaryAction;
    final secondaryAction = this.secondaryAction;
    final linkAction = this.linkAction;
    final hasButtonFixed = primaryAction != null || secondaryAction != null || linkAction != null;

    return Material(
      color: backgroundColor ?? colorScheme.neutralBase,
      child: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: OdinPaddingValue.sm,
                    right: OdinPaddingValue.xxl,
                    top: OdinPaddingValue.sm,
                  ),
                  child: DefaultTextStyle(
                    style: theme.typography.titleSmall.copyWith(
                      color: theme.appColorScheme.onColorEmphasisHigh,
                    ),
                    child: title,
                  ),
                ),
                if (content case final content?)
                  Flexible(
                    child: Padding(
                      padding: hasButtonFixed
                          // Discount the OdinBaseButtonFixed top padding
                          ? contentPadding.copyWith(
                              bottom: max(0.0, contentPadding.bottom - OdinGapValue.sm),
                            )
                          : contentPadding,
                      child: content,
                    ),
                  ),
                if (hasButtonFixed)
                  OdinBaseButtonFixed(
                    button: primaryAction == null
                        ? null //
                        : OdinButton.fromActionSettings(
                            actionSettings: primaryAction,
                          ),
                    link: secondaryAction == null
                        ? null //
                        : OdinLink.fromActionSettings(
                            actionSettings: secondaryAction,
                            isUnderline: true,
                          ),
                    externalLink: linkAction == null
                        ? null //
                        : OdinLink.fromActionSettings(
                            actionSettings: linkAction,
                          ),
                    hasDivider: false,
                    semantics: secondaryAction?.semantics ?? const OdinSemanticsData(),
                  )
                else
                  const OdinBottomSafeAreaSpacer(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(OdinPaddingValue.sm) - const EdgeInsets.all(kIconButtonExtraSpacing),
              child: OdinIconButton(
                icon: const Icon(OdinIcons.close),
                color: theme.appColorScheme.onColorEmphasisHigh,
                onPress: Navigator.of(context).pop,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _OdinModalDefaultContent extends StatelessWidget {
  const _OdinModalDefaultContent({
    required this.subtitle,
    required this.paragraph,
  });

  final Widget? subtitle;
  final Widget? paragraph;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (subtitle case final subtitle?)
          DefaultTextStyle(
            style: theme.typography.titleSmall.copyWith(
              color: theme.appColorScheme.onColorEmphasisHigh,
            ),
            child: subtitle,
          ),
        if (subtitle != null && paragraph != null) OdinGap.xxs,
        if (paragraph case final paragraph?)
          DefaultTextStyle(
            style: theme.typography.bodyBase.copyWith(
              color: theme.appColorScheme.onColorEmphasisMedium,
            ),
            child: paragraph,
          ),
      ],
    );
  }
}
