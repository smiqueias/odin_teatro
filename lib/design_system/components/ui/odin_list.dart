import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

typedef OdinSubListBadges = OdinBadgesGroup;

enum OdinListImageAlignment {
  top,
  center,
  bottom,
}

class OdinList extends StatelessWidget {
  const OdinList({
    required this.content,
    super.key,
    this.imageKind,
    this.action,
    this.detail,
    this.button,
    this.hasDivider = false,
    this.isFullWidth = false,
    this.alignment = OdinListImageAlignment.top,
    this.onPress,
  });

  final OdinSubListAction? action;
  final OdinListImageAlignment alignment;
  final OdinSubListButton? button;
  final OdinSubListContent content;
  final OdinSubListDetail? detail;
  final bool hasDivider;
  final OdinSubListImageKind? imageKind;
  final bool isFullWidth;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final image = switch (imageKind) {
      null => null,
      OdinSubListImageKindAvatar(:final avatar) => OdinAvatarTheme(
        data: OdinAvatarTheme.of(context).copyWith(
          hasOutline: true,
          size: OdinAvatarSize.size40,
        ),
        child: avatar,
      ),
      OdinSubListImageKindIcon(:final iconContainer) => OdinIconContainerTheme(
        data: OdinIconContainerTheme.of(context).copyWith(
          size: OdinIconContainerSize.size24,
        ),
        child: iconContainer,
      ),
      OdinSubListImageKindIconCircle(:final iconContainerCircle) => OdinIconContainerTheme(
        data: OdinIconContainerTheme.of(context).copyWith(
          circleSize: OdinIconContainerCircleSize.size40,
        ),
        child: iconContainerCircle,
      ),
      OdinSubListImageKindImage(:final imageContainer) => OdinImageContainerTheme(
        data: OdinImageContainerTheme.of(context).copyWith(
          size: OdinImageContainerSize.size40,
          shape: OdinImageContainerShape.rounded,
        ),
        child: imageContainer,
      ),
      OdinSubListImageKindImageGroup(:final imageGroup) => OdinImageGroupTheme(
        data: OdinImageGroupThemeData(size: OdinImageGroupSize.medium),
        child: imageGroup,
      ),
    };

    final hasAnythingAfterImage = image != null && (content.hasContent || action != null);
    final hasAnythingAfterContent = content.hasContent && action != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OdinInkWell.outsideResponse(
          onTap: onPress,
          child: Row(
            crossAxisAlignment: switch (alignment) {
              OdinListImageAlignment.top => CrossAxisAlignment.start,
              OdinListImageAlignment.center => CrossAxisAlignment.center,
              OdinListImageAlignment.bottom => CrossAxisAlignment.end,
            },
            children: [
              if (isFullWidth) OdinGap.sm,
              if (image case final image?) image,
              if (hasAnythingAfterImage) OdinGap.xs,
              Expanded(
                child: Column(
                  children: [
                    content,
                    if (detail case final detail?) detail,
                  ],
                ),
              ),
              if (hasAnythingAfterContent) OdinGap.xs,
              if (action case final action?) action,
              if (isFullWidth) OdinGap.sm,
            ],
          ),
        ),
        if (button case final button?) button,
        if (hasDivider)
          const Padding(
            padding: EdgeInsets.only(top: OdinPaddingValue.xs),
            child: OdinGlobalDivider.sectionThin,
          ),
      ],
    );
  }
}

final class OdinSubListContent extends StatelessWidget {
  const OdinSubListContent({
    super.key,
    this.leftOverline,
    this.leftOverlineIcon,
    this.leftTitle,
    this.leftTitleIcon,
    this.leftSubtitle,
    this.leftParagraph,
    this.rightOverline,
    this.rightOverlineIcon,
    this.rightTitle,
    this.rightTitleIcon,
    this.rightSubtitle,
    this.rightParagraph,
    this.slot,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.slotFlex = 1,
  });

  final Widget? leftOverline;
  final Widget? leftOverlineIcon;
  final Widget? leftTitle;
  final Widget? leftTitleIcon;
  final Widget? leftSubtitle;
  final Widget? leftParagraph;
  final Widget? rightOverline;
  final Widget? rightOverlineIcon;
  final Widget? rightTitle;
  final Widget? rightTitleIcon;
  final Widget? rightSubtitle;
  final Widget? rightParagraph;
  final Widget? slot;
  final int leftFlex;
  final int rightFlex;
  final int slotFlex;

  bool get hasLeftContent =>
      leftOverline != null || //
      leftOverlineIcon != null ||
      leftTitle != null ||
      leftTitleIcon != null ||
      leftSubtitle != null ||
      leftParagraph != null;

  bool get hasRightContent =>
      rightOverline != null || //
      rightOverlineIcon != null ||
      rightTitle != null ||
      rightTitleIcon != null ||
      rightSubtitle != null ||
      rightParagraph != null;

  bool get hasSlot => slot != null;

  bool get hasContent => hasLeftContent || hasSlot || hasRightContent;

  @override
  Widget build(BuildContext context) {
    final hasAnythingAfterLeftContent = hasLeftContent && (hasSlot || hasRightContent);
    final hasAnythingAfterSlot = hasSlot && hasRightContent;
    final hasNothingBeforeRightContent = !hasLeftContent && !hasSlot;

    if (hasSlot) {
      return _MutableAlignmentSubListContent(
        hasLeftContent: hasLeftContent,
        leftFlex: leftFlex,
        leftOverline: leftOverline,
        leftOverlineIcon: leftOverlineIcon,
        leftTitle: leftTitle,
        leftTitleIcon: leftTitleIcon,
        leftSubtitle: leftSubtitle,
        leftParagraph: leftParagraph,
        hasAnythingAfterLeftContent: hasAnythingAfterLeftContent,
        slot: slot,
        slotFlex: slotFlex,
        hasAnythingAfterSlot: hasAnythingAfterSlot,
        hasNothingBeforeRightContent: hasNothingBeforeRightContent,
        hasRightContent: hasRightContent,
        rightFlex: rightFlex,
        rightOverline: rightOverline,
        rightOverlineIcon: rightOverlineIcon,
        rightTitle: rightTitle,
        rightTitleIcon: rightTitleIcon,
        rightSubtitle: rightSubtitle,
        rightParagraph: rightParagraph,
      );
    } else {
      return _ImmutableAlignmentSubListContent(
        hasLeftContent: hasLeftContent,
        leftFlex: leftFlex,
        leftOverline: leftOverline,
        leftOverlineIcon: leftOverlineIcon,
        leftTitle: leftTitle,
        leftTitleIcon: leftTitleIcon,
        leftSubtitle: leftSubtitle,
        leftParagraph: leftParagraph,
        hasRightContent: hasRightContent,
        rightFlex: rightFlex,
        rightOverline: rightOverline,
        rightOverlineIcon: rightOverlineIcon,
        rightTitle: rightTitle,
        rightTitleIcon: rightTitleIcon,
        rightSubtitle: rightSubtitle,
        rightParagraph: rightParagraph,
      );
    }
  }
}

class _ImmutableAlignmentSubListContent extends StatelessWidget {
  const _ImmutableAlignmentSubListContent({
    required this.hasLeftContent,
    required this.leftFlex,
    required this.leftOverline,
    required this.leftOverlineIcon,
    required this.leftTitle,
    required this.leftTitleIcon,
    required this.leftSubtitle,
    required this.leftParagraph,
    required this.hasRightContent,
    required this.rightFlex,
    required this.rightOverline,
    required this.rightOverlineIcon,
    required this.rightTitle,
    required this.rightTitleIcon,
    required this.rightSubtitle,
    required this.rightParagraph,
  });

  final bool hasLeftContent;
  final int leftFlex;
  final Widget? leftOverline;
  final Widget? leftOverlineIcon;
  final Widget? leftTitle;
  final Widget? leftTitleIcon;
  final Widget? leftSubtitle;
  final Widget? leftParagraph;
  final bool hasRightContent;
  final int rightFlex;
  final Widget? rightOverline;
  final Widget? rightOverlineIcon;
  final Widget? rightTitle;
  final Widget? rightTitleIcon;
  final Widget? rightSubtitle;
  final Widget? rightParagraph;

  bool get hasOverline {
    return leftOverline != null || //
        leftOverlineIcon != null ||
        rightOverline != null ||
        rightOverlineIcon != null;
  }

  bool get hasTitle {
    return leftTitle != null || //
        leftTitleIcon != null ||
        rightTitle != null ||
        rightTitleIcon != null;
  }

  bool get hasSubtitle => leftSubtitle != null || rightSubtitle != null;

  bool get hasParagraph => leftParagraph != null || rightParagraph != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasOverline)
          _ImmutableAlignmentSubListItemRow(
            hasLeftContent: hasLeftContent,
            leftFlex: leftFlex,
            leftSubListContent: _OverlineContent(
              textDirection: TextDirection.ltr,
              overline: leftOverline,
              overlineIcon: leftOverlineIcon,
            ),
            hasRightContent: hasRightContent,
            rightFlex: rightFlex,
            rightSubListContent: _OverlineContent(
              textDirection: TextDirection.rtl,
              overline: rightOverline,
              overlineIcon: rightOverlineIcon,
            ),
          ),
        if (hasTitle)
          _ImmutableAlignmentSubListItemRow(
            hasLeftContent: hasLeftContent,
            leftFlex: leftFlex,
            leftSubListContent: _TitleContent(
              textDirection: TextDirection.ltr,
              title: leftTitle,
              titleIcon: leftTitleIcon,
            ),
            hasRightContent: hasRightContent,
            rightFlex: rightFlex,
            rightSubListContent: _TitleContent(
              textDirection: TextDirection.rtl,
              title: rightTitle,
              titleIcon: rightTitleIcon,
            ),
          ),
        if (hasSubtitle)
          _ImmutableAlignmentSubListItemRow(
            hasLeftContent: hasLeftContent,
            leftFlex: leftFlex,
            leftSubListContent: leftSubtitle != null
                ? _SubtitleContent(
                    textDirection: TextDirection.ltr,
                    subtitle: leftSubtitle!,
                  )
                : null,
            hasRightContent: hasRightContent,
            rightFlex: rightFlex,
            rightSubListContent: rightSubtitle != null
                ? _SubtitleContent(
                    textDirection: TextDirection.rtl,
                    subtitle: rightSubtitle!,
                  )
                : null,
          ),
        if (hasParagraph) OdinGap.xxxs,
        if (hasParagraph)
          _ImmutableAlignmentSubListItemRow(
            hasLeftContent: hasLeftContent,
            leftFlex: leftFlex,
            leftSubListContent: leftParagraph != null
                ? _ParagraphContent(
                    textDirection: TextDirection.ltr,
                    paragraph: leftParagraph!,
                  )
                : null,
            hasRightContent: hasRightContent,
            rightFlex: rightFlex,
            rightSubListContent: rightParagraph != null
                ? _ParagraphContent(
                    textDirection: TextDirection.rtl,
                    paragraph: rightParagraph!,
                  )
                : null,
          ),
      ],
    );
  }
}

class _ImmutableAlignmentSubListItemRow extends StatelessWidget {
  const _ImmutableAlignmentSubListItemRow({
    required this.rightFlex,
    required this.leftFlex,
    required this.leftSubListContent,
    required this.rightSubListContent,
    required this.hasLeftContent,
    required this.hasRightContent,
  });

  final Widget? leftSubListContent;
  final Widget? rightSubListContent;
  final bool hasLeftContent;
  final bool hasRightContent;
  final int rightFlex;
  final int leftFlex;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: OdinPaddingValue.xxs,
      children: [
        if (hasLeftContent)
          Flexible(
            flex: leftFlex,
            child: leftSubListContent ?? const SizedBox.shrink(),
          ),
        if (hasRightContent)
          Flexible(
            flex: rightFlex,
            child: rightSubListContent ?? const SizedBox.shrink(),
          ),
      ],
    );
  }
}

final class _MutableAlignmentSubListContent extends StatelessWidget {
  const _MutableAlignmentSubListContent({
    required this.hasLeftContent,
    required this.leftFlex,
    required this.leftOverline,
    required this.leftOverlineIcon,
    required this.leftTitle,
    required this.leftTitleIcon,
    required this.leftSubtitle,
    required this.leftParagraph,
    required this.hasAnythingAfterLeftContent,
    required this.slot,
    required this.slotFlex,
    required this.hasAnythingAfterSlot,
    required this.hasNothingBeforeRightContent,
    required this.hasRightContent,
    required this.rightFlex,
    required this.rightOverline,
    required this.rightOverlineIcon,
    required this.rightTitle,
    required this.rightTitleIcon,
    required this.rightSubtitle,
    required this.rightParagraph,
  });

  final bool hasLeftContent;
  final int leftFlex;
  final Widget? leftOverline;
  final Widget? leftOverlineIcon;
  final Widget? leftTitle;
  final Widget? leftTitleIcon;
  final Widget? leftSubtitle;
  final Widget? leftParagraph;
  final bool hasAnythingAfterLeftContent;
  final Widget? slot;
  final int slotFlex;
  final bool hasAnythingAfterSlot;
  final bool hasNothingBeforeRightContent;
  final bool hasRightContent;
  final int rightFlex;
  final Widget? rightOverline;
  final Widget? rightOverlineIcon;
  final Widget? rightTitle;
  final Widget? rightTitleIcon;
  final Widget? rightSubtitle;
  final Widget? rightParagraph;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (hasLeftContent)
          Flexible(
            flex: leftFlex,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (leftOverline != null || leftOverlineIcon != null)
                  _OverlineContent(
                    textDirection: TextDirection.ltr,
                    overline: leftOverline,
                    overlineIcon: leftOverlineIcon,
                  ),
                if (leftTitle != null || leftTitleIcon != null)
                  _TitleContent(
                    textDirection: TextDirection.ltr,
                    title: leftTitle,
                    titleIcon: leftTitleIcon,
                  ),
                if (leftSubtitle case final subtitle?)
                  _SubtitleContent(
                    textDirection: TextDirection.ltr,
                    subtitle: subtitle,
                  ),
                if (leftParagraph case final paragraph?)
                  _ParagraphContent(
                    textDirection: TextDirection.ltr,
                    paragraph: paragraph,
                  ),
              ],
            ),
          ),
        if (hasAnythingAfterLeftContent) OdinGap.xxs,
        if (slot case final slot?)
          Flexible(
            flex: slotFlex,
            child: slot,
          ),
        if (hasAnythingAfterSlot) OdinGap.xxs,
        if (hasNothingBeforeRightContent) const Spacer(),
        if (hasRightContent)
          Flexible(
            flex: rightFlex,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (rightOverline != null || rightOverlineIcon != null)
                  _OverlineContent(
                    textDirection: TextDirection.rtl,
                    overline: rightOverline,
                    overlineIcon: rightOverlineIcon,
                  ),
                if (rightTitle != null || rightTitleIcon != null)
                  _TitleContent(
                    textDirection: TextDirection.rtl,
                    title: rightTitle,
                    titleIcon: rightTitleIcon,
                  ),
                if (rightSubtitle case final subtitle?)
                  _SubtitleContent(
                    textDirection: TextDirection.rtl,
                    subtitle: subtitle,
                  ),
                if (rightParagraph case final paragraph?)
                  _ParagraphContent(
                    textDirection: TextDirection.rtl,
                    paragraph: paragraph,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

final class _ParagraphContent extends StatelessWidget {
  const _ParagraphContent({
    required this.textDirection,
    required this.paragraph,
  });

  final TextDirection textDirection;
  final Widget paragraph;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final appColorScheme = theme.appColorScheme;
    final typography = theme.typography;

    return DefaultTextStyle(
      textAlign: switch (textDirection) {
        TextDirection.rtl => TextAlign.right,
        TextDirection.ltr => TextAlign.left,
      },
      style: typography.bodySmall.copyWith(
        color: appColorScheme.onColorEmphasisMedium,
      ),
      child: paragraph,
    );
  }
}

final class _SubtitleContent extends StatelessWidget {
  const _SubtitleContent({
    required this.textDirection,
    required this.subtitle,
  });

  final TextDirection textDirection;
  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final appColorScheme = theme.appColorScheme;
    final typography = theme.typography;

    return DefaultTextStyle(
      textAlign: switch (textDirection) {
        TextDirection.rtl => TextAlign.right,
        TextDirection.ltr => TextAlign.left,
      },
      style: typography.bodySmall.copyWith(
        color: appColorScheme.onColorEmphasisMedium,
      ),
      child: subtitle,
    );
  }
}

final class _TitleContent extends StatelessWidget {
  const _TitleContent({
    required this.textDirection,
    required this.title,
    required this.titleIcon,
  });

  final TextDirection textDirection;
  final Widget? title;
  final Widget? titleIcon;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colorScheme = theme.appColorScheme;
    final typography = theme.typography;

    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: textDirection,
      spacing: OdinGapValue.xxxs,
      children: [
        if (title case final title?)
          Flexible(
            child: DefaultTextStyle(
              style: typography.bodyBase.copyWith(
                color: colorScheme.onColorEmphasisHigh,
              ),
              textAlign: switch (textDirection) {
                TextDirection.rtl => TextAlign.right,
                TextDirection.ltr => TextAlign.left,
              },
              textWidthBasis: TextWidthBasis.longestLine,
              child: title,
            ),
          ),
        if (titleIcon case final titleIcon?)
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.textScalerOf(context).scale(typography.bodyBase.verticalSpacing),
            ),
            child: OdinIconContainerTheme(
              data: OdinIconContainerTheme.of(context).copyWith(
                size: OdinIconContainerSize.size16,
                foregroundColor: colorScheme.onColorEmphasisHigh,
              ),
              child: titleIcon,
            ),
          ),
      ],
    );
  }
}

final class _OverlineContent extends StatelessWidget {
  const _OverlineContent({
    required this.textDirection,
    required this.overline,
    required this.overlineIcon,
  });

  final TextDirection textDirection;
  final Widget? overline;
  final Widget? overlineIcon;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final appColorScheme = theme.appColorScheme;
    final typography = theme.typography;

    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: textDirection,
      spacing: OdinGapValue.xxxs,
      children: [
        if (overline case final overline?)
          Flexible(
            child: DefaultTextStyle(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: typography.bodySmall.copyWith(
                color: appColorScheme.onColorEmphasisMedium,
              ),
              textAlign: switch (textDirection) {
                TextDirection.rtl => TextAlign.right,
                TextDirection.ltr => TextAlign.left,
              },
              textWidthBasis: TextWidthBasis.longestLine,
              child: overline,
            ),
          ),
        if (overlineIcon case final overlineIcon?)
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.textScalerOf(context).scale(typography.bodySmall.verticalSpacing),
            ),
            child: OdinIconContainerTheme(
              data: OdinIconContainerTheme.of(context).copyWith(
                size: OdinIconContainerSize.size16,
                foregroundColor: appColorScheme.onColorEmphasisMedium,
              ),
              child: overlineIcon,
            ),
          ),
      ],
    );
  }
}

final class OdinSubListDetail extends StatelessWidget {
  const OdinSubListDetail({
    super.key,
    this.leftBadges,
    this.rightBadges,
    this.leftInline,
    this.rightInline,
    this.leftLinkSettings,
    this.rightLinkSettings,
    this.leftButtonSettings,
    this.rightButtonSettings,
    this.leftSecondButtonSettings,
    this.rightSecondButtonSettings,
    this.leftFlex = 1,
    this.rightFlex = 1,
  });

  final OdinSubListBadges? leftBadges;
  final OdinSubListBadges? rightBadges;
  final OdinActionSettings<VoidCallback>? leftLinkSettings;
  final OdinActionSettings<VoidCallback>? rightLinkSettings;
  final OdinNotificationInline? leftInline;
  final OdinNotificationInline? rightInline;
  final OdinActionSettings<VoidCallback>? leftButtonSettings;
  final OdinActionSettings<VoidCallback>? rightButtonSettings;
  final OdinActionSettings<VoidCallback>? leftSecondButtonSettings;
  final OdinActionSettings<VoidCallback>? rightSecondButtonSettings;
  final int leftFlex;
  final int rightFlex;

  bool get hasLeftDetail {
    final leftBadges = this.leftBadges;

    return leftBadges != null && leftBadges.hasContent || //
        leftInline != null ||
        leftLinkSettings != null ||
        leftButtonSettings != null ||
        leftSecondButtonSettings != null;
  }

  bool get hasRightDetail {
    final rightBadges = this.rightBadges;

    return rightBadges != null && rightBadges.hasContent || //
        rightInline != null ||
        rightLinkSettings != null ||
        rightButtonSettings != null ||
        rightSecondButtonSettings != null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: OdinGapValue.xxs,
      children: [
        if (hasLeftDetail)
          Expanded(
            flex: leftFlex,
            child: _OdinSubListDetail(
              badges: leftBadges,
              inline: leftInline,
              link: leftLinkSettings,
              buttonSettings: leftButtonSettings,
              secondButtonSettings: leftSecondButtonSettings,
            ),
          ),
        if (hasRightDetail)
          Expanded(
            flex: rightFlex,
            child: _OdinSubListDetail(
              badges: rightBadges,
              inline: rightInline,
              link: rightLinkSettings,
              buttonSettings: rightButtonSettings,
              secondButtonSettings: rightSecondButtonSettings,
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ),
      ],
    );
  }
}

class _OdinSubListDetail extends StatelessWidget {
  const _OdinSubListDetail({
    this.badges,
    this.link,
    this.inline,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.buttonSettings,
    this.secondButtonSettings,
  });

  final OdinSubListBadges? badges;
  final OdinActionSettings<VoidCallback>? link;
  final OdinNotificationInline? inline;
  final CrossAxisAlignment crossAxisAlignment;
  final OdinActionSettings<VoidCallback>? buttonSettings;
  final OdinActionSettings<VoidCallback>? secondButtonSettings;

  bool get hasButton => buttonSettings != null || secondButtonSettings != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (badges case final badges? when badges.hasContent) ...[
          OdinGap.xxs,
          badges,
        ],
        if (link case final linkSettings?)
          Padding(
            padding: const EdgeInsets.only(top: OdinPaddingValue.xxs),
            child: OdinLink.fromActionSettings(
              actionSettings: linkSettings,
              isUnderline: true,
              size: OdinLinkSize.small,
            ),
          ),
        if (inline case final inline?)
          Padding(
            padding: const EdgeInsets.only(top: OdinPaddingValue.xxs),
            child: inline,
          ),
        if (hasButton)
          Padding(
            padding: const EdgeInsets.only(top: OdinPaddingValue.xxs),
            child: Row(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (buttonSettings case final buttonSettings?)
                  Flexible(
                    child: OdinButton.fromActionSettings(
                      actionSettings: buttonSettings,
                      kind: OdinButtonKind.primary,
                      size: OdinButtonSize.compact,
                    ),
                  ),
                if (secondButtonSettings case final secondButtonSettings?) ...[
                  if (buttonSettings != null) OdinGap.xxs,
                  Flexible(
                    child: OdinButton.fromActionSettings(
                      actionSettings: secondButtonSettings,
                      kind: OdinButtonKind.line,
                      size: OdinButtonSize.compact,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

enum OdinSubListButtonKind { primary, inline, link }

final class OdinSubListButton extends StatelessWidget {
  const OdinSubListButton({
    required this.actionSettings,
    super.key,
    this.kind = OdinSubListButtonKind.primary,
  });

  final OdinSubListButtonKind kind;
  final OdinActionSettings<VoidCallback> actionSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: OdinPaddingValue.sm),
      child: switch (kind) {
        OdinSubListButtonKind.primary => OdinButton.fromActionSettings(
          actionSettings: actionSettings,
          size: OdinButtonSize.compact,
        ),
        OdinSubListButtonKind.inline => OdinButtonInline.fromActionSettings(
          actionSettings: actionSettings,
          isSelected: false,
        ),
        OdinSubListButtonKind.link => OdinLink.fromActionSettings(
          actionSettings: actionSettings.copyWith(rightIcon: actionSettings.rightIcon ?? OdinIcons.chevronRight),
          size: OdinLinkSize.large,
        ),
      },
    );
  }
}

sealed class OdinSubListImageKind {
  const OdinSubListImageKind();

  const factory OdinSubListImageKind.avatar({required OdinAvatarWidget avatar}) = OdinSubListImageKindAvatar;

  const factory OdinSubListImageKind.icon({required OdinIconContainer iconContainer}) = OdinSubListImageKindIcon;

  const factory OdinSubListImageKind.iconCircle({
    required OdinIconContainerCircle iconContainerCircle,
  }) = OdinSubListImageKindIconCircle;

  const factory OdinSubListImageKind.image({required OdinImageContainer imageContainer}) = OdinSubListImageKindImage;

  const factory OdinSubListImageKind.imageGroup({required OdinImageGroup imageGroup}) = OdinSubListImageKindImageGroup;
}

final class OdinSubListImageKindAvatar extends OdinSubListImageKind {
  const OdinSubListImageKindAvatar({required this.avatar});

  final OdinAvatarWidget avatar;
}

final class OdinSubListImageKindIcon extends OdinSubListImageKind {
  const OdinSubListImageKindIcon({required this.iconContainer});

  final OdinIconContainer iconContainer;
}

final class OdinSubListImageKindIconCircle extends OdinSubListImageKind {
  const OdinSubListImageKindIconCircle({required this.iconContainerCircle});

  final OdinIconContainerCircle iconContainerCircle;
}

final class OdinSubListImageKindImage extends OdinSubListImageKind {
  const OdinSubListImageKindImage({required this.imageContainer});

  final OdinImageContainer imageContainer;
}

final class OdinSubListImageKindImageGroup extends OdinSubListImageKind {
  const OdinSubListImageKindImageGroup({required this.imageGroup});

  final OdinImageGroup imageGroup;
}

sealed class OdinSubListActionKind {
  const OdinSubListActionKind();

  factory OdinSubListActionKind.icon({
    OdinIconContainer rightIconContainer = const OdinIconContainer(icon: OdinIcons.chevronRight),
    OdinIconContainer? leftIconContainer,
    VoidCallback? onPress,
  }) {
    return OdinSubListActionKindIcon(
      rightIconContainer: rightIconContainer,
      leftIconContainer: leftIconContainer,
      onPress: onPress,
    );
  }

  const factory OdinSubListActionKind.link({
    required OdinLink link,
  }) = OdinSubListActionKindLink;

  const factory OdinSubListActionKind.button({
    required OdinButton button,
  }) = OdinSubListActionKindButton;

  const factory OdinSubListActionKind.checkbox({
    required OdinCheckbox checkbox,
  }) = OdinSubListActionKindCheckbox;

  const factory OdinSubListActionKind.switcher({
    required OdinSwitcher switcher,
  }) = OdinSubListActionKindSwitcher;

  const factory OdinSubListActionKind.radioButton({
    required OdinRadioButton<Object?> radioButton,
  }) = OdinSubListActionKindRadioButton;
}

final class OdinSubListActionKindIcon extends OdinSubListActionKind {
  const OdinSubListActionKindIcon({
    required this.rightIconContainer,
    this.leftIconContainer,
    this.onPress,
  });

  final OdinIconContainer? leftIconContainer;
  final OdinIconContainer rightIconContainer;
  final VoidCallback? onPress;
}

final class OdinSubListActionKindLink extends OdinSubListActionKind {
  const OdinSubListActionKindLink({required this.link});

  final OdinLink link;
}

final class OdinSubListActionKindButton extends OdinSubListActionKind {
  const OdinSubListActionKindButton({required this.button});

  final OdinButton button;
}

final class OdinSubListActionKindCheckbox extends OdinSubListActionKind {
  const OdinSubListActionKindCheckbox({required this.checkbox});

  final OdinCheckbox checkbox;
}

final class OdinSubListActionKindSwitcher extends OdinSubListActionKind {
  const OdinSubListActionKindSwitcher({required this.switcher});

  final OdinSwitcher switcher;
}

final class OdinSubListActionKindRadioButton extends OdinSubListActionKind {
  const OdinSubListActionKindRadioButton({required this.radioButton});

  final OdinRadioButton<Object?> radioButton;
}

final class OdinSubListAction extends StatelessWidget {
  const OdinSubListAction({
    required this.kind,
    super.key,
  });

  final OdinSubListActionKind kind;

  @override
  Widget build(BuildContext context) {
    return switch (kind) {
      OdinSubListActionKindIcon(
        leftIconContainer: final leftIconContainer,
        rightIconContainer: final rightIconContainer,
        :final onPress,
      ) =>
        OdinIconContainerTheme(
          data: OdinIconContainerTheme.of(context).copyWith(size: OdinIconContainerSize.size24),
          child: OdinInkWell.outsideResponse(
            onTap: onPress,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leftIconContainer case final leftIcon?) leftIcon,
                rightIconContainer,
              ],
            ),
          ),
        ),
      OdinSubListActionKindLink(:final link) => link,
      OdinSubListActionKindButton(:final button) => button,
      OdinSubListActionKindCheckbox(:final checkbox) => checkbox,
      OdinSubListActionKindRadioButton(:final radioButton) => radioButton,
      OdinSubListActionKindSwitcher(:final switcher) => Transform.translate(
        offset: const Offset(kSwitcherHorizontalExtraSpacing, 0.0),
        child: switcher,
      ),
    };
  }
}

enum OdinListContentSize {
  compact,
  normal,
}

final class OdinListContent extends StatelessWidget {
  OdinListContent.twoColumns({
    required Widget leftTitle,
    required Widget rightTitle,
    super.key,
    OdinListContentSize size = OdinListContentSize.normal,
    Widget? leftSubtitle,
    Widget? rightSubtitle,
    bool hasDivider = false,
    bool isFullWidth = false,
    int leftFlex = 1,
    int rightFlex = 1,
    OdinInformativeIcon? informativeIcon,
    OdinIconContainer? rightIcon,
    VoidCallback? onPress,
  }) : child = _OdinListContentTwoColumns(
         size: size,
         leftTitle: leftTitle,
         leftSubtitle: leftSubtitle,
         rightTitle: rightTitle,
         rightSubtitle: rightSubtitle,
         hasDivider: hasDivider,
         isFullWidth: isFullWidth,
         leftFlex: leftFlex,
         rightFlex: rightFlex,
         informativeIcon: informativeIcon,
         rightIcon: rightIcon,
         onPress: onPress,
       );

  OdinListContent.copyList({
    required OdinSubListContentItem leftContentItem,
    required OdinSubListContentItem rightContentItem,
    super.key,
    int leftFlex = 1,
    int rightFlex = 1,
    VoidCallback? onPress,
  }) : child = _OdinListContentCopyList(
         leftContentItem: leftContentItem,
         rightContentItem: rightContentItem,
         leftFlex: leftFlex,
         rightFlex: rightFlex,
         onPress: onPress,
       );

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

final class _OdinListContentTwoColumns extends StatelessWidget {
  const _OdinListContentTwoColumns({
    required this.leftTitle,
    required this.rightTitle,
    this.size = OdinListContentSize.normal,
    this.leftSubtitle,
    this.rightSubtitle,
    this.hasDivider = false,
    this.isFullWidth = false,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.informativeIcon,
    this.rightIcon,
    this.onPress,
  });

  final OdinListContentSize size;
  final Widget leftTitle;
  final Widget rightTitle;
  final Widget? leftSubtitle;
  final Widget? rightSubtitle;
  final bool hasDivider;
  final bool isFullWidth;
  final int leftFlex;
  final int rightFlex;
  final OdinInformativeIcon? informativeIcon;
  final OdinIconContainer? rightIcon;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final appColorScheme = theme.appColorScheme;
    final typography = theme.typography;

    final titleTypography = switch (size) {
      OdinListContentSize.compact => typography.bodySmall,
      OdinListContentSize.normal => typography.bodyBase,
    };

    final subtitleTypography = switch (size) {
      OdinListContentSize.compact => typography.captionBase,
      OdinListContentSize.normal => typography.bodySmall,
    };

    return Padding(
      padding: isFullWidth
          ? const EdgeInsets.symmetric(horizontal: OdinPaddingValue.sm) //
          : EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OdinInkWell.outsideResponse(
            onTap: onPress,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: OdinGapValue.xs,
                  children: [
                    Flexible(
                      flex: leftFlex,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: OdinGapValue.xxxs,
                        children: [
                          Flexible(
                            child: DefaultTextStyle(
                              style: titleTypography.copyWith(color: appColorScheme.onColorEmphasisMedium),
                              textWidthBasis: TextWidthBasis.longestLine,
                              child: leftTitle,
                            ),
                          ),
                          if (informativeIcon case final informativeIcon?) //
                            OdinIconContainerTheme(
                              data: OdinIconContainerTheme.of(context).copyWith(
                                foregroundColor: appColorScheme.onColorEmphasisMedium,
                              ),
                              child: informativeIcon,
                            ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: rightFlex,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: DefaultTextStyle(
                              style: titleTypography.copyWith(color: appColorScheme.onColorEmphasisHigh),
                              textAlign: TextAlign.right,
                              child: rightTitle,
                            ),
                          ),
                          if (rightIcon case final rightIcon?) ...[
                            OdinGap.xxxs,
                            OdinIconContainerTheme(
                              data: OdinIconContainerTheme.of(context).copyWith(
                                foregroundColor: appColorScheme.onColorEmphasisMedium,
                                size: OdinIconContainerSize.size16,
                              ),
                              child: rightIcon,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: leftSubtitle == null
                      ? (MainAxisAlignment.end) //
                      : MainAxisAlignment.spaceBetween,
                  spacing: OdinGapValue.xxs,
                  children: [
                    if (leftSubtitle case final leftSubtitle?)
                      Flexible(
                        flex: leftFlex,
                        child: DefaultTextStyle(
                          style: subtitleTypography.copyWith(color: appColorScheme.onColorEmphasisMedium),
                          child: leftSubtitle,
                        ),
                      ),
                    if (rightSubtitle case final rightSubtitle?)
                      Flexible(
                        flex: rightFlex,
                        child: DefaultTextStyle(
                          style: subtitleTypography.copyWith(color: appColorScheme.onColorEmphasisMedium),
                          textAlign: TextAlign.right,
                          child: rightSubtitle,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (hasDivider) ...[
            switch (size) {
              OdinListContentSize.compact => OdinGap.xxs,
              OdinListContentSize.normal => OdinGap.xs,
            },
            OdinGlobalDivider.sectionThin,
          ],
        ],
      ),
    );
  }
}

final class _OdinListContentCopyList extends StatelessWidget {
  const _OdinListContentCopyList({
    required this.leftContentItem,
    required this.rightContentItem,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.onPress,
  });

  final OdinSubListContentItem leftContentItem;
  final OdinSubListContentItem rightContentItem;
  final int leftFlex;
  final int rightFlex;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OdinGap.xxs,
        OdinInkWell.outsideResponse(
          onTap: onPress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: leftFlex,
                child: leftContentItem,
              ),
              OdinGap.xs,
              Flexible(
                flex: rightFlex,
                child: rightContentItem,
              ),
            ],
          ),
        ),
        OdinGap.xxs,
        OdinGlobalDivider.sectionThin,
      ],
    );
  }
}

final class OdinTimelineList extends StatelessWidget {
  const OdinTimelineList({
    required this.imageKind,
    required this.value,
    super.key,
    this.label,
    this.transactionDescription,
    this.badge,
    this.category,
    this.inlineButton1,
    this.inlineButton2,
    this.notificationInline,
    this.notificationButtonActionSettings,
    this.isFullWidth = false,
    this.onPress,
  });

  final OdinSubTimelineListImageKind imageKind;
  final Widget? label;
  final Widget value;
  final Widget? transactionDescription;
  final OdinBadgeWidget? badge;
  final Widget? category;
  final OdinButtonInline? inlineButton1;
  final OdinButtonInline? inlineButton2;
  final OdinNotificationInline? notificationInline;
  final OdinActionSettings<VoidCallback>? notificationButtonActionSettings;
  final bool isFullWidth;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final appColorScheme = theme.appColorScheme;
    final typography = theme.typography;

    final image = switch (imageKind) {
      OdinSubTimelineListImageKindAvatar(:final avatar) => OdinAvatarTheme(
        data: OdinAvatarTheme.of(context).copyWith(
          hasOutline: true,
          size: OdinAvatarSize.size32,
        ),
        child: avatar,
      ),
      OdinSubTimelineListImageKindIconCircle(:final iconContainerCircle) => OdinIconContainerTheme(
        data: OdinIconContainerTheme.of(context).copyWith(
          circleSize: OdinIconContainerCircleSize.size32,
        ),
        child: iconContainerCircle,
      ),
      OdinSubTimelineListImageKindImage(:final imageContainer) => OdinImageContainerTheme(
        data: OdinImageContainerTheme.of(context).copyWith(
          size: OdinImageContainerSize.size32,
          shape: OdinImageContainerShape.rounded,
        ),
        child: imageContainer,
      ),
      OdinSubTimelineListImageKindImageGroup(:final imageGroup) => OdinImageGroupTheme(
        data: OdinImageGroupThemeData(size: OdinImageGroupSize.small),
        child: imageGroup,
      ),
    };

    final hasValuePadding =
        label == null && //
        transactionDescription == null &&
        badge == null &&
        category == null;

    final hasInlineButtons = inlineButton1 != null || inlineButton2 != null;

    final inlineButtonsTopPadding =
        OdinGapValue.xs - //
        (hasValuePadding ? OdinGapValue.xxxs : 0.0);
    final notificationInlineTopPadding =
        OdinGapValue.sm - //
        (hasValuePadding && !hasInlineButtons ? OdinGapValue.xxxs : 0.0);
    final notificationButtonTopPadding = (notificationInline == null ? OdinGapValue.sm : OdinGapValue.xs) - (hasValuePadding && !hasInlineButtons && notificationInline == null ? OdinGapValue.xxxs : 0.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OdinInkWell.outsideResponse(
          horizontalSplashOverflow: OdinGapValue.sm,
          onTap: onPress,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isFullWidth) OdinGap.sm,
              image,
              OdinGap.xs,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (label case final label?)
                      Padding(
                        padding: const EdgeInsets.only(bottom: OdinPaddingValue.xxxs),
                        child: DefaultTextStyle(
                          style: typography.bodySmall.copyWith(color: appColorScheme.onColorEmphasisMedium),
                          child: label,
                        ),
                      ),
                    DefaultTextStyle(
                      style: typography.bodyBase.copyWith(color: appColorScheme.onColorEmphasisHigh),
                      child: hasValuePadding
                          ? ConstrainedBox(
                              constraints: const BoxConstraints(minHeight: 32.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: value,
                              ),
                            )
                          : value,
                    ),
                    if (transactionDescription case final transactionDescription?)
                      Padding(
                        padding: const EdgeInsets.only(top: OdinPaddingValue.xxxs),
                        child: DefaultTextStyle(
                          style: typography.captionBase.copyWith(color: appColorScheme.onColorEmphasisMedium),
                          child: transactionDescription,
                        ),
                      ),
                    if (badge case final badge?)
                      Padding(
                        padding: const EdgeInsets.only(top: OdinPaddingValue.xxs),
                        child: badge,
                      ),
                    if (category case final category?)
                      Padding(
                        padding: const EdgeInsets.only(top: OdinPaddingValue.xxxs),
                        child: DefaultTextStyle(
                          style: typography.captionBase.copyWith(color: appColorScheme.onColorEmphasisLow),
                          child: category,
                        ),
                      ),
                    if (hasInlineButtons)
                      Padding(
                        padding: EdgeInsets.only(top: inlineButtonsTopPadding),
                        child: Row(
                          children: [
                            if (inlineButton1 case final inlineButton1?) //
                              inlineButton1,
                            if (inlineButton1 != null && inlineButton2 != null) //
                              OdinGap.xs,
                            if (inlineButton2 case final inlineButton2?) //
                              inlineButton2,
                          ],
                        ),
                      ),
                    if (notificationInline case final notificationInline?) //
                      Padding(
                        padding: EdgeInsets.only(top: notificationInlineTopPadding),
                        child: notificationInline,
                      ),
                    if (notificationButtonActionSettings case final notificationButtonActionSettings?) //
                      Padding(
                        padding: EdgeInsets.only(top: notificationButtonTopPadding),
                        child: OdinButton.fromActionSettings(
                          actionSettings: notificationButtonActionSettings,
                          kind: OdinButtonKind.line,
                          size: OdinButtonSize.compact,
                        ),
                      ),
                  ],
                ),
              ),
              if (isFullWidth) OdinGap.sm,
            ],
          ),
        ),
      ],
    );
  }
}

sealed class OdinSubTimelineListImageKind {
  const OdinSubTimelineListImageKind();

  const factory OdinSubTimelineListImageKind.avatar({required OdinAvatarWidget avatar}) = OdinSubTimelineListImageKindAvatar;

  const factory OdinSubTimelineListImageKind.iconCircle({required OdinIconContainerCircle iconContainerCircle}) = OdinSubTimelineListImageKindIconCircle;

  const factory OdinSubTimelineListImageKind.image({required OdinImageContainer imageContainer}) = OdinSubTimelineListImageKindImage;

  const factory OdinSubTimelineListImageKind.imageGroup({required OdinImageGroup imageGroup}) = OdinSubTimelineListImageKindImageGroup;
}

final class OdinSubTimelineListImageKindAvatar extends OdinSubTimelineListImageKind {
  const OdinSubTimelineListImageKindAvatar({required this.avatar});

  final OdinAvatarWidget avatar;
}

final class OdinSubTimelineListImageKindIconCircle extends OdinSubTimelineListImageKind {
  const OdinSubTimelineListImageKindIconCircle({required this.iconContainerCircle});

  final OdinIconContainerCircle iconContainerCircle;
}

final class OdinSubTimelineListImageKindImage extends OdinSubTimelineListImageKind {
  const OdinSubTimelineListImageKindImage({required this.imageContainer});

  final OdinImageContainer imageContainer;
}

final class OdinSubTimelineListImageKindImageGroup extends OdinSubTimelineListImageKind {
  const OdinSubTimelineListImageKindImageGroup({required this.imageGroup});

  final OdinImageGroup imageGroup;
}

enum _OdinSubListContentItemKind {
  info,
  value,
}

final class OdinSubListContentItem extends StatelessWidget {
  const OdinSubListContentItem.info({
    required this.label,
    super.key,
    OdinInformativeIcon? informativeIcon,
  }) : kind = _OdinSubListContentItemKind.info,
       trailing = informativeIcon;

  const OdinSubListContentItem.value({
    required this.label,
    super.key,
    OdinIconContainer? icon,
  }) : kind = _OdinSubListContentItemKind.value,
       trailing = icon;

  final _OdinSubListContentItemKind kind;
  final Widget label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final appColorScheme = theme.appColorScheme;
    final typography = theme.typography;

    final foregroundColor = switch (kind) {
      _OdinSubListContentItemKind.info => appColorScheme.onColorEmphasisMedium,
      _OdinSubListContentItemKind.value => appColorScheme.onColorEmphasisHigh,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextStyle(
          style: typography.bodySmall.copyWith(color: foregroundColor),
          child: label,
        ),
        if (trailing case final trailing?) ...[
          OdinGap.xxxs,
          OdinIconContainerTheme(
            data: OdinIconContainerTheme.of(context).copyWith(
              size: OdinIconContainerSize.size16,
              foregroundColor: foregroundColor,
            ),
            child: trailing,
          ),
        ],
      ],
    );
  }
}
