import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

const _trackHeight = 4.0;
const _normalThumbRadius = 12.0;
const _pressedThumbRadius = 10.0;
const _overlayThumbRadius = 20.0;

final class OdinSlider extends StatefulWidget {
  const OdinSlider({
    required this.kind,
    super.key,
    this.title,
    this.titleValue,
    this.titleValueIcon,
    this.subtitle,
    this.leftDescriptionCaption,
    this.leftDescriptionValue,
    this.rightDescriptionCaption,
    this.rightDescriptionValue,
    this.linkActionSettings,
  });

  OdinSlider.normal({
    required double value,
    required double minValue,
    required double maxValue,
    required ValueChanged<double> onChanged,
    super.key,
    this.title,
    this.titleValue,
    this.titleValueIcon,
    this.subtitle,
    this.leftDescriptionCaption,
    this.leftDescriptionValue,
    this.rightDescriptionCaption,
    this.rightDescriptionValue,
    this.linkActionSettings,
  }) : kind = OdinSubSliderKind.normal(
         value: value,
         minValue: minValue,
         maxValue: maxValue,
         onChanged: onChanged,
       );

  OdinSlider.range({
    required RangeValues range,
    required double minValue,
    required double maxValue,
    required ValueChanged<RangeValues> onChanged,
    super.key,
    this.title,
    this.titleValue,
    this.titleValueIcon,
    this.subtitle,
    this.leftDescriptionCaption,
    this.leftDescriptionValue,
    this.rightDescriptionCaption,
    this.rightDescriptionValue,
    this.linkActionSettings,
  }) : kind = OdinSubSliderKind.range(
         range: range,
         minValue: minValue,
         maxValue: maxValue,
         onChanged: onChanged,
       );

  final OdinSubSliderKind kind;
  final Widget? title;
  final Widget? titleValue;
  final Widget? titleValueIcon;
  final Widget? subtitle;
  final Widget? leftDescriptionCaption;
  final Widget? leftDescriptionValue;
  final Widget? rightDescriptionCaption;
  final Widget? rightDescriptionValue;
  final OdinActionSettings<VoidCallback>? linkActionSettings;

  @override
  State<OdinSlider> createState() => _OdinSliderState();
}

class _OdinSliderState extends State<OdinSlider> {
  bool isEnabled = true;
  bool isDiscrete = false;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colorScheme = theme.appColorScheme;

    final hasTitleRow = widget.title != null || widget.titleValue != null || widget.titleValueIcon != null;
    final hasAnythingAfterTitle = widget.title != null && (widget.titleValue != null || widget.titleValueIcon != null);
    final hasAnythingAfterTitleValue = widget.titleValue != null && widget.titleValueIcon != null;
    final hasSubtitle = widget.subtitle != null;
    final hasLeftDescription = widget.leftDescriptionCaption != null || widget.leftDescriptionValue != null;
    final hasRightDescription = widget.rightDescriptionCaption != null || widget.rightDescriptionValue != null;
    final hasDescription = hasLeftDescription || hasRightDescription;
    final hasLink = widget.linkActionSettings != null;
    final hasAnythingAfterSubSlider = hasDescription || hasLink;
    final hasAnythingAfterDescription = hasDescription && hasLink;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTitleRow)
          Row(
            children: [
              if (widget.title case final title?)
                Expanded(
                  child: DefaultTextStyle(
                    overflow: TextOverflow.ellipsis,
                    style: theme.typography.bodySmall.copyWith(
                      color: colorScheme.onColorEmphasisHigh,
                    ),
                    child: title,
                  ),
                )
              else
                const Spacer(),
              if (hasAnythingAfterTitle) //
                OdinGap.xs,
              if (widget.titleValue case final titleValue?)
                DefaultTextStyle(
                  overflow: TextOverflow.ellipsis,
                  style: theme.typography.bodySmall.copyWith(
                    color: colorScheme.onColorEmphasisHigh,
                  ),
                  child: titleValue,
                ),
              if (hasAnythingAfterTitleValue) //
                OdinGap.xxxs,
              if (widget.titleValueIcon case final titleValueIcon?)
                OdinIconContainerTheme(
                  data: OdinIconContainerTheme.of(context).copyWith(
                    size: OdinIconContainerSize.size16,
                    foregroundColor: colorScheme.onColorEmphasisHigh,
                  ),
                  child: titleValueIcon,
                ),
            ],
          ),
        if (hasTitleRow && hasSubtitle) //
          OdinGap.xxxs,
        if (widget.subtitle case final subtitle?)
          DefaultTextStyle(
            overflow: TextOverflow.ellipsis,
            style: theme.typography.bodySmall.copyWith(
              color: colorScheme.onColorEmphasisHigh,
            ),
            child: subtitle,
          ),
        if (hasTitleRow || hasSubtitle) //
          OdinGap.xs,
        OdinSubSlider(kind: widget.kind),
        if (hasAnythingAfterSubSlider) //
          OdinGap.xs,
        if (hasDescription)
          Row(
            children: [
              if (hasLeftDescription)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.leftDescriptionValue case final leftDescriptionValue?)
                        DefaultTextStyle(
                          overflow: TextOverflow.ellipsis,
                          style: theme.typography.bodySmall.copyWith(
                            color: colorScheme.onColorEmphasisMedium,
                          ),
                          child: leftDescriptionValue,
                        ),
                      if (widget.leftDescriptionCaption case final leftDescriptionCaption?)
                        DefaultTextStyle(
                          overflow: TextOverflow.ellipsis,
                          style: theme.typography.captionBase.copyWith(
                            color: colorScheme.onColorEmphasisLow,
                          ),
                          child: leftDescriptionCaption,
                        ),
                    ],
                  ),
                ),
              if (hasRightDescription)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (widget.rightDescriptionValue case final rightDescriptionValue?)
                        DefaultTextStyle(
                          overflow: TextOverflow.ellipsis,
                          style: theme.typography.bodySmall.copyWith(
                            color: colorScheme.onColorEmphasisMedium,
                          ),
                          child: rightDescriptionValue,
                        ),
                      if (widget.rightDescriptionCaption case final rightDescriptionCaption?)
                        DefaultTextStyle(
                          overflow: TextOverflow.ellipsis,
                          style: theme.typography.captionBase.copyWith(
                            color: colorScheme.onColorEmphasisLow,
                          ),
                          child: rightDescriptionCaption,
                        ),
                    ],
                  ),
                ),
            ],
          ),
        if (hasAnythingAfterDescription) //
          OdinGap.xs,
        if (widget.linkActionSettings case final actionSettings?) OdinLink.fromActionSettings(actionSettings: actionSettings),
      ],
    );
  }
}

sealed class OdinSubSliderKind {
  const factory OdinSubSliderKind.normal({
    required double value,
    required double minValue,
    required double maxValue,
    required ValueChanged<double> onChanged,
  }) = OdinSubSliderKindNormal;

  const factory OdinSubSliderKind.range({
    required RangeValues range,
    required double minValue,
    required double maxValue,
    required ValueChanged<RangeValues> onChanged,
  }) = OdinSubSliderKindRange;
}

final class OdinSubSliderKindNormal implements OdinSubSliderKind {
  const OdinSubSliderKindNormal({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  });

  final double value;
  final double minValue;
  final double maxValue;
  final ValueChanged<double> onChanged;
}

final class OdinSubSliderKindRange implements OdinSubSliderKind {
  const OdinSubSliderKindRange({
    required this.range,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  });

  final RangeValues range;
  final double minValue;
  final double maxValue;
  final ValueChanged<RangeValues> onChanged;
}

final class OdinSubSlider extends StatefulWidget {
  const OdinSubSlider({
    required this.kind,
    super.key,
  });

  final OdinSubSliderKind kind;

  @override
  State<OdinSubSlider> createState() => _OdinSubSliderState();
}

class _OdinSubSliderState extends State<OdinSubSlider> {
  double _thumbRadius = _normalThumbRadius;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colorScheme = theme.appColorScheme;

    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: colorScheme.actionSecondaryEnabled,
        inactiveTrackColor: colorScheme.outlineBase,
        secondaryActiveTrackColor: colorScheme.statusErrorBase,
        activeTickMarkColor: kTransparentColor,
        inactiveTickMarkColor: kTransparentColor,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: _overlayThumbRadius),
        overlayColor: colorScheme.primaryBase.withValues(alpha: 0.2),
        trackHeight: _trackHeight,
        trackShape: const _TrackShape(),
        rangeTrackShape: const _RangeTrackShape(),
        thumbColor: colorScheme.actionSecondaryEnabled,
        thumbShape: _ThumbShape(_thumbRadius),
        rangeThumbShape: _RangeThumbShape(context, _thumbRadius),
      ),
      child: switch (widget.kind) {
        OdinSubSliderKindNormal(:final value, :final minValue, :final maxValue, :final onChanged) => Slider(
          value: value,
          max: maxValue,
          min: minValue,
          onChanged: onChanged,
          onChangeStart: (value) => _handleStartChanged(context),
          onChangeEnd: (value) => _handleEndChanged(context),
        ),
        OdinSubSliderKindRange(:final range, :final minValue, :final maxValue, :final onChanged) => RangeSlider(
          values: range,
          min: minValue,
          max: maxValue,
          onChanged: onChanged,
          onChangeStart: (range) => _handleStartChanged(context),
          onChangeEnd: (range) => _handleEndChanged(context),
        ),
      },
    );
  }

  void _handleStartChanged(BuildContext context) {
    setState(
      () => _thumbRadius = _pressedThumbRadius,
    );
  }

  void _handleEndChanged(BuildContext context) {
    setState(
      () => _thumbRadius = _normalThumbRadius,
    );
  }
}

final class _TrackShape extends RoundedRectSliderTrackShape {
  const _TrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 2.0;

    return Rect.fromLTWH(
      offset.dx,
      offset.dy + (parentBox.size.height - trackHeight) / 2.0,
      parentBox.size.width,
      trackHeight,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2.0,
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      secondaryOffset: secondaryOffset,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: 0.0,
    );
  }
}

final class _ThumbShape extends RoundSliderThumbShape {
  const _ThumbShape(double radius) : super(enabledThumbRadius: radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    super.paint(
      context,
      Offset(
        clampDouble(center.dx, enabledThumbRadius, parentBox.size.width - enabledThumbRadius),
        center.dy,
      ),
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete,
      labelPainter: labelPainter,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      textDirection: textDirection,
      value: value,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
    );
  }
}

final class _RangeTrackShape extends RoundedRectRangeSliderTrackShape {
  const _RangeTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 2.0;

    return Rect.fromLTWH(
      offset.dx,
      offset.dy + (parentBox.size.height - trackHeight) / 2.0,
      parentBox.size.width,
      trackHeight,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    required TextDirection textDirection,
    bool isEnabled = false,
    bool isDiscrete = false,
    double additionalActiveTrackHeight = 2.0,
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      startThumbCenter: startThumbCenter,
      endThumbCenter: endThumbCenter,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      textDirection: textDirection,
      additionalActiveTrackHeight: 0.0,
    );
  }
}

final class _RangeThumbShape extends RoundRangeSliderThumbShape {
  const _RangeThumbShape(this.context, double radius) : super(enabledThumbRadius: radius);

  final BuildContext context;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required SliderThemeData sliderTheme,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final width = (this.context.findRenderObject()! as RenderBox).size.width;

    super.paint(
      context,
      Offset(
        clampDouble(center.dx, enabledThumbRadius, width - enabledThumbRadius),
        center.dy,
      ),
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      isOnTop: isOnTop,
      sliderTheme: sliderTheme,
      textDirection: textDirection,
      thumb: thumb,
      isPressed: isPressed,
    );
  }
}
