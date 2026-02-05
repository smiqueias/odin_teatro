import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/components/feedback/ink_well.dart';
import 'package:odin_teatro/design_system/components/feedback/show_modal.dart';
import 'package:odin_teatro/design_system/components/ui/odin_icon_container.dart';
import 'package:odin_teatro/design_system/components/ui/odin_modal.dart';
import 'package:odin_teatro/design_system/components/ui/odin_tooltip.dart';
import 'package:odin_teatro/design_system/foundation/icons.dart';
import 'package:odin_teatro/design_system/models/action_settings.dart';

final class OdinInformativeIcon extends StatelessWidget {
  OdinInformativeIcon.modalAction({
    required String title,
    required String message,
    super.key,
    this.color,
    this.size = OdinIconContainerSize.size16,
    RouteSettings? routeSettings,
    OdinActionSettings<VoidCallback>? primaryAction,
  }) : actionKind = _OdinIconInfoActionKind.modal(
         title: title,
         message: message,
         primaryAction: primaryAction,
         routeSettings: routeSettings,
       );

  OdinInformativeIcon.tooltipAction({
    required OdinTooltipAlignment alignment,
    required OdinTooltipPosition position,
    required String message,
    super.key,
    this.color,
    this.size = OdinIconContainerSize.size16,
  }) : actionKind = _OdinIconInfoActionKind.tooltip(
         alignment: alignment,
         position: position,
         message: message,
       );

  OdinInformativeIcon.customAction({
    required VoidCallback onPress,
    super.key,
    this.color,
    this.size = OdinIconContainerSize.size16,
  }) : actionKind = _OdinIconInfoActionKind.custom(onPress: onPress);

  final _OdinIconInfoActionKind actionKind;
  final Color? color;
  final OdinIconContainerSize size;

  @override
  Widget build(BuildContext context) {
    final icon = IconTheme.merge(
      data: const IconThemeData(applyTextScaling: true),
      child: OdinIconContainer(
        icon: OdinIcons.info,
        color: color,
        size: size,
      ),
    );

    return switch (actionKind) {
      OdinIconInfoActionKindModal(
        :final title,
        :final message,
        :final primaryAction,
        :final routeSettings,
      ) =>
        OdinInkWell.outsideResponse(
          onTap: () {
            showOdinModal<void>(
              context: context,
              routeSettings: routeSettings,
              builder: (context) {
                return OdinModal.defaultContent(
                  title: Text(title),
                  paragraph: Text(message),
                  primaryAction: primaryAction,
                );
              },
            );
          },
          child: icon,
        ),
      OdinIconInfoActionKindTooltip(:final alignment, :final position, :final message) => OdinTooltip.defaultContent(
        alignment: alignment,
        position: position,
        label: message,
        child: icon,
      ),
      OdinIconInfoActionKindCustom(:final onPress) => OdinInkWell.outsideResponse(
        onTap: onPress,
        child: icon,
      ),
    };
  }
}

sealed class _OdinIconInfoActionKind {
  const _OdinIconInfoActionKind();

  const factory _OdinIconInfoActionKind.modal({
    required String title,
    required String message,
    required OdinActionSettings<VoidCallback>? primaryAction,
    RouteSettings? routeSettings,
  }) = OdinIconInfoActionKindModal;

  const factory _OdinIconInfoActionKind.tooltip({
    required OdinTooltipAlignment alignment,
    required OdinTooltipPosition position,
    required String message,
  }) = OdinIconInfoActionKindTooltip;

  const factory _OdinIconInfoActionKind.custom({
    required VoidCallback onPress,
  }) = OdinIconInfoActionKindCustom;
}

final class OdinIconInfoActionKindModal extends _OdinIconInfoActionKind {
  const OdinIconInfoActionKindModal({
    required this.title,
    required this.message,
    required this.primaryAction,
    this.routeSettings,
  });

  final String title;
  final String message;
  final OdinActionSettings<VoidCallback>? primaryAction;
  final RouteSettings? routeSettings;
}

final class OdinIconInfoActionKindTooltip extends _OdinIconInfoActionKind {
  const OdinIconInfoActionKindTooltip({
    required this.alignment,
    required this.position,
    required this.message,
  });

  final OdinTooltipAlignment alignment;
  final OdinTooltipPosition position;
  final String message;
}

final class OdinIconInfoActionKindCustom extends _OdinIconInfoActionKind {
  const OdinIconInfoActionKindCustom({
    required this.onPress,
  });

  final VoidCallback onPress;
}
