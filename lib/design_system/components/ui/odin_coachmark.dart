import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

class OdinCoachmark extends StatelessWidget {
  const OdinCoachmark({
    super.key,
    this.title,
    this.paragraph,
    this.primaryActionSettings,
    this.secondaryActionSettings,
  });

  final String? title;
  final String? paragraph;
  final OdinActionSettings<VoidCallback>? primaryActionSettings;
  final OdinActionSettings<VoidCallback>? secondaryActionSettings;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);

    return Padding(
      padding: const EdgeInsets.all(OdinPaddingValue.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title case final title?)
            Text(
              title,
              style: theme.typography.titleSmall.copyWith(
                color: theme.appColorScheme.onColorEmphasisHigh,
              ),
            ),
          if (paragraph case final paragraph?) ...[
            OdinGap.xxs,
            Text(
              paragraph,
              style: theme.typography.titleSmall.copyWith(
                color: theme.appColorScheme.onColorEmphasisMedium,
              ),
            ),
          ],
          OdinGap.sm,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (secondaryActionSettings case final secondaryActionSettings?)
                OdinButton.fromActionSettings(
                  actionSettings: secondaryActionSettings,
                  kind: OdinButtonKind.line,
                  size: OdinButtonSize.compact,
                ),
              OdinGap.xs,
              if (primaryActionSettings case final primaryActionSettings?)
                OdinButton.fromActionSettings(
                  actionSettings: primaryActionSettings,
                  size: OdinButtonSize.compact,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
