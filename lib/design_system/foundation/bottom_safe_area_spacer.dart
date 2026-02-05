import 'package:flutter/widgets.dart';

final class OdinBottomSafeAreaSpacer extends StatelessWidget {
  const OdinBottomSafeAreaSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.paddingOf(context).bottom);
  }
}

final class OdinSliverBottomSafeAreaSpacer extends StatelessWidget {
  const OdinSliverBottomSafeAreaSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(height: MediaQuery.paddingOf(context).bottom),
    );
  }
}
