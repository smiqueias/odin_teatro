import 'dart:math';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odin_teatro/design_system/color_scheme/color_scheme.dart';
import 'package:odin_teatro/design_system/color_scheme/color_scheme_provider.dart';
import 'package:odin_teatro/design_system/components/ui/odin_avatar.dart';
import 'package:odin_teatro/design_system/components/ui/odin_border.dart';
import 'package:odin_teatro/design_system/components/ui/odin_icon_button.dart';
import 'package:odin_teatro/design_system/components/ui/odin_search.dart';
import 'package:odin_teatro/design_system/foundation/color_util.dart';
import 'package:odin_teatro/design_system/foundation/constants.dart';
import 'package:odin_teatro/design_system/foundation/icons.dart';
import 'package:odin_teatro/design_system/foundation/spacing.dart';
import 'package:odin_teatro/design_system/foundation/typography.dart';
import 'package:intersperse/intersperse.dart';

final class OdinNavBar extends StatelessWidget implements PreferredSizeWidget {
  const OdinNavBar({
    super.key,
    this.title,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.hasBackButton = true,
    this.leftPadding = OdinPaddingValue.sm,
    this.rightPadding = OdinPaddingValue.sm,
    this.actionsSpacing = OdinGapValue.xs,
    this.onTapBack,
    this.bottom,
    this.bottomOpacity = 1.0,
  });

  final Widget? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool hasBackButton;
  final double leftPadding;
  final double rightPadding;
  final double actionsSpacing;
  final VoidCallback? onTapBack;
  final PreferredSizeWidget? bottom;
  final double bottomOpacity;

  @override
  Size get preferredSize => const Size.fromHeight(kNavBarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = OdinNavBarTheme.of(context);

    final effectiveBackgroundColor = backgroundColor ?? theme.backgroundColor;
    final effectiveForegroundColor = foregroundColor ?? theme.foregroundColor;

    return OdinIconButtonTheme(
      data: OdinIconButtonTheme.of(context).copyWith(
        color: effectiveForegroundColor,
        iconSize: 24.0,
      ),
      child: AppBar(
        title: _NavBarTitle(
          hasBackButton: hasBackButton,
          leftPadding: leftPadding,
          title: title,
          onTapBack: onTapBack,
        ),
        titleSpacing: 0.0,
        titleTextStyle: theme.titleTextStyle.copyWith(color: effectiveForegroundColor),
        actions: [
          if (actions case final actions?)
            ...intersperse(
              SizedBox(width: actionsSpacing),
              [
                for (final action in actions)
                  Center(
                    child: action,
                  ),
              ],
            ),
          SizedBox(width: rightPadding),
        ],
        actionsIconTheme: IconThemeData(
          color: effectiveForegroundColor,
          size: 24.0,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: Colors.red,
        elevation: 0.0,
        leadingWidth: 0.0,
        bottom: bottom,
        bottomOpacity: bottomOpacity,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: theme.statusBarColor,
          statusBarIconBrightness: theme.statusBarIconBrightness,
          statusBarBrightness: theme.statusBarBrightness,
        ),
      ),
    );
  }
}

class OdinSliverNavBar extends StatelessWidget implements PreferredSizeWidget {
  const OdinSliverNavBar({
    super.key,
    this.title,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.hasBackButton = true,
    this.leftPadding = OdinPaddingValue.sm,
    this.rightPadding = OdinPaddingValue.sm,
    this.onTapBack,
    this.flexibleSpace,
    this.bottom,
    this.collapsedHeight,
    this.expandedHeight,
    this.floating = false,
    this.pinned = false,
    this.snap = false,
    this.stretch = false,
  });

  final Widget? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool hasBackButton;
  final double leftPadding;
  final double rightPadding;
  final VoidCallback? onTapBack;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? collapsedHeight;
  final double? expandedHeight;
  final bool floating;
  final bool pinned;
  final bool snap;
  final bool stretch;

  @override
  Size get preferredSize => const Size.fromHeight(kNavBarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = OdinNavBarTheme.of(context);

    final effectiveBackgroundColor = backgroundColor ?? theme.backgroundColor;
    final effectiveForegroundColor = foregroundColor ?? theme.foregroundColor;

    return OdinIconButtonTheme(
      data: OdinIconButtonTheme.of(context).copyWith(
        color: effectiveForegroundColor,
        iconSize: 24.0,
      ),
      child: SliverAppBar(
        title: _NavBarTitle(
          hasBackButton: hasBackButton,
          leftPadding: leftPadding,
          title: title,
          onTapBack: onTapBack,
        ),
        titleSpacing: 0.0,
        titleTextStyle: theme.titleTextStyle,
        actions: [
          if (actions case final actions?) ...actions,
          SizedBox(width: rightPadding),
        ],
        actionsIconTheme: IconThemeData(
          color: effectiveForegroundColor,
          size: 24.0,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
        elevation: 0.0,
        leadingWidth: 0.0,
        flexibleSpace: flexibleSpace,
        bottom: bottom,
        collapsedHeight: collapsedHeight,
        expandedHeight: expandedHeight,
        floating: floating,
        pinned: pinned,
        snap: snap,
        stretch: stretch,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: theme.statusBarColor,
          statusBarIconBrightness: theme.statusBarIconBrightness,
          statusBarBrightness: theme.statusBarBrightness,
        ),
      ),
    );
  }
}

class _NavBarTitle extends StatelessWidget {
  const _NavBarTitle({
    required this.hasBackButton,
    required this.leftPadding,
    required this.title,
    this.onTapBack,
  });

  final bool hasBackButton;
  final double leftPadding;
  final Widget? title;
  final VoidCallback? onTapBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (hasBackButton)
          Semantics(
            label: 'Voltar',
            child: Padding(
              padding: EdgeInsets.only(left: max(0.0, leftPadding - kIconButtonExtraSpacing)),
              child: OdinIconButton(
                icon: const Icon(OdinIcons.arrowLeft),
                onPress: onTapBack ?? Navigator.of(context).maybePop,
              ),
            ),
          )
        else
          OdinGap.sm,
        if (title case final title?)
          Expanded(
            child: title,
          ),
      ],
    );
  }
}

class OdinNavBarHome extends StatelessWidget implements PreferredSizeWidget {
  const OdinNavBarHome({
    required this.avatar,
    required this.personName,
    super.key,
    this.actions,
    this.hasText = true,
    this.leftPadding = OdinPaddingValue.sm,
    this.rightPadding = OdinPaddingValue.sm,
    this.onPress,
  });

  final OdinAvatar avatar;
  final String personName;
  final bool hasText;
  final List<Widget>? actions;
  final double leftPadding;
  final double rightPadding;
  final VoidCallback? onPress;

  String get greetingText {
    return switch (clock.now().hour) {
      >= 0 && < 12 => 'Bom dia,',
      >= 12 && < 18 => 'Boa tarde,',
      _ => 'Boa noite,',
    };
  }

  @override
  Size get preferredSize => const Size.fromHeight(kNavBarHeight);

  @override
  Widget build(BuildContext context) {
    final navBarTheme = OdinNavBarTheme.of(context);

    return OdinIconButtonTheme(
      data: OdinIconButtonTheme.of(context).copyWith(
        color: navBarTheme.foregroundColor,
        iconSize: 24.0,
      ),
      child: AppBar(
        backgroundColor: navBarTheme.backgroundColor,
        foregroundColor: navBarTheme.foregroundColor,
        elevation: 0.0,
        leadingWidth: 0.0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPress,
          child: Row(
            children: [
              SizedBox(width: leftPadding),
              OdinAvatarTheme(
                data: OdinAvatarTheme.of(context).copyWith(
                  hasOutline: false,
                  size: OdinAvatarSize.size40,
                ),
                child: avatar,
              ),
              OdinGap.xxs,
              if (hasText)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(greetingText),
                      Row(
                        children: [
                          Flexible(
                            child: Text(personName),
                          ),
                          OdinGap.xxxs,
                          const Icon(
                            OdinIcons.chevronRight,
                            size: 16.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        titleSpacing: 0.0,
        titleTextStyle: navBarTheme.homeTitleTextStyle.copyWith(color: navBarTheme.foregroundColor),
        actions: [
          if (actions case final actions?) ...actions,
          SizedBox(width: rightPadding),
        ],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: navBarTheme.statusBarColor,
          statusBarIconBrightness: navBarTheme.statusBarIconBrightness,
          statusBarBrightness: navBarTheme.statusBarBrightness,
        ),
      ),
    );
  }
}

class OdinNavBarLogo extends StatelessWidget implements PreferredSizeWidget {
  const OdinNavBarLogo({
    required this.logoImage,
    super.key,
    this.inverseLogoImage,
  });

  final Widget? logoImage;
  final Widget? inverseLogoImage;

  @override
  Size get preferredSize => const Size.fromHeight(kNavBarHeight);

  @override
  Widget build(BuildContext context) {
    final navBarTheme = OdinNavBarTheme.of(context);

    final resolvedImage = OdinThemeProvider.of(context).isInverse && inverseLogoImage != null ? inverseLogoImage : logoImage;

    return OdinIconButtonTheme(
      data: OdinIconButtonTheme.of(context).copyWith(
        color: navBarTheme.foregroundColor,
        iconSize: 24.0,
      ),
      child: AppBar(
        backgroundColor: navBarTheme.backgroundColor,
        foregroundColor: navBarTheme.foregroundColor,
        elevation: 0.0,
        leadingWidth: 0.0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: OdinPaddingValue.sm,
            vertical: OdinPaddingValue.xxs,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 40.0),
            child: resolvedImage ?? const SizedBox.shrink(),
          ),
        ),
        titleSpacing: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: navBarTheme.statusBarColor,
          statusBarIconBrightness: navBarTheme.statusBarIconBrightness,
          statusBarBrightness: navBarTheme.statusBarBrightness,
        ),
      ),
    );
  }
}

class OdinNavBarSearch extends StatelessWidget implements PreferredSizeWidget {
  const OdinNavBarSearch({
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
  Size get preferredSize => const Size.fromHeight(kNavBarHeight);

  @override
  Widget build(BuildContext context) {
    final navBarTheme = OdinNavBarTheme.of(context);

    return AppBar(
      backgroundColor: navBarTheme.searchBackgroundColor,
      foregroundColor: navBarTheme.foregroundColor,
      elevation: 0.0,
      leadingWidth: 0.0,
      automaticallyImplyLeading: false,
      title: OdinSearch(
        controller: controller,
        focusNode: focusNode,
        onPressBack: onPressBack ?? () => Navigator.of(context).maybePop(),
        onTapOutside: onTapOutside,
        placeholder: placeholder ?? const Text('Pesquisar'),
        clearLinkLabel: clearLinkLabel,
        shouldAutofocus: shouldAutofocus,
      ),
      titleSpacing: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: navBarTheme.statusBarColor,
        statusBarIconBrightness: navBarTheme.statusBarIconBrightness,
        statusBarBrightness: navBarTheme.statusBarBrightness,
      ),
    );
  }
}

final class OdinNavBarTheme extends InheritedTheme {
  const OdinNavBarTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final OdinNavBarThemeData data;

  static OdinNavBarThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<OdinNavBarTheme>();
    return theme?.data ?? OdinThemeProvider.of(context).navBarTheme;
  }

  @override
  bool updateShouldNotify(OdinNavBarTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OdinNavBarTheme(
      data: data,
      child: child,
    );
  }
}

final class OdinNavBarThemeData {
  OdinNavBarThemeData({
    required this.statusBarColor,
    required this.statusBarIconBrightness,
    required this.statusBarBrightness,
    required this.titleTextStyle,
    required this.homeTitleTextStyle,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.searchBackgroundColor,
  });

  final Color statusBarColor;
  final Brightness statusBarIconBrightness;
  final Brightness statusBarBrightness;
  final TextStyle titleTextStyle;
  final TextStyle homeTitleTextStyle;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color searchBackgroundColor;

  static OdinNavBarThemeData lerp(OdinNavBarThemeData a, OdinNavBarThemeData b, double t) {
    return OdinNavBarThemeData(
      statusBarColor: Color.lerp(a.statusBarColor, b.statusBarColor, t)!,
      statusBarIconBrightness: t < 0.5 ? a.statusBarIconBrightness : b.statusBarIconBrightness,
      statusBarBrightness: t < 0.5 ? a.statusBarBrightness : b.statusBarBrightness,
      titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t)!,
      homeTitleTextStyle: TextStyle.lerp(a.homeTitleTextStyle, b.homeTitleTextStyle, t)!,
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t)!,
      searchBackgroundColor: Color.lerp(a.searchBackgroundColor, b.searchBackgroundColor, t)!,
    );
  }

  OdinNavBarThemeData copyWith({
    Color? statusBarColor,
    Brightness? statusBarIconBrightness,
    Brightness? statusBarBrightness,
    TextStyle? titleTextStyle,
    TextStyle? homeTitleTextStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? searchBackgroundColor,
  }) {
    return OdinNavBarThemeData(
      statusBarColor: statusBarColor ?? this.statusBarColor,
      statusBarIconBrightness: statusBarIconBrightness ?? this.statusBarIconBrightness,
      statusBarBrightness: statusBarBrightness ?? this.statusBarBrightness,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      homeTitleTextStyle: homeTitleTextStyle ?? this.homeTitleTextStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      searchBackgroundColor: searchBackgroundColor ?? this.searchBackgroundColor,
    );
  }
}

OdinNavBarThemeData createDefaultNavBarTheme({
  required OdinColorScheme colorScheme,
  required OdinBorderThemeData borderTheme,
  required OdinTypography typography,
}) {
  final isLightEmphasisColor = isLightColor(colorScheme.onColorEmphasisHigh);

  return OdinNavBarThemeData(
    statusBarColor: kTransparentColor,
    statusBarIconBrightness: isLightEmphasisColor ? Brightness.light : Brightness.dark,
    statusBarBrightness: isLightEmphasisColor ? Brightness.dark : Brightness.light,
    titleTextStyle: typography.titleSmall,
    homeTitleTextStyle: typography.bodySmall,
    backgroundColor: kTransparentColor,
    foregroundColor: colorScheme.onColorEmphasisHigh,
    searchBackgroundColor: colorScheme.actionNeutralFocus,
  );
}
