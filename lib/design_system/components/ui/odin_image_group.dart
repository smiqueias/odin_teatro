import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

enum OdinImageGroupSize {
  small(40.0),
  medium(48.0),
  large(64.0)
  ;

  const OdinImageGroupSize(this.value);

  final double value;
}

const _fixedOdinImageContainerSize = OdinImageContainerSize.size24;
const _fixedOdinIconContainerCircleSize = OdinIconContainerCircleSize.size24;
const _fixedOdinAvatarSize = OdinAvatarSize.size24;

sealed class OdinImageGroupKind {
  const OdinImageGroupKind();

  const factory OdinImageGroupKind.iconIcon({
    required OdinIconContainerCircle primaryIcon,
    required OdinIconContainerCircle secondaryIcon,
  }) = OdinImageGroupKindIconIcon;

  const factory OdinImageGroupKind.iconImage({
    required OdinIconContainerCircle icon,
    required OdinImageContainer image,
  }) = OdinImageGroupKindIconImage;

  const factory OdinImageGroupKind.iconAvatar({
    required OdinIconContainerCircle icon,
    required OdinAvatar avatar,
  }) = OdinImageGroupKindIconAvatar;

  const factory OdinImageGroupKind.imageImage({
    required OdinImageContainer primaryImage,
    required OdinImageContainer secondaryImage,
  }) = OdinImageGroupKindImageImage;

  const factory OdinImageGroupKind.imageIcon({
    required OdinImageContainer image,
    required OdinIconContainerCircle icon,
  }) = OdinImageGroupKindImageIcon;

  const factory OdinImageGroupKind.imageAvatar({
    required OdinImageContainer image,
    required OdinAvatar avatar,
  }) = OdinImageGroupKindImageAvatar;

  const factory OdinImageGroupKind.avatarAvatar({
    required OdinAvatar primaryAvatar,
    required OdinAvatar secondaryAvatar,
  }) = OdinImageGroupKindAvatarAvatar;

  const factory OdinImageGroupKind.avatarIcon({
    required OdinAvatar avatar,
    required OdinIconContainerCircle icon,
  }) = OdinImageGroupKindAvatarIcon;

  const factory OdinImageGroupKind.avatarImage({
    required OdinAvatar avatar,
    required OdinImageContainer image,
  }) = OdinImageGroupKindAvatarImage;
}

final class OdinImageGroupKindIconIcon extends OdinImageGroupKind {
  const OdinImageGroupKindIconIcon({required this.primaryIcon, required this.secondaryIcon});

  final OdinIconContainerCircle primaryIcon;
  final OdinIconContainerCircle secondaryIcon;
}

final class OdinImageGroupKindIconImage extends OdinImageGroupKind {
  const OdinImageGroupKindIconImage({required this.icon, required this.image});

  final OdinIconContainerCircle icon;
  final OdinImageContainer image;
}

final class OdinImageGroupKindIconAvatar extends OdinImageGroupKind {
  const OdinImageGroupKindIconAvatar({required this.icon, required this.avatar});

  final OdinIconContainerCircle icon;
  final OdinAvatar avatar;
}

final class OdinImageGroupKindImageImage extends OdinImageGroupKind {
  const OdinImageGroupKindImageImage({required this.primaryImage, required this.secondaryImage});

  final OdinImageContainer primaryImage;
  final OdinImageContainer secondaryImage;
}

final class OdinImageGroupKindImageIcon extends OdinImageGroupKind {
  const OdinImageGroupKindImageIcon({required this.image, required this.icon});

  final OdinImageContainer image;
  final OdinIconContainerCircle icon;
}

final class OdinImageGroupKindAvatarIcon extends OdinImageGroupKind {
  const OdinImageGroupKindAvatarIcon({required this.avatar, required this.icon});

  final OdinAvatar avatar;
  final OdinIconContainerCircle icon;
}

final class OdinImageGroupKindImageAvatar extends OdinImageGroupKind {
  const OdinImageGroupKindImageAvatar({required this.image, required this.avatar});

  final OdinImageContainer image;
  final OdinAvatar avatar;
}

final class OdinImageGroupKindAvatarAvatar extends OdinImageGroupKind {
  const OdinImageGroupKindAvatarAvatar({required this.primaryAvatar, required this.secondaryAvatar});

  final OdinAvatar primaryAvatar;
  final OdinAvatar secondaryAvatar;
}

final class OdinImageGroupKindAvatarImage extends OdinImageGroupKind {
  const OdinImageGroupKindAvatarImage({required this.avatar, required this.image});

  final OdinAvatar avatar;
  final OdinImageContainer image;
}

class OdinImageGroup extends StatelessWidget {
  const OdinImageGroup({
    required this.kind,
    super.key,
    this.size,
  });

  final OdinImageGroupSize? size;
  final OdinImageGroupKind kind;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);

    final size = this.size ?? OdinImageGroupTheme.of(context).size;

    final resolvedIconSize = switch (size) {
      OdinImageGroupSize.small => OdinIconContainerCircleSize.size32,
      OdinImageGroupSize.medium => OdinIconContainerCircleSize.size40,
      OdinImageGroupSize.large => OdinIconContainerCircleSize.size64,
    };

    final resolvedImageSize = switch (size) {
      OdinImageGroupSize.small => OdinImageContainerSize.size32,
      OdinImageGroupSize.medium => OdinImageContainerSize.size40,
      OdinImageGroupSize.large => OdinImageContainerSize.size64,
    };

    final resolvedAvatarSize = switch (size) {
      OdinImageGroupSize.small => OdinAvatarSize.size32,
      OdinImageGroupSize.medium => OdinAvatarSize.size40,
      OdinImageGroupSize.large => OdinAvatarSize.size64,
    };

    final (primaryWidget, secondaryWidget) = switch (kind) {
      OdinImageGroupKindIconIcon(:final primaryIcon, :final secondaryIcon) => (
        OdinIconContainerTheme(
          data: OdinIconContainerTheme.of(context).copyWith(
            circleSize: resolvedIconSize,
          ),
          child: primaryIcon,
        ),
        OdinIconContainerTheme(
          data: OdinIconContainerTheme.of(context).copyWith(
            circleSize: _fixedOdinIconContainerCircleSize,
          ),
          child: secondaryIcon,
        ),
      ),
      OdinImageGroupKindIconImage(:final icon, :final image) => (
        OdinIconContainerTheme(
          data: OdinIconContainerTheme.of(context).copyWith(
            circleSize: resolvedIconSize,
          ),
          child: icon,
        ),
        OdinImageContainerTheme(
          data: OdinImageContainerTheme.of(context).copyWith(
            size: _fixedOdinImageContainerSize,
            shape: OdinImageContainerShape.rounded,
          ),
          child: image,
        ),
      ),
      OdinImageGroupKindIconAvatar(:final icon, :final avatar) => (
        OdinIconContainerTheme(
          data: OdinIconContainerTheme.of(context).copyWith(
            circleSize: resolvedIconSize,
          ),
          child: icon,
        ),
        OdinAvatarTheme(
          data: OdinAvatarTheme.of(context).copyWith(
            size: _fixedOdinAvatarSize,
          ),
          child: avatar,
        ),
      ),
      OdinImageGroupKindImageImage(:final primaryImage, :final secondaryImage) => (
        OdinImageContainerTheme(
          data: OdinImageContainerTheme.of(context).copyWith(
            size: resolvedImageSize,
            shape: OdinImageContainerShape.rounded,
          ),
          child: primaryImage,
        ),
        OdinImageContainerTheme(
          data: OdinImageContainerTheme.of(context).copyWith(
            size: _fixedOdinImageContainerSize,
            shape: OdinImageContainerShape.rounded,
          ),
          child: secondaryImage,
        ),
      ),
      OdinImageGroupKindImageIcon(:final image, :final icon) => (
        OdinImageContainerTheme(
          data: OdinImageContainerTheme.of(context).copyWith(
            size: resolvedImageSize,
            shape: OdinImageContainerShape.rounded,
          ),
          child: image,
        ),
        OdinIconContainerTheme(
          data: OdinIconContainerTheme.of(context).copyWith(
            circleSize: _fixedOdinIconContainerCircleSize,
          ),
          child: icon,
        ),
      ),
      OdinImageGroupKindImageAvatar(:final image, :final avatar) => (
        OdinImageContainerTheme(
          data: OdinImageContainerTheme.of(context).copyWith(
            size: resolvedImageSize,
            shape: OdinImageContainerShape.rounded,
          ),
          child: image,
        ),
        OdinAvatarTheme(
          data: OdinAvatarTheme.of(context).copyWith(
            size: _fixedOdinAvatarSize,
          ),
          child: avatar,
        ),
      ),
      OdinImageGroupKindAvatarAvatar(:final primaryAvatar, :final secondaryAvatar) => (
        OdinAvatarTheme(
          data: OdinAvatarTheme.of(context).copyWith(
            size: resolvedAvatarSize,
          ),
          child: primaryAvatar,
        ),
        OdinAvatarTheme(
          data: OdinAvatarTheme.of(context).copyWith(
            size: _fixedOdinAvatarSize,
          ),
          child: secondaryAvatar,
        ),
      ),
      OdinImageGroupKindAvatarIcon(:final avatar, :final icon) => (
        OdinAvatarTheme(
          data: OdinAvatarTheme.of(context).copyWith(
            size: resolvedAvatarSize,
          ),
          child: avatar,
        ),
        OdinIconContainerTheme(
          data: OdinIconContainerTheme.of(context).copyWith(
            circleSize: _fixedOdinIconContainerCircleSize,
          ),
          child: icon,
        ),
      ),
      OdinImageGroupKindAvatarImage(:final avatar, :final image) => (
        OdinAvatarTheme(
          data: OdinAvatarTheme.of(context).copyWith(
            size: resolvedAvatarSize,
          ),
          child: avatar,
        ),
        OdinImageContainerTheme(
          data: OdinImageContainerTheme.of(context).copyWith(
            size: _fixedOdinImageContainerSize,
            shape: OdinImageContainerShape.rounded,
          ),
          child: image,
        ),
      ),
    };

    return SizedBox.fromSize(
      size: Size.square(size.value),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.appColorScheme.neutralBase,
                border: OdinBorder.all(
                  color: theme.appColorScheme.outlineBase,
                  stroke: theme.borderTheme.strokeThin,
                ),
                shape: BoxShape.circle,
              ),
              child: primaryWidget,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.appColorScheme.neutralBase,
                border: OdinBorder.all(
                  color: theme.appColorScheme.outlineBase,
                  stroke: theme.borderTheme.strokeThin,
                ),
                shape: BoxShape.circle,
              ),
              child: secondaryWidget,
            ),
          ),
        ],
      ),
    );
  }
}

final class OdinImageGroupTheme extends InheritedTheme {
  const OdinImageGroupTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinImageGroupThemeData data;

  static OdinImageGroupThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinImageGroupTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).imageGroupTheme;
  }

  @override
  bool updateShouldNotify(OdinImageGroupTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinImageGroupTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinImageGroupThemeData {
  OdinImageGroupThemeData({
    required this.size,
  });

  final OdinImageGroupSize size;

  static OdinImageGroupThemeData lerp(
    OdinImageGroupThemeData a,
    OdinImageGroupThemeData b,
    double t,
  ) {
    return OdinImageGroupThemeData(
      size: t < 0.5 ? a.size : b.size,
    );
  }

  OdinImageGroupThemeData copyWith({
    OdinImageGroupSize? size,
  }) {
    return OdinImageGroupThemeData(
      size: size ?? this.size,
    );
  }
}

OdinImageGroupThemeData createDefaultImageGroupTheme({
  required OdinColorScheme colorScheme,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  return OdinImageGroupThemeData(
    size: OdinImageGroupSize.medium,
  );
}
