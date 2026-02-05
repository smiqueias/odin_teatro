import 'package:flutter/widgets.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';

final class OdinThemeProvider extends InheritedWidget {
  final OdinColorScheme appColorScheme;
  final OdinTypography typography;
  final bool isInverse;

  late final OdinIconContainerThemeData iconContainerTheme;
  late final OdinLinkThemeData linkTheme;
  late final OdinIconButtonThemeData iconButtonTheme;
  late final OdinDividerThemeData dividerTheme;
  late final OdinGlobalProgressBarThemeData globalProgressBarTheme;
  late final OdinInputControlButtonThemeData inputControlButtonTheme;
  late final OdinInputThemeData inputTheme;
  late final OdinButtonThemeData buttonTheme;
  late final OdinBorderThemeData borderTheme;
  late final OdinRadioButtonThemeData radioButtonTheme;
  late final OdinCheckboxThemeData checkboxTheme;
  late final OdinAvatarThemeData avatarTheme;
  late final OdinStatusBadgeThemeData statusBadgeTheme;
  late final OdinNavBarThemeData navBarTheme;
  late final OdinImageContainerThemeData imageContainerTheme;
  late final OdinGlobalImageComboThemeData globalImageComboTheme;
  late final OdinImageGroupThemeData imageGroupTheme;
  late final OdinTooltipThemeData tooltipTheme;
  late final OdinSwitcherThemeData switcherTheme;
  late final OdinTagThemeData tagTheme;

  OdinThemeProvider({
    super.key,
    required this.appColorScheme,
    required this.typography,
    required WidgetBuilder builder,
    this.isInverse = false,
  }) : iconContainerTheme = createDefaultIconContainerTheme(
         borderTheme: defaultBorderTheme,
         colorScheme: appColorScheme,
         typography: typography,
       ),

       linkTheme = createDefaultLinkTheme(
         typography: typography,
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
       ),

       iconButtonTheme = createDefaultIconButtonTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       dividerTheme = createDefaultDividerTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       globalProgressBarTheme = createDefaultGlobalProgressBarTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       inputControlButtonTheme = createDefaultInputControlButtonTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       inputTheme = createDefaultInputTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       buttonTheme = createDefaultButtonTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       borderTheme = defaultBorderTheme,

       radioButtonTheme = createDefaultRadioButtonTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       checkboxTheme = createDefaultCheckboxTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       avatarTheme = createDefaultAvatarTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       statusBadgeTheme = createDefaultStatusBadgeTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       navBarTheme = createDefaultNavBarTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       imageContainerTheme = createDefaultImageContainerTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       globalImageComboTheme = createDefaultGlobalImageComboTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       imageGroupTheme = createDefaultImageGroupTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       tooltipTheme = createDefaultTooltipTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       switcherTheme = createDefaultSwitcherTheme(
         colorScheme: appColorScheme,
         borderTheme: defaultBorderTheme,
         typography: typography,
       ),

       super(
         child: Builder(
           builder: builder,
         ),
       );

  static OdinThemeProvider of(BuildContext context) {
    final scheme = context.dependOnInheritedWidgetOfExactType<OdinThemeProvider>();

    if (scheme != null) {
      return scheme;
    } else {
      throw Exception("No color scheme");
    }
  }

  @override
  bool updateShouldNotify(OdinThemeProvider oldWidget) {
    return oldWidget.appColorScheme != appColorScheme;
  }
}
