import 'dart:math';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:odin_teatro/design_system/odin_teatro.dart';
import 'package:intersperse/intersperse.dart';
import 'package:intl/intl.dart';

const _curve1 = Cubic(0.0, 0.0, 0.25, 1.0);
const _curve2 = Cubic(0.25, 0.0, 0.25, 1.0);
const _titleAnimationDuration = Duration(milliseconds: 250);
const _contentAnimationDuration = Duration(milliseconds: 300);
const _daySelectionAnimationDuration = Duration(milliseconds: 150);
const _switchCalendarModeAnimationDuration = Duration(milliseconds: 200);

final class OdinCalendarPeriod {
  OdinCalendarPeriod({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;
}

typedef OdinSelectDateCallback = void Function(DateTime dateTime);

typedef OdinDatePickerActionSettingsBuilder<T> = OdinActionSettings<VoidCallback> Function(BuildContext context, T? data);

enum _CalendarVisualization {
  day,
  month,
  year,
}

enum _Day {
  sunday(1, 'Dom'),
  monday(2, 'Seg'),
  tuesday(3, 'Ter'),
  wednesday(4, 'Qua'),
  thursday(5, 'Qui'),
  friday(6, 'Sex'),
  saturday(7, 'Sab')
  ;

  const _Day(
    this.weekday,
    this.shortName,
  );

  final int weekday;
  final String shortName;
}

enum _Month {
  january(1, 'Janeiro'),
  february(2, 'Fevereiro'),
  march(3, 'Março'),
  april(4, 'Abril'),
  may(5, 'Maio'),
  june(6, 'Junho'),
  july(7, 'Julho'),
  august(8, 'Agosto'),
  september(9, 'Setembro'),
  october(10, 'Outubro'),
  november(11, 'Novembro'),
  december(12, 'Dezembro')
  ;

  const _Month(
    this.value,
    this.name,
  );

  final int value;
  final String name;
}

/// Abstract base class for calendar selection modes.
///
/// Use one of the provided factories to create a specific selection mode:
/// - [OdinCalendarSelectionMode.none] for no selection.
/// - [OdinCalendarSelectionMode.year] for year selection.
/// - [OdinCalendarSelectionMode.month] for month selection.
/// - [OdinCalendarSelectionMode.date] for date selection.
/// - [OdinCalendarSelectionMode.period] for period selection.
sealed class OdinCalendarSelectionMode {
  const OdinCalendarSelectionMode();

  const factory OdinCalendarSelectionMode.none() = OdinCalendarSelectionModeNone;

  const factory OdinCalendarSelectionMode.year({
    required ValueChanged<DateTime> onSelectYear,
    OdinYearEnabledPredicate yearEnabledPredicate,
  }) = OdinCalendarSelectionModeYear;

  const factory OdinCalendarSelectionMode.month({
    required ValueChanged<DateTime> onSelectMonth,
    OdinMonthEnabledPredicate monthEnabledPredicate,
  }) = OdinCalendarSelectionModeMonth;

  const factory OdinCalendarSelectionMode.date({
    required ValueChanged<DateTime?> onSelectDate,
    DateTime? initialSelectedDate,
    OdinDateEnabledPredicate dateEnabledPredicate,
  }) = OdinCalendarSelectionModeDate;

  const factory OdinCalendarSelectionMode.period({
    required ValueChanged<OdinCalendarPeriod?> onSelectPeriod,
    OdinCalendarPeriod? initialSelectedPeriod,
    OdinPeriodEnabledPredicate periodEnabledPredicate,
  }) = OdinCalendarSelectionModePeriod;
}

final class OdinCalendarSelectionModeNone extends OdinCalendarSelectionMode {
  const OdinCalendarSelectionModeNone();
}

final class OdinCalendarSelectionModeYear extends OdinCalendarSelectionMode {
  const OdinCalendarSelectionModeYear({
    required this.onSelectYear,
    this.yearEnabledPredicate = const OdinYearEnabledPredicate.value(true),
  });

  final ValueChanged<DateTime> onSelectYear;
  final OdinYearEnabledPredicate yearEnabledPredicate;
}

final class OdinCalendarSelectionModeMonth extends OdinCalendarSelectionMode {
  const OdinCalendarSelectionModeMonth({
    required this.onSelectMonth,
    this.monthEnabledPredicate = const OdinMonthEnabledPredicate.value(true),
  });

  final ValueChanged<DateTime> onSelectMonth;
  final OdinMonthEnabledPredicate monthEnabledPredicate;
}

final class OdinCalendarSelectionModeDate extends OdinCalendarSelectionMode {
  const OdinCalendarSelectionModeDate({
    required this.onSelectDate,
    this.initialSelectedDate,
    this.dateEnabledPredicate = const OdinDateEnabledPredicate.value(true),
  });

  final ValueChanged<DateTime?> onSelectDate;
  final DateTime? initialSelectedDate;
  final OdinDateEnabledPredicate dateEnabledPredicate;
}

final class OdinCalendarSelectionModePeriod extends OdinCalendarSelectionMode {
  const OdinCalendarSelectionModePeriod({
    required this.onSelectPeriod,
    this.initialSelectedPeriod,
    this.periodEnabledPredicate = const OdinPeriodEnabledPredicate.value(true),
  });

  final ValueChanged<OdinCalendarPeriod?> onSelectPeriod;
  final OdinCalendarPeriod? initialSelectedPeriod;
  final OdinPeriodEnabledPredicate periodEnabledPredicate;
}

final class OdinCalendar extends StatefulWidget {
  const OdinCalendar({
    super.key,
    this.selectionMode = const OdinCalendarSelectionMode.none(),
    this.initialDate,
    this.dayEvents = const {},
    this.monthEvents = const {},
    this.yearEvents = const {},
  });

  final OdinCalendarSelectionMode selectionMode;
  final DateTime? initialDate;
  final Map<DateTime, List<OdinSubCalendarEventIndicator>> dayEvents;
  final Map<DateTime, List<OdinSubCalendarEventIndicator>> monthEvents;
  final Map<DateTime, List<OdinSubCalendarEventIndicator>> yearEvents;

  @override
  State<OdinCalendar> createState() => _OdinCalendarState();
}

final class _OdinCalendarState extends State<OdinCalendar> {
  late _CalendarVisualization _calendarVisualization;
  late DateTime _focusedDate;
  late DateTime _lastFocusedDate;
  DateTime? _startSelectedDate;
  DateTime? _endSelectedDate;

  @override
  void initState() {
    super.initState();

    final initialDate = widget.initialDate ?? clock.now();
    _focusedDate = DateTime(initialDate.year, initialDate.month);
    _lastFocusedDate = _focusedDate;

    _initSelection();
    _loadInitialCalendarMode();
  }

  @override
  void didUpdateWidget(covariant OdinCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialDate != widget.initialDate) {
      final initialDate = widget.initialDate ?? clock.now();
      _focusedDate = DateTime(initialDate.year, initialDate.month);
      _lastFocusedDate = _focusedDate;
    }

    if (oldWidget.selectionMode.runtimeType != widget.selectionMode.runtimeType) {
      _initSelection();
      _loadInitialCalendarMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _switchCalendarModeAnimationDuration,
      transitionBuilder: (child, animation) {
        final isChildEntering = child.key == ValueKey(_calendarVisualization);

        final scaleAnimation = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 1.0, curve: _curve2),
        );

        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: isChildEntering
              ? const Interval(0.0, 0.75, curve: _curve2) //
              : const Interval(0.25, 1.0, curve: _curve2),
        );

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
      child: switch (_calendarVisualization) {
        _CalendarVisualization.day => _CalendarDayMode(
          key: ValueKey(_calendarVisualization),
          events: widget.dayEvents,
          focusedDate: _focusedDate,
          lastFocusedDate: _lastFocusedDate,
          startSelectedDate: _startSelectedDate,
          endSelectedDate: _endSelectedDate,
          onCheckIsDayEnabled: _checkIsDayEnabled,
          onPressMonthAndYear: _openYearMode,
          onChangeFocusedDate: _configureFocusedDate,
          onSelectDate: widget.selectionMode == const OdinCalendarSelectionMode.none()
              ? null //
              : _handleSelectedDate,
        ),
        _CalendarVisualization.month => _CalendarMonthMode(
          key: ValueKey(_calendarVisualization),
          events: widget.monthEvents,
          focusedDate: _focusedDate,
          lastFocusedDate: _lastFocusedDate,
          onCheckIsMonthEnabled: _checkIsMonthEnabled,
          onChangeYear: _configureFocusedDate,
          onSelectMonth: _handleSelectedMonth,
        ),
        _CalendarVisualization.year => _CalendarYearMode(
          key: ValueKey(_calendarVisualization),
          events: widget.yearEvents,
          focusedDate: _focusedDate,
          lastFocusedDate: _lastFocusedDate,
          onCheckIsYearEnabled: _checkIsYearEnabled,
          onChangeYearRange: _configureFocusedDate,
          onSelectYear: _handleSelectedYear,
        ),
      },
    );
  }

  void _initSelection() {
    _startSelectedDate = switch (widget.selectionMode) {
      final OdinCalendarSelectionModeDate selectionMode => selectionMode.initialSelectedDate,
      final OdinCalendarSelectionModePeriod selectionMode => selectionMode.initialSelectedPeriod?.startDate,
      OdinCalendarSelectionModeNone() || //
      OdinCalendarSelectionModeMonth() ||
      OdinCalendarSelectionModeYear() => null,
    };

    _endSelectedDate = switch (widget.selectionMode) {
      final OdinCalendarSelectionModePeriod selectionMode => selectionMode.initialSelectedPeriod?.endDate,
      OdinCalendarSelectionModeNone() || //
      OdinCalendarSelectionModeDate() ||
      OdinCalendarSelectionModeMonth() ||
      OdinCalendarSelectionModeYear() => null,
    };
  }

  void _loadInitialCalendarMode() {
    _calendarVisualization = switch (widget.selectionMode) {
      OdinCalendarSelectionModeNone() => _CalendarVisualization.day,
      OdinCalendarSelectionModeDate() => _CalendarVisualization.day,
      OdinCalendarSelectionModePeriod() => _CalendarVisualization.day,
      OdinCalendarSelectionModeMonth() => _CalendarVisualization.month,
      OdinCalendarSelectionModeYear() => _CalendarVisualization.year,
    };
  }

  void _openYearMode() {
    setState(() {
      _calendarVisualization = _CalendarVisualization.year;
    });
  }

  void _handleSelectedMonth(DateTime date) {
    switch (widget.selectionMode) {
      case OdinCalendarSelectionModeMonth(:final onSelectMonth):
        onSelectMonth(date);
      case OdinCalendarSelectionModeYear():
        throw StateError("The month can't be selected when in OdinCalendarSelectionModeYear mode.");
      case OdinCalendarSelectionModeNone():
      case OdinCalendarSelectionModeDate():
      case OdinCalendarSelectionModePeriod():
        setState(() {
          _configureFocusedDate(date);
          _calendarVisualization = _CalendarVisualization.day;
        });
    }
  }

  void _handleSelectedYear(DateTime date) {
    switch (widget.selectionMode) {
      case OdinCalendarSelectionModeMonth():
        throw StateError("The year can't be selected when in OdinCalendarSelectionModeMonth mode.");
      case OdinCalendarSelectionModeYear(:final onSelectYear):
        onSelectYear(date);
      case OdinCalendarSelectionModeNone():
      case OdinCalendarSelectionModeDate():
      case OdinCalendarSelectionModePeriod():
        setState(() {
          _configureFocusedDate(date);
          _calendarVisualization = _CalendarVisualization.month;
        });
    }
  }

  void _handleSelectedDate(DateTime dateTime) {
    switch (widget.selectionMode) {
      case OdinCalendarSelectionModeNone():
      case OdinCalendarSelectionModeMonth():
      case OdinCalendarSelectionModeYear():
        throw StateError(
          "A date can't be selected when in the following modes: "
          '[OdinCalendarSelectionModeNone, OdinCalendarSelectionModeMonth, OdinCalendarSelectionModeYear].',
        );
      case OdinCalendarSelectionModeDate(:final onSelectDate):
        setState(() {
          _startSelectedDate = dateTime;
          _endSelectedDate = null;
        });

        if (_startSelectedDate case final startSelectedDate?) {
          onSelectDate(startSelectedDate);
        } else {
          onSelectDate(null);
        }
      case OdinCalendarSelectionModePeriod(:final onSelectPeriod):
        setState(() {
          if (_startSelectedDate != null && _endSelectedDate != null) {
            _startSelectedDate = dateTime;
            _endSelectedDate = null;
          } else if (_startSelectedDate case final startSelectedDate?) {
            if (startSelectedDate.millisecondsSinceEpoch > dateTime.millisecondsSinceEpoch) {
              _endSelectedDate = _startSelectedDate;
              _startSelectedDate = dateTime;
            } else if (startSelectedDate.millisecondsSinceEpoch < dateTime.millisecondsSinceEpoch) {
              _endSelectedDate = dateTime;
            }
          } else {
            _startSelectedDate = dateTime;
          }
        });

        if ((_startSelectedDate, _endSelectedDate) case (final startSelectedDate?, final endSelectedDate?)) {
          onSelectPeriod(
            OdinCalendarPeriod(
              startDate: startSelectedDate,
              endDate: endSelectedDate,
            ),
          );
        } else {
          onSelectPeriod(null);
        }
    }
  }

  void _configureFocusedDate(DateTime dateTime) {
    setState(() {
      _lastFocusedDate = _focusedDate;
      _focusedDate = dateTime;
    });
  }

  bool _checkIsDayEnabled(int year, int month, int day) {
    final selectionMode = widget.selectionMode;

    switch (selectionMode) {
      case OdinCalendarSelectionModeNone():
      case OdinCalendarSelectionModeYear():
      case OdinCalendarSelectionModeMonth():
        return true;
      case OdinCalendarSelectionModeDate():
        return selectionMode.dateEnabledPredicate.isDayValid(year, month, day);
      case OdinCalendarSelectionModePeriod():
        if (_startSelectedDate case final startSelectedDate?) {
          return selectionMode.periodEnabledPredicate.isEndDayValid(
            startSelectedDate.year,
            startSelectedDate.month,
            startSelectedDate.day,
            year,
            month,
            day,
          );
        } else {
          return selectionMode.periodEnabledPredicate.isStartDayValid(year, month, day);
        }
    }
  }

  bool _checkIsMonthEnabled(int year, int month) {
    final selectionMode = widget.selectionMode;

    switch (selectionMode) {
      case OdinCalendarSelectionModeNone():
      case OdinCalendarSelectionModeYear():
        return true;
      case OdinCalendarSelectionModeMonth():
        return selectionMode.monthEnabledPredicate.isMonthValid(year, month);
      case OdinCalendarSelectionModeDate():
        return selectionMode.dateEnabledPredicate.isMonthValid(year, month);
      case OdinCalendarSelectionModePeriod():
        if (_startSelectedDate case final startSelectedDate?) {
          return selectionMode.periodEnabledPredicate.isEndMonthValid(
            startSelectedDate.year,
            startSelectedDate.month,
            startSelectedDate.day,
            year,
            month,
          );
        } else {
          return selectionMode.periodEnabledPredicate.isStartMonthValid(year, month);
        }
    }
  }

  bool _checkIsYearEnabled(int year) {
    final selectionMode = widget.selectionMode;

    switch (selectionMode) {
      case OdinCalendarSelectionModeNone():
        return true;
      case OdinCalendarSelectionModeYear():
        return selectionMode.yearEnabledPredicate.isYearValid(year);
      case OdinCalendarSelectionModeMonth():
        return selectionMode.monthEnabledPredicate.isYearValid(year);
      case OdinCalendarSelectionModeDate():
        return selectionMode.dateEnabledPredicate.isYearValid(year);
      case OdinCalendarSelectionModePeriod():
        if (_startSelectedDate case final startSelectedDate?) {
          return selectionMode.periodEnabledPredicate.isEndYearValid(
            startSelectedDate.year,
            startSelectedDate.month,
            startSelectedDate.day,
            year,
          );
        } else {
          return selectionMode.periodEnabledPredicate.isStartYearValid(year);
        }
    }
  }
}

sealed class OdinDatePickerSelectionMode {
  const OdinDatePickerSelectionMode();

  const factory OdinDatePickerSelectionMode.date(
    DateTime? initialSelectedDate,
    OdinDateEnabledPredicate dateEnabledPredicate,
    OdinDatePickerActionSettingsBuilder<DateTime?>? primaryActionSettingsBuilder,
    OdinDatePickerActionSettingsBuilder<DateTime?>? secondaryActionSettingsBuilder,
  ) = OdinDatePickerSelectionModeDate;

  const factory OdinDatePickerSelectionMode.period(
    OdinCalendarPeriod? initialSelectedPeriod,
    OdinPeriodEnabledPredicate periodEnabledPredicate,
    OdinDatePickerActionSettingsBuilder<OdinCalendarPeriod?>? primaryActionSettingsBuilder,
    OdinDatePickerActionSettingsBuilder<OdinCalendarPeriod?>? secondaryActionSettingsBuilder,
  ) = OdinDatePickerSelectionModePeriod;
}

final class OdinDatePickerSelectionModeDate extends OdinDatePickerSelectionMode {
  const OdinDatePickerSelectionModeDate(
    this.initialSelectedDate,
    this.dateEnabledPredicate,
    this.primaryActionSettingsBuilder,
    this.secondaryActionSettingsBuilder,
  );

  final DateTime? initialSelectedDate;
  final OdinDateEnabledPredicate dateEnabledPredicate;
  final OdinDatePickerActionSettingsBuilder<DateTime?>? primaryActionSettingsBuilder;
  final OdinDatePickerActionSettingsBuilder<DateTime?>? secondaryActionSettingsBuilder;
}

final class OdinDatePickerSelectionModePeriod extends OdinDatePickerSelectionMode {
  const OdinDatePickerSelectionModePeriod(
    this.initialSelectedPeriod,
    this.periodEnabledPredicate,
    this.primaryActionSettingsBuilder,
    this.secondaryActionSettingsBuilder,
  );

  final OdinCalendarPeriod? initialSelectedPeriod;
  final OdinPeriodEnabledPredicate periodEnabledPredicate;
  final OdinDatePickerActionSettingsBuilder<OdinCalendarPeriod?>? primaryActionSettingsBuilder;
  final OdinDatePickerActionSettingsBuilder<OdinCalendarPeriod?>? secondaryActionSettingsBuilder;
}

final class OdinDatePicker extends StatefulWidget {
  OdinDatePicker.date({
    super.key,
    DateTime? initialDate,
    this.dayEvents = const {},
    this.monthEvents = const {},
    this.yearEvents = const {},
    DateTime? initialSelectedDate,
    OdinDateEnabledPredicate dateEnabledPredicate = const OdinDateEnabledPredicate.value(true),
    OdinDatePickerActionSettingsBuilder<DateTime?>? primaryActionSettingsBuilder,
    OdinDatePickerActionSettingsBuilder<DateTime?>? secondaryActionSettingsBuilder,
  }) : initialDate = initialDate ?? initialSelectedDate,
       selectionMode = OdinDatePickerSelectionModeDate(
         initialSelectedDate,
         dateEnabledPredicate,
         primaryActionSettingsBuilder,
         secondaryActionSettingsBuilder,
       );

  OdinDatePicker.period({
    super.key,
    DateTime? initialDate,
    this.dayEvents = const {},
    this.monthEvents = const {},
    this.yearEvents = const {},
    OdinCalendarPeriod? initialSelectedPeriod,
    OdinPeriodEnabledPredicate periodEnabledPredicate = const OdinPeriodEnabledPredicate.value(true),
    OdinDatePickerActionSettingsBuilder<OdinCalendarPeriod?>? primaryActionSettingsBuilder,
    OdinDatePickerActionSettingsBuilder<OdinCalendarPeriod?>? secondaryActionSettingsBuilder,
  }) : initialDate = initialDate ?? initialSelectedPeriod?.startDate,
       selectionMode = OdinDatePickerSelectionModePeriod(
         initialSelectedPeriod,
         periodEnabledPredicate,
         primaryActionSettingsBuilder,
         secondaryActionSettingsBuilder,
       );

  final OdinDatePickerSelectionMode selectionMode;
  final DateTime? initialDate;
  final Map<DateTime, List<OdinSubCalendarEventIndicator>> dayEvents;
  final Map<DateTime, List<OdinSubCalendarEventIndicator>> monthEvents;
  final Map<DateTime, List<OdinSubCalendarEventIndicator>> yearEvents;

  @override
  State<OdinDatePicker> createState() => _OdinDatePickerState();
}

final class _OdinDatePickerState extends State<OdinDatePicker> {
  DateTime? _initialSelectedDate;
  DateTime? _selectedDate;
  OdinCalendarPeriod? _initialSelectedPeriod;
  OdinCalendarPeriod? _selectedPeriod;

  @override
  void initState() {
    super.initState();
    _initSelection();
  }

  @override
  Widget build(BuildContext context) {
    return OdinModal(
      title: const Text(''),
      content: OdinCalendar(
        selectionMode: switch (widget.selectionMode) {
          OdinDatePickerSelectionModeDate(:final dateEnabledPredicate) => OdinCalendarSelectionMode.date(
            onSelectDate: _handleSelectedDate,
            initialSelectedDate: _initialSelectedDate,
            dateEnabledPredicate: dateEnabledPredicate,
          ),
          OdinDatePickerSelectionModePeriod(:final periodEnabledPredicate) => OdinCalendarSelectionMode.period(
            onSelectPeriod: _handleSelectedPeriod,
            initialSelectedPeriod: _initialSelectedPeriod,
            periodEnabledPredicate: periodEnabledPredicate,
          ),
        },
        initialDate: widget.initialDate,
        dayEvents: widget.dayEvents,
        monthEvents: widget.monthEvents,
        yearEvents: widget.yearEvents,
      ),
      primaryAction: switch (widget.selectionMode) {
        OdinDatePickerSelectionModeDate(:final primaryActionSettingsBuilder) => primaryActionSettingsBuilder?.call(
          context,
          _selectedDate,
        ),
        OdinDatePickerSelectionModePeriod(:final primaryActionSettingsBuilder) => primaryActionSettingsBuilder?.call(
          context,
          _selectedPeriod,
        ),
      },
      secondaryAction: switch (widget.selectionMode) {
        OdinDatePickerSelectionModeDate(:final secondaryActionSettingsBuilder) => secondaryActionSettingsBuilder?.call(
          context,
          _selectedDate,
        ),
        OdinDatePickerSelectionModePeriod(:final secondaryActionSettingsBuilder) => secondaryActionSettingsBuilder?.call(
          context,
          _selectedPeriod,
        ),
      },
    );
  }

  void _initSelection() {
    _initialSelectedDate = _selectedDate = switch (widget.selectionMode) {
      final OdinDatePickerSelectionModeDate selectionMode => selectionMode.initialSelectedDate,
      OdinDatePickerSelectionModePeriod() => null,
    };

    _initialSelectedPeriod = _selectedPeriod = switch (widget.selectionMode) {
      final OdinDatePickerSelectionModePeriod selectionMode => selectionMode.initialSelectedPeriod,
      OdinDatePickerSelectionModeDate() => null,
    };
  }

  void _handleSelectedDate(DateTime? date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _handleSelectedPeriod(OdinCalendarPeriod? period) {
    setState(() {
      _selectedPeriod = period;
    });
  }
}

enum OdinSubCalendarDayState {
  enabled,
  selected,
  disabled,
  empty,
}

enum OdinSubCalendarDayRangeInterval {
  none,
  left,
  right,
  middle,
}

final class OdinSubCalendarDay extends StatefulWidget {
  const OdinSubCalendarDay({
    required this.date,
    required this.state,
    required this.interval,
    super.key,
    this.events = const [],
    this.onSelectDate,
  });

  final DateTime date;
  final OdinSubCalendarDayState state;
  final OdinSubCalendarDayRangeInterval interval;
  final List<OdinSubCalendarEventIndicator> events;
  final OdinSelectDateCallback? onSelectDate;

  @override
  State<OdinSubCalendarDay> createState() => _OdinSubCalendarDayState();
}

final class _OdinSubCalendarDayState extends State<OdinSubCalendarDay> with TickerProviderStateMixin {
  late final AnimationController _leftRangeAnimation;
  late final AnimationController _rightRangeAnimation;
  late final AnimationController _middleRangeAnimation;
  late final AnimationController _selectionAnimationController;
  late final CurvedAnimation _selectionAnimation;
  late bool _hasLeftRange;
  late bool _hasRightRange;
  late bool _hasSelection;
  late bool _hasBorder;

  @override
  void initState() {
    super.initState();

    _loadProperties();

    _leftRangeAnimation = AnimationController(
      vsync: this,
      duration: _daySelectionAnimationDuration,
      value: _hasLeftRange ? 1.0 : 0.0,
    );

    _rightRangeAnimation = AnimationController(
      vsync: this,
      duration: _daySelectionAnimationDuration,
      value: _hasRightRange ? 1.0 : 0.0,
    );

    _middleRangeAnimation = AnimationController(
      vsync: this,
      duration: _daySelectionAnimationDuration,
      value: _hasLeftRange && _hasRightRange ? 1.0 : 0.0,
    );

    _selectionAnimationController = AnimationController(
      vsync: this,
      duration: _daySelectionAnimationDuration,
      value: _hasSelection ? 1.0 : 0.0,
    );

    _selectionAnimation = CurvedAnimation(
      parent: _selectionAnimationController,
      curve: _curve1,
    );
  }

  @override
  void didUpdateWidget(covariant OdinSubCalendarDay oldWidget) {
    super.didUpdateWidget(oldWidget);

    _loadProperties();

    if (_hasLeftRange) {
      _leftRangeAnimation.forward();
    } else {
      _leftRangeAnimation.reverse();
    }

    if (_hasRightRange) {
      _rightRangeAnimation.forward();
    } else {
      _rightRangeAnimation.reverse();
    }

    if (_hasLeftRange && _hasRightRange) {
      _middleRangeAnimation.forward();
    } else {
      _middleRangeAnimation.reverse();
    }

    if (_hasSelection) {
      _selectionAnimationController.forward();
    } else {
      _selectionAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _leftRangeAnimation.dispose();
    _rightRangeAnimation.dispose();
    _middleRangeAnimation.dispose();
    _selectionAnimationController.dispose();
    _selectionAnimation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colorScheme = theme.appColorScheme;
    final typography = theme.typography;

    final label = AnimatedDefaultTextStyle(
      duration: _daySelectionAnimationDuration,
      style: typography.labelSmall.copyWith(
        color: switch (widget.state) {
          OdinSubCalendarDayState.enabled => colorScheme.onColorEmphasisMedium,
          OdinSubCalendarDayState.selected => colorScheme.onColorEmphasisHighInverse,
          OdinSubCalendarDayState.disabled => colorScheme.onColorEmphasisDisabled,
          OdinSubCalendarDayState.empty => kTransparentColor,
        },
      ),
      child: Text('${widget.date.day}'),
    );

    return OdinInkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1000.0),
      ),
      onTap: widget.onSelectDate == null
          ? null //
          : () => widget.onSelectDate?.call(widget.date),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _CalendarDayDecorationPainter(
              rangeColor: colorScheme.actionNeutralPressed,
              selectionColor: colorScheme.actionSecondarySelected,
              borderColor: colorScheme.secondaryBase,
              borderColorInverse: colorScheme.secondaryBaseInverse,
              hasBorder: _hasBorder,
              leftRangeAnimation: _leftRangeAnimation,
              rightRangeAnimation: _rightRangeAnimation,
              middleRangeAnimation: _middleRangeAnimation,
              selectionAnimation: _selectionAnimation,
            ),
          ),
          if (widget.events.isEmpty)
            label
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OdinGap.xxs,
                label,
                Padding(
                  padding: const EdgeInsets.only(bottom: OdinPaddingValue.xxxs),
                  child: _EventsRow(events: widget.events),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _loadProperties() {
    final currentDate = clock.now();

    _hasLeftRange =
        [
          OdinSubCalendarDayState.enabled,
          OdinSubCalendarDayState.disabled,
          OdinSubCalendarDayState.selected,
        ].contains(widget.state) &&
        [
          OdinSubCalendarDayRangeInterval.left,
          OdinSubCalendarDayRangeInterval.middle,
        ].contains(widget.interval);

    _hasRightRange =
        [
          OdinSubCalendarDayState.enabled,
          OdinSubCalendarDayState.disabled,
          OdinSubCalendarDayState.selected,
        ].contains(widget.state) &&
        [
          OdinSubCalendarDayRangeInterval.right,
          OdinSubCalendarDayRangeInterval.middle,
        ].contains(widget.interval);

    _hasSelection = widget.state == OdinSubCalendarDayState.selected;

    _hasBorder =
        [
          OdinSubCalendarDayState.enabled,
          OdinSubCalendarDayState.disabled,
          OdinSubCalendarDayState.selected,
        ].contains(widget.state) &&
        currentDate.year == widget.date.year &&
        currentDate.month == widget.date.month &&
        currentDate.day == widget.date.day;
  }
}

final class OdinSubCalendarOptionYearMonth extends StatelessWidget {
  const OdinSubCalendarOptionYearMonth({
    required this.label,
    super.key,
    this.events = const [],
    this.onPress,
  });

  final Widget label;
  final List<OdinSubCalendarEventIndicator> events;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colorScheme = theme.appColorScheme;
    final typography = theme.typography;

    return ElevatedButton(
      onPressed: onPress,
      style:
          ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: OdinPaddingValue.xs),
            shadowColor: kTransparentColor,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: typography.bodyBase,
          ).copyWith(
            backgroundColor: generateState(
              kTransparentColor,
              pressed: colorScheme.actionNeutralPressed,
            ),
            foregroundColor: generateState(
              colorScheme.onColorEmphasisHigh,
              pressed: colorScheme.onColorEmphasisHigh,
              disabled: colorScheme.onColorEmphasisDisabled,
            ),
            overlayColor: generateState(Theme.of(context).splashColor),
            shape: generateState(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(theme.borderTheme.radiusSmall),
              ),
              pressed: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(theme.borderTheme.radiusSmall),
                side: BorderSide(
                  color: colorScheme.outlineBase,
                  width: theme.borderTheme.strokeThin,
                ),
              ),
              disabled: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(theme.borderTheme.radiusSmall),
              ),
            ),
          ),
      child: switch (events.isEmpty) {
        true => label,
        false => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OdinGap.xxs,
            label,
            Padding(
              padding: const EdgeInsets.only(top: OdinPaddingValue.xxxs),
              child: _EventsRow(events: events),
            ),
          ],
        ),
      },
    );
  }
}

enum OdinSubCalendarActionKind {
  previous,
  next,
}

final class OdinSubCalendarAction extends StatelessWidget {
  const OdinSubCalendarAction({
    required this.kind,
    super.key,
    this.onPress,
  });

  const OdinSubCalendarAction.previous({
    super.key,
    this.onPress,
  }) : kind = OdinSubCalendarActionKind.previous;

  const OdinSubCalendarAction.next({
    super.key,
    this.onPress,
  }) : kind = OdinSubCalendarActionKind.next;

  final OdinSubCalendarActionKind kind;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return OdinIconContainer(
      icon: switch (kind) {
        OdinSubCalendarActionKind.previous => OdinIcons.chevronLeft,
        OdinSubCalendarActionKind.next => OdinIcons.chevronRight,
      },
      size: OdinIconContainerSize.size24,
      onPress: onPress,
    );
  }
}

enum OdinSubCalendarEventIndicatorKind {
  category1,
  category2,
  category3,
  category4,
  info,
}

enum OdinSubCalendarEventIndicatorSize {
  small,
  large,
}

final class OdinSubCalendarEventIndicator extends StatelessWidget {
  const OdinSubCalendarEventIndicator({
    required this.kind,
    required this.title,
    required this.description,
    super.key,
    this.size = OdinSubCalendarEventIndicatorSize.small,
  });

  const OdinSubCalendarEventIndicator.category1({
    required this.title,
    required this.description,
    super.key,
    this.size = OdinSubCalendarEventIndicatorSize.small,
  }) : kind = OdinSubCalendarEventIndicatorKind.category1;

  const OdinSubCalendarEventIndicator.category2({
    required this.title,
    required this.description,
    super.key,
    this.size = OdinSubCalendarEventIndicatorSize.small,
  }) : kind = OdinSubCalendarEventIndicatorKind.category2;

  const OdinSubCalendarEventIndicator.category3({
    required this.title,
    required this.description,
    super.key,
    this.size = OdinSubCalendarEventIndicatorSize.small,
  }) : kind = OdinSubCalendarEventIndicatorKind.category3;

  const OdinSubCalendarEventIndicator.category4({
    required this.title,
    required this.description,
    super.key,
    this.size = OdinSubCalendarEventIndicatorSize.small,
  }) : kind = OdinSubCalendarEventIndicatorKind.category4;

  const OdinSubCalendarEventIndicator.info({
    required this.title,
    required this.description,
    super.key,
    this.size = OdinSubCalendarEventIndicatorSize.small,
  }) : kind = OdinSubCalendarEventIndicatorKind.info;

  final OdinSubCalendarEventIndicatorKind kind;
  final OdinSubCalendarEventIndicatorSize size;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colorScheme = OdinThemeProvider.of(context).appColorScheme;

    final color = switch (kind) {
      OdinSubCalendarEventIndicatorKind.category1 => colorScheme.supportYellow70,
      OdinSubCalendarEventIndicatorKind.category2 => colorScheme.supportRed70,
      OdinSubCalendarEventIndicatorKind.category3 => colorScheme.supportAqua70,
      OdinSubCalendarEventIndicatorKind.category4 => colorScheme.supportLime70,
      OdinSubCalendarEventIndicatorKind.info => colorScheme.statusInformativeBase,
    };

    final sizeValue = switch (size) {
      OdinSubCalendarEventIndicatorSize.small => 4.0,
      OdinSubCalendarEventIndicatorSize.large => 8.0,
    };

    return Container(
      width: sizeValue,
      height: sizeValue,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

final class _CalendarDayMode extends StatelessWidget {
  const _CalendarDayMode({
    required this.events,
    required this.focusedDate,
    required this.lastFocusedDate,
    required this.startSelectedDate,
    required this.endSelectedDate,
    required this.onCheckIsDayEnabled,
    required this.onPressMonthAndYear,
    required this.onChangeFocusedDate,
    required this.onSelectDate,
    super.key,
  });

  static final _monthFormatter = DateFormat('MMMM y');
  static const _totalCalendarDays = 42;

  final Map<DateTime, List<OdinSubCalendarEventIndicator>> events;
  final DateTime focusedDate;
  final DateTime lastFocusedDate;
  final DateTime? startSelectedDate;
  final DateTime? endSelectedDate;
  final bool Function(int year, int month, int day) onCheckIsDayEnabled;
  final VoidCallback onPressMonthAndYear;
  final ValueChanged<DateTime> onChangeFocusedDate;
  final ValueChanged<DateTime>? onSelectDate;

  @override
  Widget build(BuildContext context) {
    final previousMonthDate = DateTime(focusedDate.year, focusedDate.month - 1);
    final daysInPreviousMonth = DateTime(previousMonthDate.year, previousMonthDate.month + 1, 0).day;
    final startWeekday = focusedDate.weekday % 7;
    final firstVisibleDay = daysInPreviousMonth - startWeekday;

    final datesToShow = [
      for (int i = 1; i <= _totalCalendarDays; i++) //
        DateTime(previousMonthDate.year, previousMonthDate.month, firstVisibleDay + i),
    ];

    return _CalendarFrame(
      header: ClipRect(
        child: OdinButtonInline(
          isSelected: false,
          label: AnimatedSwitcher(
            duration: _titleAnimationDuration,
            transitionBuilder: (child, animation) {
              final isChildEntering = child.key == ValueKey(focusedDate);
              final isMovingForward = lastFocusedDate.millisecondsSinceEpoch < focusedDate.millisecondsSinceEpoch;

              return _titleTransitionFrom(child, animation, isChildEntering, isMovingForward);
            },
            child: Text(
              key: ValueKey(focusedDate),
              _monthFormatter.format(focusedDate).capitalize(),
            ),
          ),
          onPress: onPressMonthAndYear,
        ),
      ),
      content: Column(
        children: [
          Row(
            children: [
              for (final dayName in _Day.values.map((day) => day.shortName))
                Expanded(
                  child: Center(
                    child: Text(dayName),
                  ),
                ),
            ],
          ),
          OdinGap.xs,
          AnimatedSwitcher(
            duration: _contentAnimationDuration,
            transitionBuilder: (child, animation) {
              final isChildEntering = child.key == ValueKey(focusedDate);
              final isMovingForward = lastFocusedDate.millisecondsSinceEpoch < focusedDate.millisecondsSinceEpoch;

              return _contentTransitionFrom(child, animation, isChildEntering, isMovingForward);
            },
            child: _CalendarDayTable(
              key: ValueKey(focusedDate),
              items: datesToShow,
              numberOfColumns: 7,
              builder: (date) {
                final isDateEnabled = onCheckIsDayEnabled(date.year, date.month, date.day);

                final OdinSubCalendarDayState state;
                if (_isSameDay(startSelectedDate, date) || _isSameDay(endSelectedDate, date)) {
                  state = OdinSubCalendarDayState.selected;
                } else if (_isSameMonthAndYear(focusedDate, date) && isDateEnabled) {
                  state = OdinSubCalendarDayState.enabled;
                } else {
                  state = OdinSubCalendarDayState.disabled;
                }

                final OdinSubCalendarDayRangeInterval interval;
                if (_isInsideInterval(date)) {
                  if (_isSameDay(date, startSelectedDate)) {
                    interval = switch (date.weekday) {
                      6 => OdinSubCalendarDayRangeInterval.none,
                      _ => OdinSubCalendarDayRangeInterval.right,
                    };
                  } else if (_isSameDay(date, endSelectedDate)) {
                    interval = switch (date.weekday) {
                      7 => OdinSubCalendarDayRangeInterval.none,
                      _ => OdinSubCalendarDayRangeInterval.left,
                    };
                  } else {
                    interval = switch (date.weekday) {
                      6 => OdinSubCalendarDayRangeInterval.left,
                      7 => OdinSubCalendarDayRangeInterval.right,
                      _ => OdinSubCalendarDayRangeInterval.middle,
                    };
                  }
                } else {
                  interval = OdinSubCalendarDayRangeInterval.none;
                }

                final events = this
                    .events
                    .entries //
                    .where((mapEntry) => _isSameDay(mapEntry.key, date))
                    .map((mapEntry) => mapEntry.value)
                    .expand((eventList) => eventList)
                    .toList(growable: false);

                return SizedBox(
                  height: MediaQuery.textScalerOf(context).scale(40.0),
                  child: OdinSubCalendarDay(
                    key: ValueKey(date),
                    date: date,
                    state: state,
                    interval: interval,
                    events: events,
                    onSelectDate: isDateEnabled
                        ? onSelectDate //
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      onOpenPrevious: _openPreviousMonth,
      onOpenCurrent: _openCurrentMonth,
      onOpenNext: _openNextMonth,
    );
  }

  void _openCurrentMonth() {
    final currentDate = clock.now();
    onChangeFocusedDate(DateTime(currentDate.year, currentDate.month));
  }

  void _openPreviousMonth() {
    onChangeFocusedDate(DateTime(focusedDate.year, focusedDate.month - 1));
  }

  void _openNextMonth() {
    onChangeFocusedDate(DateTime(focusedDate.year, focusedDate.month + 1));
  }

  bool _isInsideInterval(DateTime date) {
    final startSelectedDate = this.startSelectedDate;
    final endSelectedDate = this.endSelectedDate;

    return startSelectedDate != null && //
        endSelectedDate != null &&
        startSelectedDate.millisecondsSinceEpoch <= date.millisecondsSinceEpoch &&
        endSelectedDate.millisecondsSinceEpoch >= date.millisecondsSinceEpoch;
  }
}

final class _CalendarMonthMode extends StatelessWidget {
  const _CalendarMonthMode({
    required this.events,
    required this.focusedDate,
    required this.lastFocusedDate,
    required this.onCheckIsMonthEnabled,
    required this.onChangeYear,
    required this.onSelectMonth,
    super.key,
  });

  final Map<DateTime, List<OdinSubCalendarEventIndicator>> events;
  final DateTime focusedDate;
  final DateTime lastFocusedDate;
  final bool Function(int year, int month) onCheckIsMonthEnabled;
  final ValueChanged<DateTime> onChangeYear;
  final ValueChanged<DateTime> onSelectMonth;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colorScheme = theme.appColorScheme;
    final typography = theme.typography;

    return _CalendarFrame(
      header: AnimatedSwitcher(
        duration: _titleAnimationDuration,
        transitionBuilder: (child, animation) {
          final isChildEntering = child.key == ValueKey(focusedDate);
          final isMovingForward = lastFocusedDate.millisecondsSinceEpoch < focusedDate.millisecondsSinceEpoch;

          return _titleTransitionFrom(child, animation, isChildEntering, isMovingForward);
        },
        child: Text(
          key: ValueKey(focusedDate),
          '${focusedDate.year}',
          style: typography.bodyBase.copyWith(color: colorScheme.onColorEmphasisHigh),
        ),
      ),
      content: _CalendarMonthAndYearTable(
        key: ValueKey(focusedDate),
        items: _Month.values,
        numberOfColumns: 3,
        builder: (month) {
          final date = DateTime(focusedDate.year, month.value);

          final events = this
              .events
              .entries //
              .where((mapEntry) => _isSameMonthAndYear(mapEntry.key, date))
              .map((mapEntry) => mapEntry.value)
              .expand((eventList) => eventList)
              .toList(growable: false);

          return SizedBox(
            height: MediaQuery.textScalerOf(context).scale(75.0),
            child: OdinSubCalendarOptionYearMonth(
              label: Text(month.name),
              events: events,
              onPress: onCheckIsMonthEnabled(date.year, month.value)
                  ? (() => onSelectMonth(date)) //
                  : null,
            ),
          );
        },
      ),
      onOpenPrevious: () {
        onChangeYear(focusedDate.copyWith(year: focusedDate.year - 1));
      },
      onOpenCurrent: () {
        onChangeYear(focusedDate.copyWith(year: clock.now().year));
      },
      onOpenNext: () {
        onChangeYear(focusedDate.copyWith(year: focusedDate.year + 1));
      },
    );
  }
}

final class _CalendarYearMode extends StatelessWidget {
  const _CalendarYearMode({
    required this.events,
    required this.focusedDate,
    required this.lastFocusedDate,
    required this.onCheckIsYearEnabled,
    required this.onSelectYear,
    required this.onChangeYearRange,
    super.key,
  });

  final Map<DateTime, List<OdinSubCalendarEventIndicator>> events;
  final DateTime focusedDate;
  final DateTime lastFocusedDate;
  final bool Function(int year) onCheckIsYearEnabled;
  final ValueChanged<DateTime> onSelectYear;
  final ValueChanged<DateTime> onChangeYearRange;

  @override
  Widget build(BuildContext context) {
    final theme = OdinThemeProvider.of(context);
    final colorScheme = theme.appColorScheme;
    final typography = theme.typography;
    const numberOfYears = 20;

    return _CalendarFrame(
      header: AnimatedSwitcher(
        duration: _titleAnimationDuration,
        transitionBuilder: (child, animation) {
          final isChildEntering = child.key == ValueKey(focusedDate);
          final isMovingForward = lastFocusedDate.millisecondsSinceEpoch < focusedDate.millisecondsSinceEpoch;

          return _titleTransitionFrom(child, animation, isChildEntering, isMovingForward);
        },
        child: Text(
          key: ValueKey(focusedDate),
          '${focusedDate.year - numberOfYears + 1} - ${focusedDate.year}',
          style: typography.bodyBase.copyWith(color: colorScheme.onColorEmphasisHigh),
        ),
      ),
      content: AnimatedSwitcher(
        duration: _contentAnimationDuration,
        transitionBuilder: (child, animation) {
          final isChildEntering = child.key == ValueKey(focusedDate);
          final isMovingForward = lastFocusedDate.millisecondsSinceEpoch < focusedDate.millisecondsSinceEpoch;

          return _contentTransitionFrom(child, animation, isChildEntering, isMovingForward);
        },
        child: _CalendarMonthAndYearTable(
          key: ValueKey(focusedDate),
          items: [
            for (int i = 0; i < numberOfYears; i++) //
              focusedDate.year - numberOfYears + i + 1,
          ],
          numberOfColumns: 4,
          builder: (year) {
            final date = DateTime(year);

            final events =
                this //
                    .events
                    .entries
                    .where((mapEntry) => mapEntry.key.year == date.year)
                    .map((mapEntry) => mapEntry.value)
                    .expand((eventList) => eventList)
                    .toList(growable: false);

            return SizedBox(
              height: MediaQuery.textScalerOf(context).scale(60.0),
              child: OdinSubCalendarOptionYearMonth(
                label: Text('${date.year}'),
                events: events,
                onPress: onCheckIsYearEnabled(date.year)
                    ? (() => onSelectYear(date)) //
                    : null,
              ),
            );
          },
        ),
      ),
      onOpenPrevious: () {
        onChangeYearRange(focusedDate.copyWith(year: focusedDate.year - numberOfYears));
      },
      onOpenCurrent: () {
        onChangeYearRange(focusedDate.copyWith(year: clock.now().year));
      },
      onOpenNext: () {
        onChangeYearRange(focusedDate.copyWith(year: focusedDate.year + numberOfYears));
      },
    );
  }
}

final class _CalendarFrame extends StatelessWidget {
  const _CalendarFrame({
    required this.header,
    required this.content,
    required this.onOpenPrevious,
    required this.onOpenCurrent,
    required this.onOpenNext,
  });

  final Widget header;
  final Widget content;
  final VoidCallback onOpenPrevious;
  final VoidCallback onOpenCurrent;
  final VoidCallback onOpenNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            OdinSubCalendarAction.previous(
              onPress: onOpenPrevious,
            ),
            OdinGap.xs,
            Expanded(
              child: Center(
                child: header,
              ),
            ),
            OdinGap.xs,
            OdinSubCalendarAction.next(
              onPress: onOpenNext,
            ),
          ],
        ),
        OdinGap.xs,
        GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx < 0) {
              onOpenNext();
            }
            if (details.velocity.pixelsPerSecond.dx > 0) {
              onOpenPrevious();
            }
          },
          child: content,
        ),
        OdinGap.xs,
        OdinLink(
          size: OdinLinkSize.large,
          label: const Text('Hoje'),
          isUnderline: true,
          onPress: onOpenCurrent,
        ),
      ],
    );
  }
}

final class _CalendarDayDecorationPainter extends CustomPainter {
  _CalendarDayDecorationPainter({
    required this.rangeColor,
    required this.selectionColor,
    required this.borderColor,
    required this.borderColorInverse,
    required this.hasBorder,
    required this.leftRangeAnimation,
    required this.rightRangeAnimation,
    required this.middleRangeAnimation,
    required this.selectionAnimation,
  }) : super(
         repaint: Listenable.merge(
           [
             leftRangeAnimation,
             rightRangeAnimation,
             middleRangeAnimation,
             selectionAnimation,
           ],
         ),
       );

  final Color rangeColor;
  final Color selectionColor;
  final Color borderColor;
  final Color borderColorInverse;
  final bool hasBorder;
  final Animation<double> leftRangeAnimation;
  final Animation<double> rightRangeAnimation;
  final Animation<double> middleRangeAnimation;
  final Animation<double> selectionAnimation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final diameter = min(size.width, size.height);
    final horizontalShift = (size.width - diameter) / 2.0;
    final verticalShift = (size.height - diameter) / 2.0;

    if (middleRangeAnimation.value > 0) {
      paint.color = rangeColor.withValues(alpha: middleRangeAnimation.value);
      final rect = Rect.fromLTWH(
        0,
        0,
        size.width.ceilToDouble(),
        size.height,
      );
      canvas.drawRect(rect, paint);
    } else {
      if (leftRangeAnimation.value > 0) {
        paint.color = rangeColor.withValues(alpha: leftRangeAnimation.value);
        final rect = Rect.fromLTWH(
          0,
          0,
          size.width - horizontalShift,
          size.height - verticalShift,
        );
        final rRect = RRect.fromRectAndCorners(
          rect,
          topRight: Radius.circular(diameter / 2),
          bottomRight: Radius.circular(diameter / 2),
        );
        canvas.drawRRect(rRect, paint);
      }

      if (rightRangeAnimation.value > 0) {
        paint.color = rangeColor.withValues(alpha: rightRangeAnimation.value);
        final rect = Rect.fromLTWH(
          horizontalShift,
          verticalShift,
          (size.width - horizontalShift).ceilToDouble(),
          size.height - verticalShift,
        );
        final rRect = RRect.fromRectAndCorners(
          rect,
          topLeft: Radius.circular(diameter / 2),
          bottomLeft: Radius.circular(diameter / 2),
        );
        canvas.drawRRect(rRect, paint);
      }
    }

    if (selectionAnimation.value > 0) {
      paint.color = selectionColor;
      final rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: diameter * selectionAnimation.value,
        height: diameter * selectionAnimation.value,
      );
      final rRect = RRect.fromRectAndRadius(rect, Radius.circular(diameter / 2));
      canvas.drawRRect(rRect, paint);
    }

    if (hasBorder) {
      final borderPaint = Paint()
        ..color = Color.lerp(borderColor, borderColorInverse, selectionAnimation.value)!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      final circleOffset = Offset(size.width / 2, size.height / 2);

      canvas.drawCircle(circleOffset, size.height / 2, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CalendarDayDecorationPainter oldDelegate) {
    return oldDelegate.rangeColor != rangeColor || //
        oldDelegate.selectionColor != selectionColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.hasBorder != hasBorder ||
        oldDelegate.leftRangeAnimation.value != leftRangeAnimation.value ||
        oldDelegate.rightRangeAnimation.value != rightRangeAnimation.value ||
        oldDelegate.middleRangeAnimation.value != middleRangeAnimation.value ||
        oldDelegate.selectionAnimation.value != selectionAnimation.value;
  }
}

final class _EventsRow extends StatelessWidget {
  const _EventsRow({
    required this.events,
  });

  final List<OdinSubCalendarEventIndicator> events;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: intersperse(
        const SizedBox(width: 2.0),
        events,
      ).toList(growable: false),
    );
  }
}

final class _CalendarDayTable<T> extends StatelessWidget {
  const _CalendarDayTable({
    required this.items,
    required this.numberOfColumns,
    required this.builder,
    super.key,
  });

  final List<T> items;
  final int numberOfColumns;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    final numberOfRows = items.length / numberOfColumns;

    return Table(
      children: [
        for (int i = 0; i < numberOfRows; i = i + 1) ...[
          TableRow(
            children: [
              for (int j = 0; j < numberOfColumns; j = j + 1)
                if ((i * numberOfColumns) + j case final itemIndex when itemIndex < items.length)
                  Center(
                    child: builder(items[itemIndex]),
                  )
                else //
                  const SizedBox.shrink(),
            ],
          ),
          if (i < numberOfRows - 1)
            TableRow(
              children: [
                for (int j = 0; j < numberOfColumns; j = j + 1) //
                  const SizedBox(height: OdinGapValue.xxxs),
              ],
            ),
        ],
      ],
    );
  }
}

final class _CalendarMonthAndYearTable<T> extends StatelessWidget {
  const _CalendarMonthAndYearTable({
    required this.items,
    required this.numberOfColumns,
    required this.builder,
    super.key,
  });

  final List<T> items;
  final int numberOfColumns;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    final numberOfColumnsWithSpaces = numberOfColumns * 2 - 1;

    return Table(
      columnWidths: {
        for (int i = 0; i < numberOfColumnsWithSpaces; i++)
          i: i.isEven
              ? const IntrinsicColumnWidth() //
              : const FlexColumnWidth(),
      },
      children: [
        for (int i = 0; i < items.length / numberOfColumns; i = i + 1)
          TableRow(
            children: [
              for (int j = 0; j < numberOfColumnsWithSpaces; j = j + 1)
                () {
                  final itemIndex = (i * numberOfColumns) + (j + 1) ~/ 2;
                  if (j.isEven && itemIndex < items.length) {
                    return builder(items[itemIndex]);
                  } else {
                    return const SizedBox.shrink();
                  }
                }(),
            ],
          ),
      ],
    );
  }
}

/// Predicate interface to determine if a calendar year is enabled for selection in the calendar.
///
/// See also.
/// [OdinYearEnabledPredicateValue]
/// [OdinYearEnabledPredicateCustom]
abstract interface class OdinYearEnabledPredicate {
  // ignore: avoid_positional_boolean_parameters
  const factory OdinYearEnabledPredicate.value(bool value) = OdinYearEnabledPredicateValue;

  const factory OdinYearEnabledPredicate.custom({
    required bool Function(int year) onCheckIsValidYear,
  }) = OdinYearEnabledPredicateCustom;

  bool isYearValid(int year);
}

/// A predicate that enables or disables a calendar year based on a fixed boolean value.
final class OdinYearEnabledPredicateValue implements OdinYearEnabledPredicate {
  // ignore: avoid_positional_boolean_parameters
  const OdinYearEnabledPredicateValue(this.value);

  final bool value;

  @override
  bool isYearValid(int year) => value;
}

/// A predicate that enables or disables a calendar year based on a custom function.
final class OdinYearEnabledPredicateCustom implements OdinYearEnabledPredicate {
  const OdinYearEnabledPredicateCustom({
    required this.onCheckIsValidYear,
  });

  final bool Function(int year) onCheckIsValidYear;

  @override
  bool isYearValid(int year) => onCheckIsValidYear(year);
}

/// Predicate interface to determine if a calendar month is enabled for selection in the calendar.
///
/// See also.
/// [OdinMonthEnabledPredicateValue]
/// [OdinMonthEnabledPredicateCustom]
abstract interface class OdinMonthEnabledPredicate {
  // ignore: avoid_positional_boolean_parameters
  const factory OdinMonthEnabledPredicate.value(bool value) = OdinMonthEnabledPredicateValue;

  const factory OdinMonthEnabledPredicate.custom({
    required bool Function(int year) onCheckIsValidYear,
    required bool Function(int year, int month) onCheckIsValidMonth,
  }) = OdinMonthEnabledPredicateCustom;

  bool isYearValid(int year);

  bool isMonthValid(int year, int month);
}

/// A predicate that enables or disables a calendar month based on a fixed boolean value.
final class OdinMonthEnabledPredicateValue implements OdinMonthEnabledPredicate {
  // ignore: avoid_positional_boolean_parameters
  const OdinMonthEnabledPredicateValue(this.value);

  final bool value;

  @override
  bool isYearValid(int year) => value;

  @override
  bool isMonthValid(int year, int month) => value;
}

/// A predicate that enables or disables a calendar month based on custom functions.
final class OdinMonthEnabledPredicateCustom implements OdinMonthEnabledPredicate {
  const OdinMonthEnabledPredicateCustom({
    required this.onCheckIsValidYear,
    required this.onCheckIsValidMonth,
  });

  final bool Function(int year) onCheckIsValidYear;
  final bool Function(int year, int month) onCheckIsValidMonth;

  @override
  bool isYearValid(int year) => onCheckIsValidYear(year);

  @override
  bool isMonthValid(int year, int month) => onCheckIsValidMonth(year, month);
}

/// Predicate interface to determine if a calendar date is enabled for selection in the calendar.
/// See also.
/// [OdinDateEnabledPredicateValue]
/// [OdinDateEnabledPredicateMinDate]
/// [OdinDateEnabledPredicateMaxDate]
/// [OdinDateEnabledPredicatePeriod]
/// [OdinDateEnabledPredicateCustom]
abstract interface class OdinDateEnabledPredicate {
  // ignore: avoid_positional_boolean_parameters
  const factory OdinDateEnabledPredicate.value(bool value) = OdinDateEnabledPredicateValue;

  const factory OdinDateEnabledPredicate.minDate(DateTime minDate) = OdinDateEnabledPredicateMinDate;

  const factory OdinDateEnabledPredicate.maxDate(DateTime maxDate) = OdinDateEnabledPredicateMaxDate;

  const factory OdinDateEnabledPredicate.period({
    required DateTime startDate,
    required DateTime endDate,
  }) = OdinDateEnabledPredicatePeriod;

  const factory OdinDateEnabledPredicate.custom({
    required bool Function(int year) onCheckIsValidYear,
    required bool Function(int year, int month) onCheckIsValidMonth,
    required bool Function(int year, int month, int day) onCheckIsValidDay,
  }) = OdinDateEnabledPredicateCustom;

  bool isYearValid(int year);

  bool isMonthValid(int year, int month);

  bool isDayValid(int year, int month, int day);
}

/// A predicate that enables or disables a calendar date based on a fixed boolean value.
final class OdinDateEnabledPredicateValue implements OdinDateEnabledPredicate {
  // ignore: avoid_positional_boolean_parameters
  const OdinDateEnabledPredicateValue(this.value);

  final bool value;

  @override
  bool isYearValid(int year) => value;

  @override
  bool isMonthValid(int year, int month) => value;

  @override
  bool isDayValid(int year, int month, int day) => value;
}

/// A predicate that enables or disables a calendar date based on a minimum date.
///
/// Dates before the [minDate] are considered disabled.
/// Dates on or after the [minDate] are considered enabled.
final class OdinDateEnabledPredicateMinDate implements OdinDateEnabledPredicate {
  const OdinDateEnabledPredicateMinDate(this.minDate);

  final DateTime minDate;

  @override
  bool isYearValid(int year) {
    return year >= minDate.year;
  }

  @override
  bool isMonthValid(int year, int month) {
    final date = DateTime(year, month + 1, 0);
    return date.isDateAfterOrEquals(minDate);
  }

  @override
  bool isDayValid(int year, int month, int day) {
    final date = DateTime(year, month, day);
    return date.isDateAfterOrEquals(minDate);
  }
}

/// A predicate that enables or disables a calendar date based on a maximum date.
///
/// Dates after the [maxDate] are considered disabled.
/// Dates on or before the [maxDate] are considered enabled.
final class OdinDateEnabledPredicateMaxDate implements OdinDateEnabledPredicate {
  const OdinDateEnabledPredicateMaxDate(this.maxDate);

  final DateTime maxDate;

  @override
  bool isYearValid(int year) {
    return year <= maxDate.year;
  }

  @override
  bool isMonthValid(int year, int month) {
    final date = DateTime(year, month, 0);
    return date.isDateBeforeOrEquals(maxDate);
  }

  @override
  bool isDayValid(int year, int month, int day) {
    final date = DateTime(year, month, day);
    return date.isDateBeforeOrEquals(maxDate);
  }
}

/// A predicate that enables or disables a calendar date based on a period.
///
/// Dates within the period defined by [startDate] and [endDate] are considered enabled.
/// Dates outside this period are considered disabled.
final class OdinDateEnabledPredicatePeriod implements OdinDateEnabledPredicate {
  const OdinDateEnabledPredicatePeriod({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  bool isYearValid(int year) {
    return startDate.year <= year && endDate.year >= year;
  }

  @override
  bool isMonthValid(int year, int month) {
    final firstMonthDay = DateTime(year, month);
    final lastMonthDay = DateTime(year, month + 1, 0);
    return firstMonthDay.isDateInPeriod(startDate, endDate) || //
        lastMonthDay.isDateInPeriod(startDate, endDate) ||
        startDate.isDateInPeriod(firstMonthDay, lastMonthDay) ||
        endDate.isDateInPeriod(firstMonthDay, lastMonthDay);
  }

  @override
  bool isDayValid(int year, int month, int day) {
    final selectedDate = DateTime(year, month, day);
    return selectedDate.isDateInPeriod(startDate, endDate);
  }
}

/// A predicate that enables or disables a calendar date based on custom functions.
final class OdinDateEnabledPredicateCustom implements OdinDateEnabledPredicate {
  const OdinDateEnabledPredicateCustom({
    required this.onCheckIsValidYear,
    required this.onCheckIsValidMonth,
    required this.onCheckIsValidDay,
  });

  final bool Function(int year) onCheckIsValidYear;
  final bool Function(int year, int month) onCheckIsValidMonth;
  final bool Function(int year, int month, int day) onCheckIsValidDay;

  @override
  bool isYearValid(int year) => onCheckIsValidYear(year);
  @override
  bool isMonthValid(int year, int month) => onCheckIsValidMonth(year, month);

  @override
  bool isDayValid(int year, int month, int day) => onCheckIsValidDay(year, month, day);
}

/// Predicate interface to determine if a calendar period (start and end date) is enabled for selection in the calendar.
///
/// See also.
/// [OdinPeriodEnabledPredicateValue]
/// [OdinPeriodEnabledPredicateCustom]
/// [OdinPeriodEnabledPredicatePeriod]
abstract interface class OdinPeriodEnabledPredicate {
  // ignore: avoid_positional_boolean_parameters
  const factory OdinPeriodEnabledPredicate.value(bool value) = OdinPeriodEnabledPredicateValue;

  const factory OdinPeriodEnabledPredicate.custom({
    required bool Function(int year) onCheckIsValidStartYear,
    required bool Function(int year, int month) onCheckIsValidStartMonth,
    required bool Function(int year, int month, int day) onCheckIsValidStartDay,
    required bool Function(int startYear, int startMonth, int startDay, int year) onCheckIsValidEndYear,
    required bool Function(int startYear, int startMonth, int startDay, int year, int month) onCheckIsValidEndMonth,
    required bool Function(int startYear, int startMonth, int startDay, int year, int month, int day) onCheckIsValidEndDay,
  }) = OdinPeriodEnabledPredicateCustom;

  factory OdinPeriodEnabledPredicate.period({
    required DateTime startDate,
    required DateTime endDate,
  }) = OdinPeriodEnabledPredicatePeriod;

  bool isStartYearValid(int year);

  bool isStartMonthValid(int year, int month);

  bool isStartDayValid(int year, int month, int day);

  bool isEndYearValid(int startYear, int startMonth, int startDay, int year);

  bool isEndMonthValid(int startYear, int startMonth, int startDay, int year, int month);

  bool isEndDayValid(int startYear, int startMonth, int startDay, int year, int month, int day);
}

/// A predicate that enables or disables a calendar period based on a fixed boolean value.
final class OdinPeriodEnabledPredicateValue implements OdinPeriodEnabledPredicate {
  // ignore: avoid_positional_boolean_parameters
  const OdinPeriodEnabledPredicateValue(this.value);

  final bool value;

  @override
  bool isStartYearValid(int year) => value;

  @override
  bool isStartMonthValid(int year, int month) => value;

  @override
  bool isStartDayValid(int year, int month, int day) => value;

  @override
  bool isEndYearValid(int startYear, int startMonth, int startDay, int year) => value;

  @override
  bool isEndMonthValid(int startYear, int startMonth, int startDay, int year, int month) => value;

  @override
  bool isEndDayValid(int startYear, int startMonth, int startDay, int year, int month, int day) => value;
}

/// A predicate that enables or disables a calendar period based on custom functions.
final class OdinPeriodEnabledPredicateCustom implements OdinPeriodEnabledPredicate {
  const OdinPeriodEnabledPredicateCustom({
    required this.onCheckIsValidStartYear,
    required this.onCheckIsValidStartMonth,
    required this.onCheckIsValidStartDay,
    required this.onCheckIsValidEndYear,
    required this.onCheckIsValidEndMonth,
    required this.onCheckIsValidEndDay,
  });

  final bool Function(int year) onCheckIsValidStartYear;
  final bool Function(int year, int month) onCheckIsValidStartMonth;
  final bool Function(int year, int month, int day) onCheckIsValidStartDay;
  final bool Function(int startYear, int startMonth, int startDay, int year) onCheckIsValidEndYear;
  final bool Function(int startYear, int startMonth, int startDay, int year, int month) onCheckIsValidEndMonth;
  final bool Function(int startYear, int startMonth, int startDay, int year, int month, int day) onCheckIsValidEndDay;

  @override
  bool isStartYearValid(int year) => onCheckIsValidStartYear(year);

  @override
  bool isStartMonthValid(int year, int month) => onCheckIsValidStartMonth(year, month);

  @override
  bool isStartDayValid(int year, int month, int day) => onCheckIsValidStartDay(year, month, day);

  @override
  bool isEndYearValid(int startYear, int startMonth, int startDay, int year) {
    return onCheckIsValidEndYear(startYear, startMonth, startDay, year);
  }

  @override
  bool isEndMonthValid(int startYear, int startMonth, int startDay, int year, int month) {
    return onCheckIsValidEndMonth(startYear, startMonth, startDay, year, month);
  }

  @override
  bool isEndDayValid(int startYear, int startMonth, int startDay, int year, int month, int day) {
    return onCheckIsValidEndDay(startYear, startMonth, startDay, year, month, day);
  }
}

/// A predicate that enables or disables a calendar period based on a fixed date range.
///
/// Dates within the period defined by [startDate] and [endDate] are considered enabled.
/// Dates outside this period are considered disabled.
final class OdinPeriodEnabledPredicatePeriod implements OdinPeriodEnabledPredicate {
  OdinPeriodEnabledPredicatePeriod({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;
  late final _datePredicate = OdinDateEnabledPredicate.period(
    startDate: startDate,
    endDate: endDate,
  );

  @override
  bool isStartYearValid(int year) => _datePredicate.isYearValid(year);

  @override
  bool isStartMonthValid(int year, int month) => _datePredicate.isMonthValid(year, month);

  @override
  bool isStartDayValid(int year, int month, int day) => _datePredicate.isDayValid(year, month, day);

  @override
  bool isEndYearValid(int startYear, int startMonth, int startDay, int year) {
    return _datePredicate.isYearValid(year);
  }

  @override
  bool isEndMonthValid(int startYear, int startMonth, int startDay, int year, int month) {
    return _datePredicate.isMonthValid(year, month);
  }

  @override
  bool isEndDayValid(int startYear, int startMonth, int startDay, int year, int month, int day) {
    return _datePredicate.isDayValid(year, month, day);
  }
}

bool _isSameDay(DateTime? date1, DateTime? date2) {
  return switch ((date1, date2)) {
    (null, null) => true,
    (null, _?) => false,
    (_?, null) => false,
    (final date1?, final date2?) => date1.year == date2.year && date1.month == date2.month && date1.day == date2.day,
  };
}

bool _isSameMonthAndYear(DateTime? date1, DateTime? date2) {
  return switch ((date1, date2)) {
    (null, null) => true,
    (null, _?) => false,
    (_?, null) => false,
    (final date1?, final date2?) => date1.year == date2.year && date1.month == date2.month,
  };
}

Widget _titleTransitionFrom(Widget child, Animation<double> animation, bool isChildEntering, bool isMovingForward) {
  final fadeAnimation = CurvedAnimation(
    parent: animation,
    curve: isChildEntering
        ? const Interval(0.33, 1.0, curve: _curve2) //
        : const Interval(0.66, 1.0, curve: _curve2),
  );

  return FadeTransition(
    opacity: fadeAnimation,
    child: _contentTransitionFrom(child, animation, isChildEntering, isMovingForward),
  );
}

Widget _contentTransitionFrom(Widget child, Animation<double> animation, bool isChildEntering, bool isMovingForward) {
  final slideAnimation =
      CurvedAnimation(
        parent: animation,
        curve: isChildEntering
            ? const Interval(0.33, 1.0, curve: _curve2) //
            : const Interval(0.66, 1.0, curve: _curve2),
      ).drive(
        Tween<Offset>(
          begin: switch ((isChildEntering, isMovingForward)) {
            (true, true) => const Offset(1.1, 0.0),
            (true, false) => const Offset(-1.1, 0.0),
            (false, false) => const Offset(1.1, 0.0),
            (false, true) => const Offset(-1.1, 0.0),
          },
          end: Offset.zero,
        ),
      );

  return SlideTransition(
    position: slideAnimation,
    child: child,
  );
}

Future<DateTime?> showOdinDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? initialSelectedDate,
  Map<DateTime, List<OdinSubCalendarEventIndicator>>? dayEvents,
  Map<DateTime, List<OdinSubCalendarEventIndicator>>? monthEvents,
  Map<DateTime, List<OdinSubCalendarEventIndicator>>? yearEvents,
  OdinDateEnabledPredicate dateEnabledPredicate = const OdinDateEnabledPredicate.value(true),
  OdinDatePickerActionSettingsBuilder<DateTime>? primaryActionSettingsBuilder = _defaultActionSettingsBuilder,
  OdinDatePickerActionSettingsBuilder<DateTime>? secondaryActionSettingsBuilder,
  RouteSettings? routeSettings,
}) async {
  return showOdinModal<DateTime>(
    context: context,
    routeSettings: routeSettings,
    builder: (modalContext) {
      return OdinDatePicker.date(
        initialDate: initialDate,
        dayEvents: dayEvents ?? {},
        monthEvents: monthEvents ?? {},
        yearEvents: yearEvents ?? {},
        dateEnabledPredicate: dateEnabledPredicate,
        initialSelectedDate: initialSelectedDate,
        primaryActionSettingsBuilder: primaryActionSettingsBuilder,
        secondaryActionSettingsBuilder: secondaryActionSettingsBuilder,
      );
    },
  );
}

Future<OdinCalendarPeriod?> showOdinPeriodPicker({
  required BuildContext context,
  DateTime? initialDate,
  OdinCalendarPeriod? initialSelectedPeriod,
  Map<DateTime, List<OdinSubCalendarEventIndicator>>? dayEvents,
  Map<DateTime, List<OdinSubCalendarEventIndicator>>? monthEvents,
  Map<DateTime, List<OdinSubCalendarEventIndicator>>? yearEvents,
  OdinPeriodEnabledPredicate periodEnabledPredicate = const OdinPeriodEnabledPredicate.value(true),
  OdinDatePickerActionSettingsBuilder<OdinCalendarPeriod>? primaryActionSettingsBuilder = _defaultActionSettingsBuilder,
  OdinDatePickerActionSettingsBuilder<OdinCalendarPeriod>? secondaryActionSettingsBuilder,
  RouteSettings? routeSettings,
}) async {
  return showOdinModal<OdinCalendarPeriod>(
    context: context,
    routeSettings: routeSettings,
    builder: (modalContext) {
      return OdinDatePicker.period(
        initialDate: initialDate,
        dayEvents: dayEvents ?? {},
        monthEvents: monthEvents ?? {},
        yearEvents: yearEvents ?? {},
        periodEnabledPredicate: periodEnabledPredicate,
        initialSelectedPeriod: initialSelectedPeriod,
        primaryActionSettingsBuilder: primaryActionSettingsBuilder,
        secondaryActionSettingsBuilder: secondaryActionSettingsBuilder,
      );
    },
  );
}

OdinActionSettings<VoidCallback> _defaultActionSettingsBuilder<T>(BuildContext context, T? data) {
  return OdinActionSettings(
    text: 'OK',
    onPress: data == null
        ? null //
        : () => Navigator.of(context).pop(data),
  );
}
