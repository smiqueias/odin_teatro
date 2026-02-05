import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/models/semantics_data.dart';

final class OdinActionSettings<T extends Function> {
  const OdinActionSettings({
    required this.text,
    this.leftIcon,
    this.rightIcon,
    this.onPress,
    this.semantics = const OdinSemanticsData(),
  });

  final String text;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final T? onPress;
  final OdinSemanticsData semantics;

  OdinActionSettings<T> copyWith({
    String? text,
    IconData? leftIcon,
    IconData? rightIcon,
    T? onPress,
    OdinSemanticsData? semantics,
  }) {
    return OdinActionSettings(
      text: text ?? this.text,
      leftIcon: leftIcon ?? this.leftIcon,
      rightIcon: rightIcon ?? this.rightIcon,
      onPress: onPress ?? this.onPress,
      semantics: semantics ?? this.semantics,
    );
  }
}

final class OdinIconActionSettings {
  const OdinIconActionSettings({
    required this.icon,
    this.onPress,
  });

  final IconData icon;
  final VoidCallback? onPress;

  OdinIconActionSettings copyWith({
    IconData? icon,
    VoidCallback? onPress,
  }) {
    return OdinIconActionSettings(
      icon: icon ?? this.icon,
      onPress: onPress ?? this.onPress,
    );
  }
}
