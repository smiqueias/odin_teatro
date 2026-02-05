import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';
import 'package:intersperse/intersperse.dart';

typedef OdinSubCardBadges = OdinBadgesGroup;

const _kImageAspectRatio = 1.82;

final class OdinCard extends StatelessWidget {
  const OdinCard({
    super.key,
    this.image,
    this.progressBar,
    this.stripe,
    this.header,
    this.details,
    this.notification,
    this.footer,
    this.badges,
    this.hasDivider = true,
    this.backgroundColor,
    this.borderColor,
    this.borderStrokeWidth,
    this.borderDashedStyle,
    this.shouldFillHeight = false,
    this.onPress,
  });

  final Widget? image;
  final OdinGlobalProgressBar? progressBar;
  final OdinSubCardStripe? stripe;
  final OdinSubCardHeader? header;
  final List<OdinSubCardDetail>? details;
  final OdinNotificationInline? notification;
  final OdinSubCardFooter? footer;
  final OdinSubCardBadges? badges;
  final bool hasDivider;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderStrokeWidth;
  final OdinDashedBorderStyle? borderDashedStyle;
  final bool shouldFillHeight;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final details = this.details;
    final hasDetails = details != null && details.isNotEmpty;
    final hasNotification = notification != null;

    final content = hasDetails || hasNotification
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: OdinGapValue.xs,
            children: [
              if (hasDetails) ...details,
              if (notification case final notification?) //
                notification,
            ],
          )
        : null;

    return _OdinCardBase(
      image: image,
      progressBar: progressBar,
      stripe: stripe,
      header: header,
      content: content,
      footer: footer,
      badges: badges,
      hasTopDivider: hasDivider,
      hasFooterDivider: false,
      shouldAddSpacingBeforeFooter: false,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderStrokeWidth: borderStrokeWidth,
      borderDashedStyle: borderDashedStyle,
      shouldFillHeight: shouldFillHeight,
      onPress: onPress,
    );
  }
}

final class OdinCardExpandController {
  _OdinCardExpandState? _state;

  bool get isExpanded => _state?._isExpanded ?? false;

  void expand() {
    if (!isExpanded) {
      _state?.setExpanded(value: true);
    }
  }

  void collapse() {
    if (isExpanded) {
      _state?.setExpanded(value: false);
    }
  }
}

final class OdinCardExpand extends StatefulWidget {
  const OdinCardExpand({
    required Widget this.expansionRegion,
    super.key,
    this.image,
    this.progressBar,
    this.stripe,
    this.header,
    this.details,
    this.footer,
    this.badges,
    this.hasTopDivider = true,
    this.hasMiddleDivider = true,
    this.hasBottomDivider = true,
    this.backgroundColor,
    this.borderColor,
    this.borderStrokeWidth,
    this.borderDashedStyle,
    this.shouldFillHeight = false,
    this.onPress,
    this.isInitiallyExpanded = false,
    this.expandedExpansionLinkText = 'Retrair conteúdo',
    this.collapsedExpansionLinkText = 'Expandir conteúdo',
    this.controller,
    this.onExpansionChanged,
  }) : expansionRegionBuilder = null;

  const OdinCardExpand.builder({
    required WidgetBuilder this.expansionRegionBuilder,
    super.key,
    this.image,
    this.progressBar,
    this.stripe,
    this.header,
    this.details,
    this.footer,
    this.badges,
    this.hasTopDivider = true,
    this.hasMiddleDivider = true,
    this.hasBottomDivider = true,
    this.backgroundColor,
    this.borderColor,
    this.borderStrokeWidth,
    this.borderDashedStyle,
    this.shouldFillHeight = false,
    this.onPress,
    this.isInitiallyExpanded = false,
    this.expandedExpansionLinkText = 'Retrair conteúdo',
    this.collapsedExpansionLinkText = 'Expandir conteúdo',
    this.controller,
    this.onExpansionChanged,
  }) : expansionRegion = null;

  final Widget? image;
  final OdinGlobalProgressBar? progressBar;
  final OdinSubCardStripe? stripe;
  final OdinSubCardHeader? header;
  final List<OdinSubCardDetail>? details;
  final OdinSubCardFooter? footer;
  final OdinSubCardBadges? badges;
  final bool hasTopDivider;
  final bool hasMiddleDivider;
  final bool hasBottomDivider;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderStrokeWidth;
  final OdinDashedBorderStyle? borderDashedStyle;
  final bool shouldFillHeight;
  final VoidCallback? onPress;
  final bool isInitiallyExpanded;
  final String expandedExpansionLinkText;
  final String collapsedExpansionLinkText;
  final Widget? expansionRegion;
  final WidgetBuilder? expansionRegionBuilder;
  final OdinCardExpandController? controller;
  final ValueChanged<bool>? onExpansionChanged;

  @override
  State<OdinCardExpand> createState() => _OdinCardExpandState();
}

final class _OdinCardExpandState extends State<OdinCardExpand> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    widget.controller?._state = this;

    _isExpanded = widget.isInitiallyExpanded;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: _isExpanded ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant OdinCardExpand oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._state = null;
      widget.controller?._state = this;
    }
  }

  @override
  void dispose() {
    widget.controller?._state = null;

    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colorScheme = theme.appColorScheme;
    final typography = theme.typography;

    return _OdinCardBase(
      image: widget.image,
      progressBar: widget.progressBar,
      stripe: widget.stripe,
      header: widget.header,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.details case final details?) //
            Padding(
              padding: const EdgeInsets.only(bottom: OdinPaddingValue.xs),
              child: Column(
                children: (details as List<Widget>)
                    .intersperse(OdinGap.xs) //
                    .toList(growable: false),
              ),
            ),
          if (widget.hasMiddleDivider)
            const Padding(
              padding: EdgeInsets.only(bottom: OdinPaddingValue.xs),
              child: OdinGlobalDivider.sectionThin,
            ),
          OdinInkWell.outsideResponse(
            onTap: () => setExpanded(value: !_isExpanded),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _isExpanded
                        ? (widget.expandedExpansionLinkText) //
                        : widget.collapsedExpansionLinkText,
                    style: typography.labelSmall.copyWith(color: colorScheme.onColorEmphasisHigh),
                  ),
                ),
                OdinGap.xs,
                RotationTransition(
                  turns: _animationController.drive(
                    Tween<double>(begin: 0.0, end: 0.5).chain(
                      CurveTween(curve: Curves.easeIn),
                    ),
                  ),
                  child: const Icon(OdinIcons.chevronDown),
                ),
              ],
            ),
          ),
          if (widget.expansionRegionBuilder case final builder?)
            AnimatedAlignOpacity.builder(
              alignment: Alignment.topCenter,
              heightFactor: _isExpanded ? 1.0 : 0.0,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.only(top: OdinPaddingValue.xs),
                  child: builder(context),
                );
              },
            )
          else
            AnimatedAlignOpacity(
              alignment: Alignment.topCenter,
              heightFactor: _isExpanded ? 1.0 : 0.0,
              child: Padding(
                padding: const EdgeInsets.only(top: OdinPaddingValue.xs),
                child: widget.expansionRegion ?? const SizedBox(),
              ),
            ),
        ],
      ),
      footer: widget.footer,
      badges: widget.badges,
      hasTopDivider: widget.hasTopDivider,
      hasFooterDivider: widget.hasBottomDivider,
      shouldAddSpacingBeforeFooter: true,
      backgroundColor: widget.backgroundColor,
      borderColor: widget.borderColor,
      borderStrokeWidth: widget.borderStrokeWidth,
      borderDashedStyle: widget.borderDashedStyle,
      shouldFillHeight: widget.shouldFillHeight,
      onPress: widget.onPress,
    );
  }

  void setExpanded({required bool value}) {
    if (_isExpanded != value) {
      setState(() {
        _isExpanded = value;
      });

      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }

      widget.onExpansionChanged?.call(_isExpanded);
    }
  }
}

final class _OdinCardBase extends StatelessWidget {
  const _OdinCardBase({
    required this.hasTopDivider,
    required this.hasFooterDivider,
    required this.shouldAddSpacingBeforeFooter,
    required this.shouldFillHeight,
    this.image,
    this.progressBar,
    this.stripe,
    this.header,
    this.content,
    this.footer,
    this.badges,
    this.backgroundColor,
    this.borderColor,
    this.borderStrokeWidth,
    this.borderDashedStyle,
    this.onPress,
  });

  final Widget? image;
  final OdinGlobalProgressBar? progressBar;
  final OdinSubCardStripe? stripe;
  final OdinSubCardHeader? header;
  final Widget? content;
  final OdinSubCardFooter? footer;
  final OdinSubCardBadges? badges;
  final bool hasTopDivider;
  final bool hasFooterDivider;
  final bool shouldAddSpacingBeforeFooter;
  final bool shouldFillHeight;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderStrokeWidth;
  final OdinDashedBorderStyle? borderDashedStyle;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);

    final resolvedBorderColor = borderColor ?? theme.appColorScheme.outlineBase;
    final resolvedBorderStrokeWidth = borderStrokeWidth ?? theme.borderTheme.strokeThin;
    final resolvedBorderStyle = borderDashedStyle ?? const OdinBorderStyle.solid();

    final hasHeader = header?.hasContent() ?? false;
    final hasBadges = badges?.hasContent ?? false;
    final hasContent = content != null;
    final hasFooter = footer?.hasContent() ?? false;
    final shouldAddSpacingBeforeFooterDivider = hasHeader || hasTopDivider || hasBadges || hasContent;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.appColorScheme.actionNeutralEnabled,
        borderRadius: BorderRadius.circular(OdinGapValue.xxxs),
        border: OdinBorder.all(
          color: resolvedBorderColor,
          stroke: resolvedBorderStrokeWidth,
          style: resolvedBorderStyle,
        ),
      ),
      child: Material(
        color: kTransparentColor,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(OdinGapValue.xxxs + 2 * resolvedBorderStrokeWidth),
        child: OdinInkWell(
          onTap: onPress,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (image case final image?)
                Padding(
                  padding: EdgeInsets.only(
                    left: resolvedBorderStrokeWidth,
                    right: resolvedBorderStrokeWidth,
                    top: resolvedBorderStrokeWidth,
                  ),
                  child: AspectRatio(
                    aspectRatio: _kImageAspectRatio,
                    child: image,
                  ),
                ),
              if (progressBar case final progressBar?)
                OdinGlobalProgressBarTheme(
                  data: OdinGlobalProgressBarTheme.of(
                    context,
                  ).copyWith(kind: OdinGlobalProgressBarKind.squared),
                  child: progressBar,
                ),
              Flexible(
                flex: shouldFillHeight ? 1 : 0,
                child: Stack(
                  children: [
                    if (stripe case final stripe?) stripe,
                    Padding(
                      padding: const EdgeInsets.only(
                        left: OdinPaddingValue.sm,
                        right: OdinPaddingValue.sm,
                        top: OdinPaddingValue.sm,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: OdinGapValue.xs,
                        children: [
                          if (header case final header? when hasHeader) header,
                          if (hasTopDivider) OdinGlobalDivider.sectionThin,
                          if (badges case final badges? when hasBadges) badges,
                          if (content case final content?) content,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (footer case final footer? when hasFooter)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (shouldAddSpacingBeforeFooterDivider) OdinGap.xs,
                    if (hasFooterDivider) OdinGlobalDivider.sectionThin,
                    if (shouldAddSpacingBeforeFooter) OdinGap.xs,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: OdinPaddingValue.sm),
                      child: footer,
                    ),
                  ],
                ),
              OdinGap.sm,
            ],
          ),
        ),
      ),
    );
  }
}

class OdinSubCardStripe extends StatelessWidget {
  const OdinSubCardStripe({
    required this.color,
    super.key,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(OdinPaddingValue.xxxs),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: const SizedBox(width: double.infinity, height: 4.0),
      ),
    );
  }
}

enum OdinSubCardHeaderImagePosition {
  top,
  left,
}

final class OdinSubCardHeader extends StatelessWidget {
  const OdinSubCardHeader({
    super.key,
    this.leftOverline,
    this.leftTitle,
    this.leftCaption,
    this.leftFlex = 1,
    this.rightOverline,
    this.rightTitle,
    this.rightCaption,
    this.rightFlex = 1,
    this.cardCorner,
    this.cardImage,
    this.upperBadge,
    this.imagePosition = OdinSubCardHeaderImagePosition.left,
  });

  final Widget? leftOverline;
  final Widget? leftTitle;
  final Widget? leftCaption;
  final int leftFlex;
  final Widget? rightOverline;
  final Widget? rightTitle;
  final Widget? rightCaption;
  final int rightFlex;
  final OdinSubCardCorner? cardCorner;
  final OdinSubCardImage? cardImage;
  final OdinBadgeWidget? upperBadge;
  final OdinSubCardHeaderImagePosition imagePosition;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colors = theme.appColorScheme;

    final cardImage = this.cardImage;
    final hasTopImage = cardImage != null && imagePosition == OdinSubCardHeaderImagePosition.top;
    final hasLeftImage = cardImage != null && imagePosition == OdinSubCardHeaderImagePosition.left;
    final hasLeftTexts = leftOverline != null || leftTitle != null || leftCaption != null;
    final hasRightTexts = rightOverline != null || rightTitle != null || rightCaption != null;
    final hasCardCornerAfterTexts = !hasTopImage && cardCorner != null;
    final hasTextsRow = hasLeftImage || hasLeftTexts || hasRightTexts || hasCardCornerAfterTexts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: OdinGapValue.xs,
      children: [
        if (hasTopImage)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              cardImage,
              OdinGap.xs,
              if (cardCorner case final cardCorner?) cardCorner,
            ],
          ),
        if (upperBadge case final upperBadge?) //
          upperBadge,
        if (hasTextsRow)
          Row(
            children: [
              if (hasLeftImage) ...[
                cardImage,
                OdinGap.xxs,
              ],
              if (hasLeftTexts)
                Expanded(
                  flex: leftFlex,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (leftOverline case final leftOverline?)
                        DefaultTextStyle(
                          overflow: TextOverflow.ellipsis,
                          style: theme.typography.labelTiny.copyWith(
                            color: colors.onColorEmphasisLow,
                          ),
                          child: leftOverline,
                        ),
                      if (leftTitle case final leftTitle?)
                        DefaultTextStyle(
                          overflow: TextOverflow.ellipsis,
                          style: theme.typography.bodyBase.copyWith(
                            color: colors.onColorEmphasisHigh,
                          ),
                          child: leftTitle,
                        ),
                      if (leftCaption case final leftCaption?)
                        DefaultTextStyle(
                          overflow: TextOverflow.ellipsis,
                          style: theme.typography.captionBase.copyWith(
                            color: colors.onColorEmphasisLow,
                          ),
                          child: leftCaption,
                        ),
                    ],
                  ),
                ),
              if (hasLeftTexts && hasRightTexts) OdinGap.xs,
              if (!hasLeftTexts && !hasRightTexts) const Spacer(),
              if (hasRightTexts)
                Expanded(
                  flex: rightFlex,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (rightOverline case final rightOverline?)
                        DefaultTextStyle(
                          overflow: TextOverflow.ellipsis,
                          style: theme.typography.labelTiny.copyWith(
                            color: colors.onColorEmphasisLow,
                          ),
                          child: rightOverline,
                        ),
                      if (rightTitle case final rightTitle?)
                        DefaultTextStyle(
                          overflow: TextOverflow.ellipsis,
                          style: theme.typography.bodyBase.copyWith(
                            color: colors.onColorEmphasisHigh,
                          ),
                          child: rightTitle,
                        ),
                      if (rightCaption case final rightCaption?)
                        DefaultTextStyle(
                          overflow: TextOverflow.ellipsis,
                          style: theme.typography.captionBase.copyWith(
                            color: colors.onColorEmphasisLow,
                          ),
                          child: rightCaption,
                        ),
                    ],
                  ),
                ),
              if (cardCorner case final cardCorner? when hasCardCornerAfterTexts) ...[
                OdinGap.xxs,
                cardCorner,
              ],
            ],
          ),
      ],
    );
  }

  bool hasContent() {
    return leftOverline != null || leftTitle != null || leftCaption != null || rightOverline != null || rightTitle != null || rightCaption != null || cardCorner != null || cardImage != null;
  }
}

sealed class OdinSubCardImageKind {
  const OdinSubCardImageKind();

  const factory OdinSubCardImageKind.avatar({
    required OdinAvatarWidget avatar,
  }) = OdinSubCardImageKindAvatar;

  const factory OdinSubCardImageKind.iconCircle({
    required OdinIconContainerCircle iconContainerCircle,
  }) = OdinSubCardImageKindIconCircle;

  const factory OdinSubCardImageKind.image({
    required OdinImageContainer imageContainer,
  }) = OdinSubCardImageKindImage;

  const factory OdinSubCardImageKind.imageCombo({
    required OdinGlobalImageCombo imageCombo,
  }) = OdinSubCardImageKindImageCombo;

  const factory OdinSubCardImageKind.imageGroup({
    required OdinImageGroup imageGroup,
  }) = OdinSubCardImageKindImageGroup;
}

final class OdinSubCardImageKindAvatar extends OdinSubCardImageKind {
  const OdinSubCardImageKindAvatar({required this.avatar});

  final OdinAvatarWidget avatar;
}

final class OdinSubCardImageKindIconCircle extends OdinSubCardImageKind {
  const OdinSubCardImageKindIconCircle({required this.iconContainerCircle});

  final OdinIconContainerCircle iconContainerCircle;
}

final class OdinSubCardImageKindImage extends OdinSubCardImageKind {
  const OdinSubCardImageKindImage({required this.imageContainer});

  final OdinImageContainer imageContainer;
}

final class OdinSubCardImageKindImageCombo extends OdinSubCardImageKind {
  const OdinSubCardImageKindImageCombo({required this.imageCombo});

  final OdinGlobalImageCombo imageCombo;
}

final class OdinSubCardImageKindImageGroup extends OdinSubCardImageKind {
  const OdinSubCardImageKindImageGroup({required this.imageGroup});

  final OdinImageGroup imageGroup;
}

class OdinSubCardImage extends StatelessWidget {
  const OdinSubCardImage({
    required this.kind,
    super.key,
  });

  final OdinSubCardImageKind kind;

  @override
  Widget build(BuildContext context) {
    return switch (kind) {
      OdinSubCardImageKindAvatar(:final avatar) => OdinAvatarTheme(
        data: OdinAvatarTheme.of(context).copyWith(
          hasOutline: true,
          size: OdinAvatarSize.size40,
        ),
        child: avatar,
      ),
      OdinSubCardImageKindIconCircle(:final iconContainerCircle) => OdinIconContainerTheme(
        data: OdinIconContainerTheme.of(context).copyWith(
          circleSize: OdinIconContainerCircleSize.size40,
        ),
        child: iconContainerCircle,
      ),
      OdinSubCardImageKindImage(:final imageContainer) => OdinImageContainerTheme(
        data: OdinImageContainerTheme.of(context).copyWith(
          size: OdinImageContainerSize.size40,
          shape: OdinImageContainerShape.rounded,
        ),
        child: imageContainer,
      ),
      OdinSubCardImageKindImageCombo(:final imageCombo) => OdinGlobalImageComboTheme(
        data: OdinGlobalImageComboThemeData(
          size: OdinGlobalImageComboSize.size40,
        ),
        child: imageCombo,
      ),
      OdinSubCardImageKindImageGroup(:final imageGroup) => OdinImageGroupTheme(
        data: OdinImageGroupThemeData(size: OdinImageGroupSize.medium),
        child: imageGroup,
      ),
    };
  }
}

sealed class OdinSubCardCornerKind {
  const OdinSubCardCornerKind({
    required this.widget,
  });

  const factory OdinSubCardCornerKind.checkbox(OdinCheckbox checkbox) = OdinSubCardCornerKindCheckbox;

  const factory OdinSubCardCornerKind.radioButton(OdinRadioButton<Object?> radioButton) = OdinSubCardCornerKindRadioButton;

  const factory OdinSubCardCornerKind.badge(OdinBadgeWidget badge) = OdinSubCardCornerKindBadge;

  final Widget widget;
}

final class OdinSubCardCornerKindCheckbox extends OdinSubCardCornerKind {
  const OdinSubCardCornerKindCheckbox(OdinCheckbox checkbox) : super(widget: checkbox);
}

final class OdinSubCardCornerKindRadioButton extends OdinSubCardCornerKind {
  const OdinSubCardCornerKindRadioButton(OdinRadioButton<Object?> radioButton) : super(widget: radioButton);
}

final class OdinSubCardCornerKindBadge extends OdinSubCardCornerKind {
  const OdinSubCardCornerKindBadge(OdinBadgeWidget badge) : super(widget: badge);
}

final class OdinSubCardCorner extends StatelessWidget {
  const OdinSubCardCorner({
    required this.kind,
    super.key,
  });

  final OdinSubCardCornerKind kind;

  @override
  Widget build(BuildContext context) {
    if (kind is OdinSubCardCornerKindCheckbox) {
      return Transform.translate(
        offset: const Offset(kCheckboxExtraSpacing, -kCheckboxExtraSpacing),
        child: kind.widget,
      );
    } else if (kind is OdinSubCardCornerKindRadioButton) {
      return Transform.translate(
        offset: const Offset(kRadioButtonExtraSpacing, -kRadioButtonExtraSpacing),
        child: kind.widget,
      );
    } else {
      return kind.widget;
    }
  }
}

sealed class OdinSubCardDetail extends StatelessWidget {
  const OdinSubCardDetail({super.key});

  const factory OdinSubCardDetail.slot(Widget slot) = OdinSubCardDetailSlot;

  const factory OdinSubCardDetail.description(Text text) = OdinSubCardDetailDescription;

  const factory OdinSubCardDetail.twoColumns({
    required Widget leftTitle,
    Widget? leftOverline,
    Widget? rightOverline,
    Widget? rightTitle,
    Widget? leftCaption,
    Widget? rightCaption,
    int? leftFlex,
    int? rightFlex,
  }) = OdinSubCardDetailTwoColumns;

  const factory OdinSubCardDetail.list(List<OdinSubCardDetailListRow> rows) = OdinSubCardDetailList;
}

final class OdinSubCardDetailSlot extends OdinSubCardDetail {
  const OdinSubCardDetailSlot(this.slot, {super.key});

  final Widget slot;

  @override
  Widget build(BuildContext context) => slot;
}

final class OdinSubCardDetailDescription extends OdinSubCardDetail {
  const OdinSubCardDetailDescription(this.text, {super.key});

  final Widget text;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);

    return DefaultTextStyle(
      style: theme.typography.bodySmall.copyWith(color: theme.appColorScheme.onColorEmphasisHigh),
      child: text,
    );
  }
}

final class OdinSubCardDetailTwoColumns extends OdinSubCardDetail {
  const OdinSubCardDetailTwoColumns({
    required this.leftTitle,
    super.key,
    this.leftOverline,
    this.rightOverline,
    this.rightTitle,
    this.leftCaption,
    this.rightCaption,
    this.leftFlex,
    this.rightFlex,
  });

  final Widget? leftOverline;
  final Widget? rightOverline;
  final Widget leftTitle;
  final Widget? rightTitle;
  final Widget? leftCaption;
  final Widget? rightCaption;
  final int? leftFlex;
  final int? rightFlex;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colorScheme = theme.appColorScheme;
    final typography = theme.typography;
    final overlineStyle = typography.captionBase.copyWith(color: colorScheme.onColorEmphasisLow);
    final titleStyle = typography.titleSmall.copyWith(color: colorScheme.onColorEmphasisHigh);
    final captionStyle = typography.captionBase.copyWith(color: colorScheme.onColorEmphasisLow);

    final leftFlex = this.leftFlex ?? 1;
    final rightFlex = this.rightFlex ?? 1;

    final hasOverline = leftOverline != null || rightOverline != null;
    final hasCaption = leftCaption != null || rightCaption != null;

    return Column(
      children: [
        if (hasOverline) //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (leftOverline case final leftOverline?) //
                Flexible(
                  flex: leftFlex,
                  child: DefaultTextStyle(
                    style: overlineStyle,
                    child: leftOverline,
                  ),
                ),
              if (rightOverline case final rightOverline?) //
                Expanded(
                  flex: rightFlex,
                  child: DefaultTextStyle(
                    textAlign: TextAlign.right,
                    style: overlineStyle,
                    child: rightOverline,
                  ),
                ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: leftFlex,
              child: DefaultTextStyle(
                style: titleStyle,
                child: leftTitle,
              ),
            ),
            if (rightTitle case final rightTitle?) //
              Expanded(
                flex: rightFlex,
                child: DefaultTextStyle(
                  textAlign: TextAlign.right,
                  style: titleStyle,
                  child: rightTitle,
                ),
              ),
          ],
        ),
        if (hasCaption) //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (leftCaption case final leftCaption?) //
                Flexible(
                  flex: leftFlex,
                  child: DefaultTextStyle(
                    style: captionStyle,
                    child: leftCaption,
                  ),
                ),
              if (rightCaption case final rightCaption?) //
                Expanded(
                  flex: rightFlex,
                  child: DefaultTextStyle(
                    textAlign: TextAlign.right,
                    style: captionStyle,
                    child: rightCaption,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

final class OdinSubCardDetailList extends OdinSubCardDetail {
  const OdinSubCardDetailList(this.rows, {super.key}) : assert(rows.length >= 2, 'OdinSubCardDetailKindList must have at least two list rows'), assert(rows.length <= 12, 'OdinSubCardDetailKindList must have at most twelve list rows');

  final List<OdinSubCardDetailListRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: (rows as List<Widget>)
          .intersperse(OdinGlobalDivider.sectionThin) //
          .toList(growable: false),
    );
  }
}

final class OdinSubCardDetailListRow extends StatelessWidget {
  const OdinSubCardDetailListRow({
    required this.label,
    required this.value,
    super.key,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.informativeIcon,
  });

  final Widget label;
  final Widget value;
  final int leftFlex;
  final int rightFlex;
  final OdinInformativeIcon? informativeIcon;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colorScheme = theme.appColorScheme;
    final typography = theme.typography;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: OdinPaddingValue.xxs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: OdinGapValue.xs,
        children: [
          Flexible(
            flex: leftFlex,
            child: Row(
              children: [
                Flexible(
                  child: DefaultTextStyle(
                    style: typography.bodySmall.copyWith(color: colorScheme.onColorEmphasisMedium),
                    textWidthBasis: TextWidthBasis.longestLine,
                    child: label,
                  ),
                ),
                if (informativeIcon case final informativeIcon?) ...[
                  OdinGap.xxxs,
                  informativeIcon,
                ],
              ],
            ),
          ),
          Flexible(
            flex: rightFlex,
            child: DefaultTextStyle(
              textAlign: TextAlign.right,
              style: typography.bodySmall.copyWith(color: colorScheme.onColorEmphasisHigh),
              child: value,
            ),
          ),
        ],
      ),
    );
  }
}

final class OdinSubCardFooter extends StatelessWidget {
  const OdinSubCardFooter({
    super.key,
    this.button,
    this.linkSettings,
    this.leftIconSettings,
    this.rightIconSettings,
  });

  final Widget? button;
  final OdinActionSettings<VoidCallback>? linkSettings;
  final OdinIconActionSettings? leftIconSettings;
  final OdinIconActionSettings? rightIconSettings;

  @override
  Widget build(BuildContext context) {
    const iconButtonSize = 30.0;
    const iconSize = 24.0;
    final hasAnythingAfterButton = button != null && linkSettings != null;

    return Row(
      children: [
        if (button case final button?)
          OdinDefaultButtonProperties(
            kind: OdinButtonKind.line,
            size: OdinButtonSize.compact,
            child: button,
          ),
        if (hasAnythingAfterButton) OdinGap.xs,
        if (linkSettings case final linkSettings?)
          OdinLink.fromActionSettings(
            actionSettings: linkSettings.copyWith(
              rightIcon: linkSettings.rightIcon ?? OdinIcons.chevronRight,
            ),
            size: OdinLinkSize.small,
          ),
        const Spacer(),
        Transform.translate(
          offset: const Offset((iconButtonSize - iconSize) / 2, 0),
          child: Row(
            children: [
              if (leftIconSettings case final leftIconSettings?)
                OdinIconButton.fromActionSettings(
                  actionSettings: leftIconSettings,
                  minSize: iconButtonSize,
                ),
              if (leftIconSettings != null && rightIconSettings != null) //
                OdinGap.xs,
              if (rightIconSettings case final rightIconSettings?)
                OdinIconButton.fromActionSettings(
                  actionSettings: rightIconSettings,
                  minSize: iconButtonSize,
                ),
            ],
          ),
        ),
      ],
    );
  }

  bool hasContent() {
    return button != null || //
        linkSettings != null ||
        leftIconSettings != null ||
        rightIconSettings != null;
  }
}

final class OdinCardShimmer extends StatelessWidget {
  const OdinCardShimmer({
    super.key,
    this.hasImage = false,
    this.backgroundColor,
    this.borderColor,
    this.borderStrokeWidth,
    this.borderDashedStyle,
  });

  final bool hasImage;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderStrokeWidth;
  final OdinDashedBorderStyle? borderDashedStyle;

  @override
  Widget build(BuildContext context) {
    const smallTextShimmerBox = OdinShimmerCover(
      child: SizedBox(
        width: double.infinity,
        height: 21.0,
      ),
    );
    const mediumTextShimmerBox = OdinShimmerCover(
      child: SizedBox(
        width: double.infinity,
        height: 24.0,
      ),
    );
    const largeTextShimmerBox = OdinShimmerCover(
      child: SizedBox(
        width: double.infinity,
        height: 32.0,
      ),
    );

    if (hasImage) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OdinCard(
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderStrokeWidth: borderStrokeWidth,
            borderDashedStyle: borderDashedStyle,
            hasDivider: false,
            image: const OdinShimmer(
              child: OdinShimmerCover(
                child: AspectRatio(
                  aspectRatio: _kImageAspectRatio,
                  child: SizedBox(width: double.infinity),
                ),
              ),
            ),
            details: const [
              OdinSubCardDetail.slot(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OdinShimmer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          smallTextShimmerBox,
                          OdinGap.xxxs,
                          FractionallySizedBox(
                            widthFactor: 0.5,
                            child: smallTextShimmerBox,
                          ),
                          OdinGap.xxxs,
                          OdinShimmerCover(
                            borderRadius: 100.0,
                            child: SizedBox(
                              width: 64.0,
                              height: 23.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OdinGap.xs,
                    OdinGlobalDivider.sectionThin,
                    OdinGap.xs,
                    OdinShimmer(
                      child: FractionallySizedBox(
                        widthFactor: 0.25,
                        child: largeTextShimmerBox,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return const OdinCard(
        header: OdinSubCardHeader(
          cardImage: OdinSubCardImage(
            kind: OdinSubCardImageKind.avatar(
              avatar: OdinAvatarShimmer(),
            ),
          ),
          leftTitle: OdinShimmer(
            child: mediumTextShimmerBox,
          ),
          leftCaption: OdinShimmer(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: OdinPaddingValue.xxxs),
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: smallTextShimmerBox,
              ),
            ),
          ),
        ),
        details: [
          OdinSubCardDetail.slot(
            OdinShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  smallTextShimmerBox,
                  OdinGap.xxxs,
                  smallTextShimmerBox,
                  OdinGap.xxxs,
                  smallTextShimmerBox,
                  OdinGap.xxxs,
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: smallTextShimmerBox,
                  ),
                  OdinGap.xs,
                  FractionallySizedBox(
                    widthFactor: 0.25,
                    child: largeTextShimmerBox,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}
