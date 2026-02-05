import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

class OdinGlobalLockScreen extends StatelessWidget {
  const OdinGlobalLockScreen({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: getColor(context),
      child: child ?? const SizedBox.expand(),
    );
  }

  static Color getColor(BuildContext context) {
    return OdinThemeProvider.of(context).appColorScheme.specialFixedBlack.withValues(
      alpha: 0.5,
    );
  }
}
