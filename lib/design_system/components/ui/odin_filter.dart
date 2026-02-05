import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';
import 'package:intersperse/intersperse.dart';
import 'package:intl/intl.dart';

class OdinFilter extends StatelessWidget {
  const OdinFilter({
    required this.headerTitle,
    required this.slots,
    required this.primaryAction,
    required this.secondaryAction,
    super.key,
  });

  final String headerTitle;
  final List<OdinSubFilterSlot> slots;
  final OdinActionSettings<VoidCallback> primaryAction;
  final OdinActionSettings<VoidCallback> secondaryAction;

  @override
  Widget build(BuildContext context) {
    const sectionDivider = SliverToBoxAdapter(
      child: OdinGlobalDivider.sectionThin,
    );

    return Column(
      children: [
        _FilterHeader(title: headerTitle),
        Expanded(
          child: CustomScrollView(
            slivers: [
              for (final slot in slots) SliverToBoxAdapter(child: slot),
            ].intersperse(sectionDivider).toList(growable: false),
          ),
        ),
        OdinButtonFixed(
          button: OdinButton.fromActionSettings(actionSettings: primaryAction),
          link: OdinLink.fromActionSettings(actionSettings: secondaryAction),
        ),
      ],
    );
  }
}

class OdinSubFilterSlot extends StatelessWidget {
  const OdinSubFilterSlot({
    required this.kind,
    super.key,
    this.padding = const EdgeInsets.only(
      left: OdinPaddingValue.sm,
      right: OdinPaddingValue.sm,
      top: OdinPaddingValue.sm,
      bottom: OdinPaddingValue.md,
    ),
  });

  final OdinSubFilterSlotKind kind;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final (title, subtitle, titleInfo, onClearLink) = switch (kind) {
      _OdinSubFilterSlotKindCheckbox(
        title: final title,
        subtitle: final subtitle,
        titleInfo: final titleInfo,
        onClearLink: final onClearLink,
      ) ||
      _OdinSubFilterSlotKindCustom(
        title: final title,
        subtitle: final subtitle,
        titleInfo: final titleInfo,
        onClearLink: final onClearLink,
      ) ||
      _OdinSubFilterSlotKindFilterTag(
        title: final title,
        subtitle: final subtitle,
        titleInfo: final titleInfo,
        onClearLink: final onClearLink,
      ) ||
      _OdinSubFilterSlotKindRadioButton(
        title: final title,
        subtitle: final subtitle,
        titleInfo: final titleInfo,
        onClearLink: final onClearLink,
      ) ||
      _OdinSubFilterSlotKindSlider(
        title: final title,
        subtitle: final subtitle,
        titleInfo: final titleInfo,
        onClearLink: final onClearLink,
      ) ||
      _OdinSubFilterSlotKindPeriod(
        title: final title,
        subtitle: final subtitle,
        titleInfo: final titleInfo,
        onClearLink: final onClearLink,
      ) => (title, subtitle, titleInfo, onClearLink),
      _OdinSubFilterSlotKindContent(
        title: final title,
        subtitle: final subtitle,
        titleInfo: final titleInfo,
      ) =>
        (
          title,
          subtitle,
          titleInfo,
          null,
        ),
      _OdinSubFilterSlotKindCheckboxContent() || _OdinSubFilterSlotKindSearchTag() => (null, null, null, null),
    };

    final slot = switch (kind) {
      _OdinSubFilterSlotKindCheckbox(labels: final labels) => _OdinSubFilterSlotCheckbox(labels: labels),
      _OdinSubFilterSlotKindCheckboxContent(label: final label, description: final description) => _OdinSubFilterSlotCheckboxContent(
        label: label,
        description: description,
      ),
      _OdinSubFilterSlotKindContent(link: final link) => _OdinSubFilterSlotContent(link: link),
      _OdinSubFilterSlotKindCustom(child: final child) => _OdinSubFilterSlotCustom(child: child),
      _OdinSubFilterSlotKindFilterTag(tags: final tags) => _OdinSubFilterSlotFilterTag(tags: tags),
      _OdinSubFilterSlotKindPeriod(
        periods: final periods,
        selectedValue: final selectedValue,
        hasCustomPeriod: final hasCustomPeriod,
        onChanged: final onChanged,
      ) =>
        _OdinSubFilterSlotPeriod(
          periods: periods,
          selectedValue: selectedValue,
          hasCustomPeriod: hasCustomPeriod,
          onChanged: onChanged,
        ),
      _OdinSubFilterSlotKindRadioButton(buttons: final buttons) => _OdinSubFilterSlotRadioButton(buttons: buttons),
      _OdinSubFilterSlotKindSearchTag(input: final input, tags: final tags) => _OdinSubFilterSlotSearchTag(
        input: input,
        tags: tags,
      ),
      _OdinSubFilterSlotKindSlider(slider: final slider) => _OdinSubFilterSlotSlider(slider: slider),
    };

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) //
            _OdinSubFilterSlotHeader(
              title: title,
              subtitle: subtitle,
              titleInfo: titleInfo,
              onClearLink: onClearLink,
            ),
          slot,
        ],
      ),
    );
  }
}

sealed class OdinSubFilterSlotKind {
  const OdinSubFilterSlotKind();

  const factory OdinSubFilterSlotKind.checkbox({
    required Widget title,
    required List<OdinCheckboxLabel> labels,
    Widget? subtitle,
    String? titleInfo,
    VoidCallback? onClearLink,
  }) = _OdinSubFilterSlotKindCheckbox;

  const factory OdinSubFilterSlotKind.checkboxContent({
    required OdinCheckboxLabel label,
    required Widget description,
  }) = _OdinSubFilterSlotKindCheckboxContent;

  const factory OdinSubFilterSlotKind.content({
    required Widget title,
    required OdinLink link,
    Widget? subtitle,
    String? titleInfo,
  }) = _OdinSubFilterSlotKindContent;

  const factory OdinSubFilterSlotKind.custom({
    required Widget title,
    required Widget child,
    Widget? subtitle,
    String? titleInfo,
    VoidCallback? onClearLink,
  }) = _OdinSubFilterSlotKindCustom;

  const factory OdinSubFilterSlotKind.filterTag({
    required Widget title,
    required List<OdinTagFilter> tags,
    Widget? subtitle,
    String? titleInfo,
    VoidCallback? onClearLink,
  }) = _OdinSubFilterSlotKindFilterTag;

  const factory OdinSubFilterSlotKind.period({
    required Widget title,
    required List<OdinFilterPeriod> periods,
    required OdinFilterPeriod? selectedValue,
    Widget? subtitle,
    String? titleInfo,
    VoidCallback? onClearLink,
    bool? hasCustomPeriod,
    ValueChanged<OdinFilterPeriod?>? onChanged,
  }) = _OdinSubFilterSlotKindPeriod;

  const factory OdinSubFilterSlotKind.radioButton({
    required Widget title,
    required List<OdinRadioButtonLabel<Object>> buttons,
    Widget? subtitle,
    String? titleInfo,
    VoidCallback? onClearLink,
  }) = _OdinSubFilterSlotKindRadioButton<Object>;

  const factory OdinSubFilterSlotKind.searchTag({
    required OdinInputTag input,
    required List<OdinTagSearch> tags,
  }) = _OdinSubFilterSlotKindSearchTag;

  const factory OdinSubFilterSlotKind.slider({
    required Widget title,
    required OdinSlider slider,
    Widget? subtitle,
    String? titleInfo,
    VoidCallback? onClearLink,
  }) = _OdinSubFilterSlotKindSlider;
}

class _FilterHeader extends StatelessWidget {
  const _FilterHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: OdinPaddingValue.sm,
            right: OdinPaddingValue.sm - kIconButtonExtraSpacing,
            top: OdinPaddingValue.xs - kIconButtonExtraSpacing,
            bottom: OdinPaddingValue.xs - kIconButtonExtraSpacing,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.typography.titleSmall.copyWith(
                    color: theme.appColorScheme.onColorEmphasisHigh,
                  ),
                ),
              ),
              OdinGap.xxs,
              OdinIconButton(
                icon: const Icon(OdinIcons.close),
                onPress: Navigator.of(context).pop,
              ),
            ],
          ),
        ),
        OdinGlobalDivider.sectionThin,
      ],
    );
  }
}

final class _OdinSubFilterSlotKindCheckbox extends OdinSubFilterSlotKind {
  const _OdinSubFilterSlotKindCheckbox({
    required this.title,
    required this.labels,
    this.subtitle,
    this.titleInfo,
    this.onClearLink,
  });

  final Widget title;
  final Widget? subtitle;
  final String? titleInfo;
  final VoidCallback? onClearLink;
  final List<OdinCheckboxLabel> labels;
}

final class _OdinSubFilterSlotKindCheckboxContent extends OdinSubFilterSlotKind {
  const _OdinSubFilterSlotKindCheckboxContent({
    required this.label,
    required this.description,
  });

  final OdinCheckboxLabel label;
  final Widget description;
}

final class _OdinSubFilterSlotKindContent extends OdinSubFilterSlotKind {
  const _OdinSubFilterSlotKindContent({
    required this.title,
    required this.link,
    this.subtitle,
    this.titleInfo,
  });

  final Widget title;
  final Widget? subtitle;
  final String? titleInfo;
  final OdinLink link;
}

final class _OdinSubFilterSlotKindCustom extends OdinSubFilterSlotKind {
  const _OdinSubFilterSlotKindCustom({
    required this.title,
    required this.child,
    this.subtitle,
    this.titleInfo,
    this.onClearLink,
  });

  final Widget title;
  final Widget? subtitle;
  final String? titleInfo;
  final VoidCallback? onClearLink;
  final Widget child;
}

final class _OdinSubFilterSlotKindFilterTag extends OdinSubFilterSlotKind {
  const _OdinSubFilterSlotKindFilterTag({
    required this.title,
    required this.tags,
    this.subtitle,
    this.titleInfo,
    this.onClearLink,
  });

  final Widget title;
  final Widget? subtitle;
  final String? titleInfo;
  final VoidCallback? onClearLink;
  final List<OdinTagFilter> tags;
}

final class _OdinSubFilterSlotKindPeriod extends OdinSubFilterSlotKind {
  const _OdinSubFilterSlotKindPeriod({
    required this.title,
    required this.periods,
    required this.selectedValue,
    this.subtitle,
    this.titleInfo,
    this.onClearLink,
    this.hasCustomPeriod,
    this.onChanged,
  });

  final Widget title;
  final Widget? subtitle;
  final String? titleInfo;
  final VoidCallback? onClearLink;
  final List<OdinFilterPeriod> periods;
  final OdinFilterPeriod? selectedValue;
  final bool? hasCustomPeriod;
  final ValueChanged<OdinFilterPeriod?>? onChanged;
}

final class _OdinSubFilterSlotKindRadioButton<T> extends OdinSubFilterSlotKind {
  const _OdinSubFilterSlotKindRadioButton({
    required this.title,
    required this.buttons,
    this.subtitle,
    this.titleInfo,
    this.onClearLink,
  });

  final Widget title;
  final Widget? subtitle;
  final String? titleInfo;
  final VoidCallback? onClearLink;
  final List<OdinRadioButtonLabel<T>> buttons;
}

final class _OdinSubFilterSlotKindSearchTag extends OdinSubFilterSlotKind {
  const _OdinSubFilterSlotKindSearchTag({
    required this.input,
    required this.tags,
  });

  final OdinInputTag input;
  final List<OdinTagSearch> tags;
}

final class _OdinSubFilterSlotKindSlider extends OdinSubFilterSlotKind {
  const _OdinSubFilterSlotKindSlider({
    required this.title,
    required this.slider,
    this.subtitle,
    this.titleInfo,
    this.onClearLink,
  });

  final Widget title;
  final Widget? subtitle;
  final String? titleInfo;
  final VoidCallback? onClearLink;
  final OdinSlider slider;
}

class _OdinSubFilterSlotHeader extends StatelessWidget {
  const _OdinSubFilterSlotHeader({
    required this.title,
    this.subtitle,
    this.titleInfo,
    this.onClearLink,
  });

  final Widget title;
  final Widget? subtitle;
  final String? titleInfo;
  final VoidCallback? onClearLink;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final onColorEmphasisLow = theme.appColorScheme.onColorEmphasisLow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: DefaultTextStyle(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.typography.titleSmall.copyWith(
                        color: onColorEmphasisLow,
                      ),
                      child: title,
                    ),
                  ),
                  if (titleInfo case final titleInfo?)
                    Padding(
                      padding: const EdgeInsets.only(left: OdinPaddingValue.xxxs),
                      child: OdinTooltip.defaultContent(
                        alignment: OdinTooltipAlignment.start,
                        position: OdinTooltipPosition.top,
                        label: titleInfo,
                        child: OdinIconContainer(
                          size: OdinIconContainerSize.size16,
                          icon: OdinIcons.info,
                          color: onColorEmphasisLow,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (onClearLink case final onClearLink?) ...[
              OdinGap.xs,
              OdinLink(
                isUnderline: true,
                size: OdinLinkSize.small,
                label: const Text('Limpar'),
                onPress: onClearLink,
              ),
            ],
          ],
        ),
        if (subtitle case final subtitle?) //
          Padding(
            padding: const EdgeInsets.only(top: OdinPaddingValue.xxxs),
            child: DefaultTextStyle(
              style: theme.typography.bodySmall.copyWith(
                color: theme.appColorScheme.onColorEmphasisLow,
              ),
              child: subtitle,
            ),
          ),
        OdinGap.xxs,
      ],
    );
  }
}

class _OdinSubFilterSlotCheckbox extends StatelessWidget {
  const _OdinSubFilterSlotCheckbox({required this.labels});

  final List<OdinCheckboxLabel> labels;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OdinGap.sm,
        for (final label in labels) ...[
          label,
        ],
      ],
    );
  }
}

class _OdinSubFilterSlotCheckboxContent extends StatelessWidget {
  const _OdinSubFilterSlotCheckboxContent({
    required this.label,
    required this.description,
  });

  final OdinCheckboxLabel label;
  final Widget description;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label,
        OdinGap.xxs,
        DefaultTextStyle(
          style: theme.typography.bodySmall.copyWith(
            color: theme.appColorScheme.onColorEmphasisLow,
          ),
          child: description,
        ),
      ],
    );
  }
}

class _OdinSubFilterSlotContent extends StatelessWidget {
  const _OdinSubFilterSlotContent({required this.link});

  final OdinLink link;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: OdinPaddingValue.xxs),
      child: link,
    );
  }
}

class _OdinSubFilterSlotCustom extends StatelessWidget {
  const _OdinSubFilterSlotCustom({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: OdinPaddingValue.sm),
      child: child,
    );
  }
}

class _OdinSubFilterSlotFilterTag extends StatelessWidget {
  const _OdinSubFilterSlotFilterTag({required this.tags});

  final List<OdinTagFilter> tags;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: OdinPaddingValue.sm),
      child: Wrap(
        spacing: OdinGapValue.xxs,
        runSpacing: OdinGapValue.xxs,
        children: tags,
      ),
    );
  }
}

@immutable
class OdinFilterPeriod {
  const OdinFilterPeriod({
    required this.label,
    required this.startDate,
    required this.endDate,
  });

  final String label;
  final DateTime? startDate;
  final DateTime? endDate;

  OdinCalendarPeriod? toCalendarPeriod() {
    if (startDate case final startDate?) {
      if (endDate case final endDate?) {
        return OdinCalendarPeriod(
          startDate: startDate,
          endDate: endDate,
        );
      }
    }

    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else {
      return other is OdinFilterPeriod && //
          other.label == label &&
          other.startDate == startDate &&
          other.endDate == endDate;
    }
  }

  @override
  int get hashCode {
    return Object.hashAll([OdinFilterPeriod, label, startDate, endDate]);
  }
}

class _OdinSubFilterSlotPeriod extends StatefulWidget {
  const _OdinSubFilterSlotPeriod({
    required this.periods,
    required this.selectedValue,
    this.hasCustomPeriod,
    this.onChanged,
  });

  final List<OdinFilterPeriod> periods;
  final OdinFilterPeriod? selectedValue;
  final bool? hasCustomPeriod;
  final ValueChanged<OdinFilterPeriod?>? onChanged;

  @override
  State<_OdinSubFilterSlotPeriod> createState() => _OdinSubFilterSlotPeriodState();
}

final class _OdinSubFilterSlotPeriodState extends State<_OdinSubFilterSlotPeriod> {
  late OdinFilterPeriod _customPeriod;
  final _dateFormat = DateFormat.yMd();
  final _startDateTextController = TextEditingController();
  final _endDateTextController = TextEditingController();
  bool _isCustomPeriodSelected = false;

  @override
  void initState() {
    super.initState();

    _customPeriod = const OdinFilterPeriod(
      label: 'Período personalizado',
      startDate: null,
      endDate: null,
    );
  }

  @override
  void didUpdateWidget(covariant _OdinSubFilterSlotPeriod oldWidget) {
    super.didUpdateWidget(oldWidget);

    _isCustomPeriodSelected = widget.selectedValue == _customPeriod;
  }

  @override
  Widget build(BuildContext context) {
    final hasCustomPeriod = widget.hasCustomPeriod ?? true;
    const hintText = '00/00/0000';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OdinGap.sm,
        ...widget.periods
            .map<Widget>((period) {
              return OdinRadioButtonLabel<OdinFilterPeriod?>(
                label: period.label,
                value: period,
                selectedValue: widget.selectedValue,
                position: OdinRadioButtonPosition.left,
                onChanged: _updateSelectedPeriod,
              );
            })
            .intersperse(OdinGap.xxs),
        if (hasCustomPeriod) ...[
          OdinGap.xxs,
          OdinRadioButtonLabel<OdinFilterPeriod?>(
            label: _customPeriod.label,
            value: _customPeriod,
            selectedValue: widget.selectedValue,
            position: OdinRadioButtonPosition.left,
            onChanged: _updateSelectedPeriod,
          ),
          AnimatedAlignOpacity.builder(
            alignment: Alignment.topCenter,
            heightFactor: _isCustomPeriodSelected ? 1.0 : 0.0,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.only(top: OdinPaddingValue.xs),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _openPeriodPicker(context),
                  child: Row(
                    children: [
                      Flexible(
                        child: IgnorePointer(
                          child: OdinTextField(
                            state: OdinTextFieldState.enabled,
                            size: OdinTextFieldSize.small,
                            controller: _startDateTextController,
                            label: const Text('Data inicial'),
                            leading: const OdinIconContainer(icon: OdinIcons.schedule),
                            hintText: hintText,
                          ),
                        ),
                      ),
                      OdinGap.xs,
                      Flexible(
                        child: IgnorePointer(
                          child: OdinTextField(
                            state: OdinTextFieldState.enabled,
                            size: OdinTextFieldSize.small,
                            controller: _endDateTextController,
                            label: const Text('Data final'),
                            leading: const OdinIconContainer(icon: OdinIcons.schedule),
                            hintText: hintText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  void _updateSelectedPeriod(OdinFilterPeriod? period) {
    setState(() {
      _isCustomPeriodSelected = period == _customPeriod;
    });

    widget.onChanged?.call(period);
  }

  Future<void> _openPeriodPicker(BuildContext context) async {
    final customPeriod = await showOdinPeriodPicker(
      context: context,
      initialSelectedPeriod: _customPeriod.toCalendarPeriod(),
      primaryActionSettingsBuilder: (context, data) {
        return OdinActionSettings(
          text: 'Selecionar',
          onPress: data == null
              ? null //
              : () => Navigator.of(context).pop(data),
        );
      },
      secondaryActionSettingsBuilder: (context, data) {
        return OdinActionSettings(
          text: 'Fechar',
          onPress: Navigator.of(context).pop,
        );
      },
    );

    _customPeriod = OdinFilterPeriod(
      label: _customPeriod.label,
      startDate: customPeriod?.startDate,
      endDate: customPeriod?.endDate,
    );

    _startDateTextController.text = _formatDate(_customPeriod.startDate);
    _endDateTextController.text = _formatDate(_customPeriod.endDate);

    _updateSelectedPeriod(_customPeriod);
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    } else {
      return _dateFormat.format(date);
    }
  }
}

class _OdinSubFilterSlotRadioButton<T> extends StatelessWidget {
  const _OdinSubFilterSlotRadioButton({required this.buttons});

  final List<OdinRadioButtonLabel<T>> buttons;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OdinGap.sm,
        ...buttons,
      ],
    );
  }
}

class _OdinSubFilterSlotSearchTag extends StatelessWidget {
  const _OdinSubFilterSlotSearchTag({
    required this.input,
    required this.tags,
  });

  final OdinInputTag input;
  final List<OdinTagSearch> tags;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        input,
        if (tags.isNotEmpty) ...[
          OdinGap.sm,
          Wrap(
            spacing: OdinGapValue.xxs,
            runSpacing: OdinGapValue.xxs,
            children: tags,
          ),
        ],
      ],
    );
  }
}

class _OdinSubFilterSlotSlider extends StatelessWidget {
  const _OdinSubFilterSlotSlider({required this.slider});

  final OdinSlider slider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: OdinPaddingValue.sm),
      child: slider,
    );
  }
}
