import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

const _searchAnimationsDuration = Duration(milliseconds: 250);
const _searchAnimationsCurve = Curves.easeInOut;

final class OdinInputTag extends StatefulWidget {
  const OdinInputTag({
    super.key,
    this.controller,
    this.focusNode,
    this.onInsert,
    this.onTapOutside,
    this.placeholder,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onInsert;
  final TapRegionCallback? onTapOutside;
  final Widget? placeholder;

  @override
  State<OdinInputTag> createState() => _OdinInputTagState();
}

final class _OdinInputTagState extends State<OdinInputTag> with TickerProviderStateMixin {
  late final AnimationController _focusAnimationController;
  late final Animation<double> _focusAnimation;

  late FocusNode _focusNode;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _focusAnimationController = AnimationController(vsync: this, duration: _searchAnimationsDuration);

    _focusAnimation = CurvedAnimation(
      parent: _focusAnimationController,
      curve: _searchAnimationsCurve,
    );

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleChangesInFocusNode);

    _textEditingController = widget.controller ?? TextEditingController();
  }

  @override
  void didUpdateWidget(OdinInputTag oldWidget) {
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

      _textEditingController = widget.controller ?? TextEditingController();
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

    return AnimatedBuilder(
      animation: _focusAnimation,
      builder: (context, child) {
        final borderColor = colorScheme.outlineBase;

        final borderSide = OdinBorderSide(
          color: borderColor,
          stroke: 1.0,
          borderStyle: const OdinBorderStyle.solid(),
        );

        final defaultBorder = OdinBorder.fromOdinBorderSide(borderSide);

        return MouseRegion(
          cursor: SystemMouseCursors.text,
          child: TextFieldTapRegion(
            onTapOutside: widget.onTapOutside,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.neutralBase,
                border: defaultBorder,
                borderRadius: BorderRadius.circular(OdinGapValue.xxxs),
              ),
              child: Material(
                color: kTransparentColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: OdinPaddingValue.xxs,
                    horizontal: OdinPaddingValue.xs,
                  ),
                  child: ListenableBuilder(
                    listenable: _textEditingController,
                    builder: (context, child) {
                      return Row(
                        children: [
                          child!,
                          OdinGap.xxxs,
                          Expanded(
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
                                          child: IgnorePointer(
                                            child: placeholder,
                                          ),
                                        ),
                                  ],
                                );
                              },
                              child: EditableText(
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
                          OdinGap.xs,
                          AnimatedOpacity(
                            duration: _searchAnimationsDuration,
                            curve: _searchAnimationsCurve,
                            opacity: _textEditingController.text.isEmpty ? 0.0 : 1.0,
                            child: OdinLink(
                              label: const Text('Inserir'),
                              isUnderline: true,
                              onPress: () {
                                widget.onInsert?.call();
                                _textEditingController.clear();
                              },
                            ),
                          ),
                          OdinGap.xxs,
                        ],
                      );
                    },
                    child: const OdinIconContainer(
                      icon: OdinIcons.toolsSearch,
                      size: OdinIconContainerSize.size24,
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
