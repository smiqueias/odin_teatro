import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

enum OdinGlobalImageComboSize {
  size32,
  size40,
}

class OdinGlobalImageCombo extends StatelessWidget {
  const OdinGlobalImageCombo({
    required this.imageContainers,
    super.key,
    this.size,
    this.maxItems = 5,
    this.maxHiddenItemsFeedback = 9,
  });

  final List<OdinImageContainer> imageContainers;
  final OdinGlobalImageComboSize? size;
  final int maxItems;
  final int maxHiddenItemsFeedback;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size ?? OdinGlobalImageComboTheme.of(context).size;
    final imageContainerSize = switch (resolvedSize) {
      OdinGlobalImageComboSize.size32 => OdinImageContainerSize.size32,
      OdinGlobalImageComboSize.size40 => OdinImageContainerSize.size40,
    };

    return OdinGlobalImageComboBase(
      imageContainers: imageContainers,
      imageContainerSize: imageContainerSize,
      maxItems: maxItems,
      maxHiddenItemsFeedback: maxHiddenItemsFeedback,
    );
  }
}

class OdinGlobalImageComboBase extends StatelessWidget {
  const OdinGlobalImageComboBase({
    required this.imageContainers,
    required this.imageContainerSize,
    required this.maxItems,
    required this.maxHiddenItemsFeedback,
    super.key,
  });

  final List<OdinImageContainer> imageContainers;
  final OdinImageContainerSize imageContainerSize;
  final int maxItems;
  final int maxHiddenItemsFeedback;

  @override
  Widget build(BuildContext context) {
    assert(imageContainers.isNotEmpty, 'The images list must have at least one item.');

    final theme = OdinThemeProvider.of(context);

    final numberOfImagesToShow = imageContainers.length <= maxItems ? imageContainers.length : maxItems - 1;
    final numberOfImagesToHide = imageContainers.length - numberOfImagesToShow;

    final shouldUseLargeText = numberOfImagesToHide < 10 || maxHiddenItemsFeedback < 10;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: OdinImageContainerTheme(
        data: OdinImageContainerTheme.of(context).copyWith(
          size: imageContainerSize,
          shape: OdinImageContainerShape.rounded,
        ),
        child: Stack(
          children: [
            if (numberOfImagesToHide > 0)
              Padding(
                padding: EdgeInsets.only(
                  left: _getLeftSpacingFor(0, numberOfImagesToShow + 1, imageContainerSize.value),
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: imageContainerSize.value,
                  height: imageContainerSize.value,
                  decoration: BoxDecoration(
                    color: theme.appColorScheme.neutralBase,
                    border: OdinBorder.all(
                      color: theme.appColorScheme.outlineBase,
                      stroke: theme.borderTheme.strokeThin,
                    ),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.only(
                    left: imageContainerSize.value * 0.25,
                    right: 2.0,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      numberOfImagesToHide <= maxHiddenItemsFeedback ? '+$numberOfImagesToHide' : '$maxHiddenItemsFeedback+',
                      style: shouldUseLargeText ? theme.typography.labelSmall : theme.typography.labelTiny,
                    ),
                  ),
                ),
              ),
            for (int i = 0; i < numberOfImagesToShow; i++)
              Padding(
                padding: EdgeInsets.only(
                  left: _getLeftSpacingFor(i, numberOfImagesToShow, imageContainerSize.value),
                ),
                child: imageContainers[i],
              ),
          ],
        ),
      ),
    );
  }

  double _getLeftSpacingFor(int itemIndex, int totalItems, double imageContainerSize) {
    return (totalItems - 1 - itemIndex) * imageContainerSize * 0.75;
  }
}

final class OdinGlobalImageComboTheme extends InheritedTheme {
  const OdinGlobalImageComboTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinGlobalImageComboThemeData data;

  static OdinGlobalImageComboThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinGlobalImageComboTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).globalImageComboTheme;
  }

  @override
  bool updateShouldNotify(OdinGlobalImageComboTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinGlobalImageComboTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinGlobalImageComboThemeData {
  OdinGlobalImageComboThemeData({
    required this.size,
  });

  final OdinGlobalImageComboSize size;

  static OdinGlobalImageComboThemeData lerp(
    OdinGlobalImageComboThemeData a,
    OdinGlobalImageComboThemeData b,
    double t,
  ) {
    return OdinGlobalImageComboThemeData(
      size: t < 0.5 ? a.size : b.size,
    );
  }

  OdinGlobalImageComboThemeData copyWith({
    OdinGlobalImageComboSize? size,
  }) {
    return OdinGlobalImageComboThemeData(
      size: size ?? this.size,
    );
  }
}

OdinGlobalImageComboThemeData createDefaultGlobalImageComboTheme({
  required OdinColorScheme colorScheme,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  return OdinGlobalImageComboThemeData(
    size: OdinGlobalImageComboSize.size32,
  );
}
