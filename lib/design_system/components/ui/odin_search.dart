import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

const _searchAnimationsDuration = Duration(milliseconds: 250);
const _searchAnimationsCurve = Curves.easeInOut;

enum OdinSearchTriggerKind {
  normal,
  fullWidth,
}

final class OdinSearchTrigger extends StatelessWidget {
  const OdinSearchTrigger({
    super.key,
    this.kind = OdinSearchTriggerKind.normal,
    this.placeholder,
    this.onPress,
    this.text,
    this.filter,
  });

  final OdinSearchTriggerKind kind;
  final Widget? placeholder;
  final VoidCallback? onPress;
  final String? text;
  final OdinSubSearchFilter? filter;

  @override
  Widget build(BuildContext context) {
    return _Search(
      isFullWidth: switch (kind) {
        OdinSearchTriggerKind.normal => false,
        OdinSearchTriggerKind.fullWidth => true,
      },
      onPress: onPress,
      placeholder: placeholder,
      icon: const Icon(OdinIcons.toolsSearch),
      initialText: text,
      filter: filter,
    );
  }

  @override
  Type get runtimeType => const _SharedType(OdinSearchTrigger, OdinSearch);
}

final class OdinSearch extends StatelessWidget {
  const OdinSearch({
    super.key,
    this.controller,
    this.focusNode,
    this.onPressBack,
    this.onTapOutside,
    this.placeholder,
    this.clearLinkLabel,
    this.shouldAutofocus = true,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onPressBack;
  final TapRegionCallback? onTapOutside;
  final Widget? placeholder;
  final Widget? clearLinkLabel;
  final bool shouldAutofocus;

  @override
  Widget build(BuildContext context) {
    return _Search(
      icon: const Icon(OdinIcons.arrowLeft),
      controller: controller,
      focusNode: focusNode,
      isFullWidth: true,
      onTapOutside: onTapOutside,
      onPressBack: onPressBack,
      placeholder: placeholder,
      shouldAutofocus: shouldAutofocus,
      clearLinkLabel: clearLinkLabel,
      shouldShowClearLink: true,
    );
  }

  @override
  Type get runtimeType => const _SharedType(OdinSearch, OdinSearchTrigger);
}

final class _Search extends StatefulWidget {
  const _Search({
    required this.icon,
    this.controller,
    this.focusNode,
    this.isFullWidth = false,
    this.onPress,
    this.onPressBack,
    this.onTapOutside,
    this.placeholder,
    this.shouldAutofocus = false,
    this.initialText,
    this.filter,
    this.clearLinkLabel,
    this.shouldShowClearLink = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget icon;
  final bool isFullWidth;
  final VoidCallback? onPress;
  final VoidCallback? onPressBack;
  final TapRegionCallback? onTapOutside;
  final Widget? placeholder;
  final bool shouldAutofocus;
  final String? initialText;
  final OdinSubSearchFilter? filter;
  final Widget? clearLinkLabel;
  final bool shouldShowClearLink;

  @override
  State<_Search> createState() => _SearchState();
}

final class _SearchState extends State<_Search> with TickerProviderStateMixin {
  late final AnimationController _focusAnimationController;
  late final Animation<double> _focusAnimation;
  late final AnimationController _fullWidthStateAnimationController;
  late final Animation<double> _fullWidthStateAnimation;

  late FocusNode _focusNode;
  late TextEditingController _textEditingController;

  final _editableTextKey = GlobalKey<EditableTextState>();

  @override
  void initState() {
    super.initState();

    _fullWidthStateAnimationController = AnimationController(
      vsync: this,
      duration: _searchAnimationsDuration,
    );

    _fullWidthStateAnimation = CurvedAnimation(
      parent: _fullWidthStateAnimationController,
      curve: _searchAnimationsCurve,
    );

    _focusAnimationController = AnimationController(
      vsync: this,
      duration: _searchAnimationsDuration,
    );

    _focusAnimation = CurvedAnimation(
      parent: _focusAnimationController,
      curve: _searchAnimationsCurve,
    );

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleChangesInFocusNode);

    _textEditingController = widget.controller ?? TextEditingController(text: widget.initialText);

    if (widget.isFullWidth) {
      _fullWidthStateAnimationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_Search oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null) {
        _focusNode.removeListener(_handleChangesInFocusNode);
        _focusNode.dispose();
      }

      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_handleChangesInFocusNode);
    }

    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _textEditingController.dispose();
      }

      _textEditingController = widget.controller ?? TextEditingController(text: widget.initialText);
    }

    if (widget.isFullWidth && !_fullWidthStateAnimationController.isCompleted) {
      _fullWidthStateAnimationController.forward();
    } else if (!widget.isFullWidth && _fullWidthStateAnimationController.isCompleted) {
      _fullWidthStateAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleChangesInFocusNode);

    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    if (widget.controller == null) {
      _textEditingController.dispose();
    }

    super.dispose();
  }

  void _handleChangesInFocusNode() {
    if (_focusNode.hasFocus) {
      _focusAnimationController.forward();
    } else {
      _focusAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colorScheme = theme.appColorScheme;
    final typography = theme.typography;

    final defaultBackgroundColor = colorScheme.neutralBase;

    return AnimatedBuilder(
      animation: Listenable.merge([_fullWidthStateAnimation, _focusAnimation]),
      builder: (context, child) {
        final borderColor = Color.lerp(
          colorScheme.outlineBase,
          colorScheme.neutralExtended40,
          _fullWidthStateAnimation.value,
        )!;

        final borderSide = OdinBorderSide(
          color: borderColor,
          stroke: 1.0,
          borderStyle: const OdinBorderStyle.solid(),
        );

        const invisibleBorder = OdinBorderSide(
          color: Color(0x00000000),
          stroke: 1.0,
          borderStyle: OdinBorderStyle.solid(),
        );

        final onlyBottomBorder = OdinBorder(
          top: invisibleBorder,
          left: invisibleBorder,
          right: invisibleBorder,
          bottom: borderSide,
        );

        final defaultBorder = OdinBorder.fromOdinBorderSide(borderSide);

        final stateBackgroundColor = Color.lerp(
          defaultBackgroundColor,
          null,
          _fullWidthStateAnimation.value,
        );

        final backgroundColor = Color.lerp(
          stateBackgroundColor,
          colorScheme.actionNeutralFocus,
          _focusAnimation.value,
        );

        return Padding(
          padding: EdgeInsets.lerp(
            const EdgeInsets.symmetric(horizontal: OdinPaddingValue.sm),
            EdgeInsets.zero,
            _fullWidthStateAnimation.value,
          )!,
          child: MouseRegion(
            cursor: SystemMouseCursors.text,
            child: TextFieldTapRegion(
              onTapOutside: widget.onTapOutside,
              child: GestureDetector(
                onTap: () {
                  if (widget.onPress case final onPress?) {
                    onPress();
                  } else {
                    _editableTextKey.currentState!.requestKeyboard();
                  }
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: OdinBorder.lerp(
                      defaultBorder,
                      onlyBottomBorder,
                      _fullWidthStateAnimation.value,
                    ),
                    borderRadius: BorderRadius.lerp(
                      BorderRadius.circular(OdinGapValue.xxxs),
                      null,
                      _fullWidthStateAnimation.value,
                    ),
                  ),
                  child: Material(
                    color: kTransparentColor,
                    child: Padding(
                      padding: EdgeInsets.lerp(
                        const EdgeInsets.symmetric(
                          horizontal: OdinPaddingValue.xs,
                          vertical: OdinPaddingValue.xxs,
                        ),
                        const EdgeInsets.only(
                          left: OdinPaddingValue.sm - kIconButtonExtraSpacing,
                          right: OdinPaddingValue.sm,
                          top: OdinPaddingValue.xs - kIconButtonExtraSpacing,
                          bottom: OdinPaddingValue.xs - kIconButtonExtraSpacing,
                        ),
                        _fullWidthStateAnimation.value,
                      )!,
                      child: ListenableBuilder(
                        listenable: _textEditingController,
                        builder: (context, child) {
                          return Row(
                            children: [
                              child!,
                              SizedBox(
                                width: lerpDouble(
                                  OdinGapValue.xxxs,
                                  0,
                                  _fullWidthStateAnimation.value,
                                ),
                              ),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: widget.onPress != null,
                                  child: ListenableBuilder(
                                    listenable: _focusNode,
                                    builder: (context, child) {
                                      return Stack(
                                        children: [
                                          child!,
                                          if (_textEditingController.text.isEmpty)
                                            if (widget.placeholder case final placeholder?)
                                              DefaultTextStyle(
                                                style: typography.bodyBase.copyWith(
                                                  color: colorScheme.onColorEmphasisLow,
                                                  leadingDistribution: TextLeadingDistribution.even,
                                                ),
                                                child: placeholder,
                                              ),
                                        ],
                                      );
                                    },
                                    child: EditableText(
                                      autofocus: _fullWidthStateAnimationController.isCompleted && widget.shouldAutofocus,
                                      key: _editableTextKey,
                                      controller: _textEditingController,
                                      focusNode: _focusNode,
                                      style: typography.bodyBase.copyWith(
                                        color: colorScheme.onColorEmphasisHigh,
                                        leadingDistribution: TextLeadingDistribution.even,
                                      ),
                                      cursorColor: colorScheme.onColorEmphasisHigh,
                                      backgroundCursorColor: colorScheme.supportAqua50,
                                    ),
                                  ),
                                ),
                              ),
                              OdinGap.xs,
                              if (widget.filter case final filter?) //
                                filter
                              else if (widget.shouldShowClearLink)
                                AnimatedOpacity(
                                  duration: _searchAnimationsDuration,
                                  curve: _searchAnimationsCurve,
                                  opacity: _textEditingController.text.isEmpty ? 0.0 : 1.0,
                                  child: OdinLink(
                                    label: widget.clearLinkLabel ?? const Text('Limpar'),
                                    onPress: _textEditingController.clear,
                                    isUnderline: true,
                                  ),
                                ),
                              OdinGap.xxs,
                            ],
                          );
                        },
                        child: OdinIconButton(
                          icon: widget.icon,
                          minSize: lerpDouble(
                            16.0,
                            kIconButtonSize,
                            _fullWidthStateAnimation.value,
                          ),
                          onPress: widget.onPressBack,
                          color: colorScheme.onColorEmphasisHigh,
                          disabledColor: colorScheme.onColorEmphasisHigh,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

final class OdinSubSearchFilter extends StatelessWidget {
  const OdinSubSearchFilter({
    super.key,
    this.hasActiveFilters = false,
    this.onPress,
  });

  final bool hasActiveFilters;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return OdinLinkTheme(
      data: OdinThemeProvider.of(context).linkTheme.copyWith(
        iconSpacing: OdinGapValue.xxxs,
      ),
      child: OdinLink(
        label: const Text('Filtrar'),
        isUnderline: true,
        onPress: onPress,
        rightIcon: OdinIconContainer(
          icon: OdinIcons.toolsFilter,
          size: OdinIconContainerSize.size24,
          hasNotification: hasActiveFilters,
        ),
      ),
    );
  }
}

// This is a somewhat hacky solution. We had to do this so we can have separate elements for [SearchTrigger] and
// [Search] sharing a same state. This means that, if one replaces [SearchTrigger] with [Search] in the tree, the
// method [Widget.canUpdate] will consider both equals, and will not rebuild the state. Instead, it will call the
// [didUpdateWidget] method from [_Search] and update the state accordingly.
@immutable
final class _SharedType implements Type {
  const _SharedType(this.baseType, this.otherType);

  final Type baseType;
  final Type otherType;

  @override
  bool operator ==(Object other) {
    if (other == baseType || other == otherType) {
      return true;
    } else if (other is _SharedType) {
      return baseType == other.baseType || //
          otherType == other.baseType ||
          otherType == other.baseType ||
          otherType == other.otherType;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(baseType, otherType);
}
