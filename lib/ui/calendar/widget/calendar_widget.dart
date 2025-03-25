
import 'dart:math';

import 'package:plan_mate/utils/calendar_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../../../utils/colors.dart';
import '../table_calendar_base.dart';
import 'calendar_builders.dart';
import 'calendar_header.dart';
import 'calendar_style.dart';
import 'cell_content.dart';
import 'days_of_week_style.dart';
import 'header_style.dart';

typedef OnDaySelected = void Function(
    DateTime selectedDay, DateTime focusedDay);

typedef OnRangeSelected = void Function(
    DateTime? start, DateTime? end, DateTime focusedDay);

enum RangeSelectionMode { disabled, toggledOff, toggledOn, enforced }

class TableCalendar<T> extends StatefulWidget {
  final dynamic locale;

  final DateTime? rangeStartDay;

  final DateTime? rangeEndDay;

  final DateTime focusedDay;

  final DateTime firstDay;

  final DateTime lastDay;

  final DateTime? currentDay;

  final List<int> weekendDays;

  final CalendarFormat calendarFormat;

  final Map<CalendarFormat, String> availableCalendarFormats;

  final bool headerVisible;

  final bool daysOfWeekVisible;

  final bool pageJumpingEnabled;

  final bool pageAnimationEnabled;

  final bool sixWeekMonthsEnforced;

  final bool shouldFillViewport;

  final bool weekNumbersVisible;

  final double rowHeight;

  final double daysOfWeekHeight;

  final Duration formatAnimationDuration;

  final Curve formatAnimationCurve;

  final Duration pageAnimationDuration;

  final Curve pageAnimationCurve;

  final StartingDayOfWeek startingDayOfWeek;

  final HitTestBehavior dayHitTestBehavior;

  final AvailableGestures availableGestures;

  final SimpleSwipeConfig simpleSwipeConfig;

  final HeaderStyle headerStyle;

  final DaysOfWeekStyle daysOfWeekStyle;

  final CalendarStyle calendarStyle;

  final CalendarBuilders<T> calendarBuilders;

  final RangeSelectionMode rangeSelectionMode;

  final List<T> Function(DateTime day)? eventLoader;

  final bool Function(DateTime day)? enabledDayPredicate;

  final bool Function(DateTime day)? selectedDayPredicate;

  final bool Function(DateTime day)? holidayPredicate;

  final OnRangeSelected? onRangeSelected;

  final OnDaySelected? onDaySelected;

  final OnDaySelected? onDayLongPressed;

  final void Function(DateTime day)? onDisabledDayTapped;

  final void Function(DateTime day)? onDisabledDayLongPressed;

  final void Function(DateTime focusedDay)? onHeaderTapped;

  final void Function(DateTime focusedDay)? onHeaderLongPressed;

  final void Function(DateTime focusedDay)? onPageChanged;

  final void Function(CalendarFormat format)? onFormatChanged;

  final void Function(PageController pageController)? onCalendarCreated;

  TableCalendar({
    super.key,
    required DateTime focusedDay,
    required DateTime firstDay,
    required DateTime lastDay,
    DateTime? currentDay,
    this.locale,
    this.rangeStartDay,
    this.rangeEndDay,
    this.weekendDays = const [DateTime.saturday, DateTime.sunday],
    this.calendarFormat = CalendarFormat.month,
    this.availableCalendarFormats = const {
      CalendarFormat.month: 'Month',
      CalendarFormat.twoWeeks: '2 weeks',
      CalendarFormat.week: 'Week',
    },
    this.headerVisible = true,
    this.daysOfWeekVisible = true,
    this.pageJumpingEnabled = false,
    this.pageAnimationEnabled = true,
    this.sixWeekMonthsEnforced = false,
    this.shouldFillViewport = false,
    this.weekNumbersVisible = false,
    this.rowHeight = 52.0,
    this.daysOfWeekHeight = 16.0,
    this.formatAnimationDuration = const Duration(milliseconds: 200),
    this.formatAnimationCurve = Curves.linear,
    this.pageAnimationDuration = const Duration(milliseconds: 300),
    this.pageAnimationCurve = Curves.easeOut,
    this.startingDayOfWeek = StartingDayOfWeek.sunday,
    this.dayHitTestBehavior = HitTestBehavior.opaque,
    this.availableGestures = AvailableGestures.all,
    this.simpleSwipeConfig = const SimpleSwipeConfig(
      verticalThreshold: 25.0,
      swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
    ),
    this.headerStyle = const HeaderStyle(formatButtonVisible : false),
    this.daysOfWeekStyle = const DaysOfWeekStyle(),
    this.calendarStyle = const CalendarStyle(),
    this.calendarBuilders = const CalendarBuilders(),
    this.rangeSelectionMode = RangeSelectionMode.toggledOff,
    this.eventLoader,
    this.enabledDayPredicate,
    this.selectedDayPredicate,
    this.holidayPredicate,
    this.onRangeSelected,
    this.onDaySelected,
    this.onDayLongPressed,
    this.onDisabledDayTapped,
    this.onDisabledDayLongPressed,
    this.onHeaderTapped,
    this.onHeaderLongPressed,
    this.onPageChanged,
    this.onFormatChanged,
    this.onCalendarCreated,
  })  : assert(availableCalendarFormats.keys.contains(calendarFormat)),
        assert(availableCalendarFormats.length <= CalendarFormat.values.length),
        assert(weekendDays.isNotEmpty
            ? weekendDays.every(
                (day) => day >= DateTime.monday && day <= DateTime.sunday)
            : true),
        focusedDay = normalizeDate(focusedDay),
        firstDay = normalizeDate(firstDay),
        lastDay = normalizeDate(lastDay),
        currentDay = currentDay ?? DateTime.now();

  @override
  _TableCalendarState<T> createState() => _TableCalendarState<T>();
}

class _TableCalendarState<T> extends State<TableCalendar<T>> {
  late final PageController _pageController;
  late final ValueNotifier<DateTime> _focusedDay;
  late RangeSelectionMode _rangeSelectionMode;
  DateTime? _firstSelectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = ValueNotifier(widget.focusedDay);
    _rangeSelectionMode = widget.rangeSelectionMode;
  }

  @override
  void didUpdateWidget(TableCalendar<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_focusedDay.value != widget.focusedDay) {
      _focusedDay.value = widget.focusedDay;
    }

    if (_rangeSelectionMode != widget.rangeSelectionMode) {
      _rangeSelectionMode = widget.rangeSelectionMode;
    }

    if (widget.rangeStartDay == null && widget.rangeEndDay == null) {
      _firstSelectedDay = null;
    }
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    super.dispose();
  }

  bool get _isRangeSelectionToggleable =>
      _rangeSelectionMode == RangeSelectionMode.toggledOn ||
          _rangeSelectionMode == RangeSelectionMode.toggledOff;

  bool get _isRangeSelectionOn =>
      _rangeSelectionMode == RangeSelectionMode.toggledOn ||
          _rangeSelectionMode == RangeSelectionMode.enforced;

  bool get _shouldBlockOutsideDays =>
      !widget.calendarStyle.outsideDaysVisible &&
          widget.calendarFormat == CalendarFormat.month;

  void _swipeCalendarFormat(SwipeDirection direction) {
    if (widget.onFormatChanged != null) {
      final formats = widget.availableCalendarFormats.keys.toList();

      final isSwipeUp = direction == SwipeDirection.up;
      int id = formats.indexOf(widget.calendarFormat);

      // Order of CalendarFormats must be from biggest to smallest,
      // e.g.: [month, twoWeeks, week]
      if (isSwipeUp) {
        id = min(formats.length - 1, id + 1);
      } else {
        id = max(0, id - 1);
      }

      widget.onFormatChanged!(formats[id]);
    }
  }

  void _onDayTapped(DateTime day) {
    final isOutside = day.month != _focusedDay.value.month;
    if (isOutside && _shouldBlockOutsideDays) {
      return;
    }

    if (_isDayDisabled(day)) {
      return widget.onDisabledDayTapped?.call(day);
    }

    _updateFocusOnTap(day);

    if (_isRangeSelectionOn && widget.onRangeSelected != null) {
      if (_firstSelectedDay == null) {
        _firstSelectedDay = day;
        widget.onRangeSelected!(_firstSelectedDay, null, _focusedDay.value);
      } else {
        if (day.isAfter(_firstSelectedDay!)) {
          widget.onRangeSelected!(_firstSelectedDay, day, _focusedDay.value);
          _firstSelectedDay = null;
        } else if (day.isBefore(_firstSelectedDay!)) {
          widget.onRangeSelected!(day, _firstSelectedDay, _focusedDay.value);
          _firstSelectedDay = null;
        }
      }
    } else {
      widget.onDaySelected?.call(day, _focusedDay.value);
    }
  }

  void _onDayLongPressed(DateTime day) {
    final isOutside = day.month != _focusedDay.value.month;
    if (isOutside && _shouldBlockOutsideDays) {
      return;
    }

    if (_isDayDisabled(day)) {
      return widget.onDisabledDayLongPressed?.call(day);
    }

    if (widget.onDayLongPressed != null) {
      _updateFocusOnTap(day);
      return widget.onDayLongPressed!(day, _focusedDay.value);
    }

    if (widget.onRangeSelected != null) {
      if (_isRangeSelectionToggleable) {
        _updateFocusOnTap(day);
        _toggleRangeSelection();

        if (_isRangeSelectionOn) {
          _firstSelectedDay = day;
          widget.onRangeSelected!(_firstSelectedDay, null, _focusedDay.value);
        } else {
          _firstSelectedDay = null;
          widget.onDaySelected?.call(day, _focusedDay.value);
        }
      }
    }
  }

  void _updateFocusOnTap(DateTime day) {
    if (widget.pageJumpingEnabled) {
      _focusedDay.value = day;
      return;
    }

    if (widget.calendarFormat == CalendarFormat.month) {
      if (_isBeforeMonth(day, _focusedDay.value)) {
        _focusedDay.value = _firstDayOfMonth(_focusedDay.value);
      } else if (_isAfterMonth(day, _focusedDay.value)) {
        _focusedDay.value = _lastDayOfMonth(_focusedDay.value);
      } else {
        _focusedDay.value = day;
      }
    } else {
      _focusedDay.value = day;
    }
  }

  void _toggleRangeSelection() {
    if (_rangeSelectionMode == RangeSelectionMode.toggledOn) {
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    } else {
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    }
  }

  void _onLeftChevronTap() {
    _pageController.previousPage(
      duration: widget.pageAnimationDuration,
      curve: widget.pageAnimationCurve,
    );
  }

  void _onRightChevronTap() {
    _pageController.nextPage(
      duration: widget.pageAnimationDuration,
      curve: widget.pageAnimationCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.headerVisible)
          ValueListenableBuilder<DateTime>(
            valueListenable: _focusedDay,
            builder: (context, value, _) {
              return CalendarHeader(
                headerTitleBuilder: widget.calendarBuilders.headerTitleBuilder,
                focusedMonth: value,
                onLeftChevronTap: _onLeftChevronTap,
                onRightChevronTap: _onRightChevronTap,
                onHeaderTap: () => widget.onHeaderTapped?.call(value),
                onHeaderLongPress: () =>
                    widget.onHeaderLongPressed?.call(value),
                headerStyle: widget.headerStyle,
                availableCalendarFormats: widget.availableCalendarFormats,
                calendarFormat: widget.calendarFormat,
                locale: widget.locale,
                onFormatButtonTap: (format) {
                  assert(
                  widget.onFormatChanged != null,
                  'Using `FormatButton` without providing `onFormatChanged` will have no effect.',
                  );

                  widget.onFormatChanged?.call(format);
                },
              );
            },
          ),
        Flexible(
          flex: widget.shouldFillViewport ? 1 : 0,
          child: TableCalendarBase(
            onCalendarCreated: (pageController) {
              _pageController = pageController;
              widget.onCalendarCreated?.call(pageController);
            },
            focusedDay: _focusedDay.value,
            calendarFormat: widget.calendarFormat,
            availableGestures: widget.availableGestures,
            firstDay: widget.firstDay,
            lastDay: widget.lastDay,
            startingDayOfWeek: widget.startingDayOfWeek,
            dowDecoration: widget.daysOfWeekStyle.decoration,
            rowDecoration: widget.calendarStyle.rowDecoration,
            tableBorder: widget.calendarStyle.tableBorder,
            tablePadding: widget.calendarStyle.tablePadding,
            dowVisible: widget.daysOfWeekVisible,
            dowHeight: widget.daysOfWeekHeight,
            rowHeight: widget.rowHeight,
            formatAnimationDuration: widget.formatAnimationDuration,
            formatAnimationCurve: widget.formatAnimationCurve,
            pageAnimationEnabled: widget.pageAnimationEnabled,
            pageAnimationDuration: widget.pageAnimationDuration,
            pageAnimationCurve: widget.pageAnimationCurve,
            availableCalendarFormats: widget.availableCalendarFormats,
            simpleSwipeConfig: widget.simpleSwipeConfig,
            sixWeekMonthsEnforced: widget.sixWeekMonthsEnforced,
            onVerticalSwipe: _swipeCalendarFormat,
            onPageChanged: (focusedDay) {
              _focusedDay.value = focusedDay;
              widget.onPageChanged?.call(focusedDay);
            },
            weekNumbersVisible: widget.weekNumbersVisible,
            weekNumberBuilder: (BuildContext context, DateTime day) {
              final weekNumber = _calculateWeekNumber(day);
              Widget? cell = widget.calendarBuilders.weekNumberBuilder
                  ?.call(context, weekNumber);

              cell ??= Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Center(
                    child: Text(
                      weekNumber.toString(),
                      style: widget.calendarStyle.weekNumberTextStyle,
                    ),
                  ),
                );

              return cell;
            },
            dowBuilder: (BuildContext context, DateTime day) {
              Widget? dowCell =
              widget.calendarBuilders.dowBuilder?.call(context, day);

              if (dowCell == null) {
                final weekdayString = widget.daysOfWeekStyle.dowTextFormatter
                    ?.call(day, widget.locale) ??
                    DateFormat.E(widget.locale).format(day);

                final isWeekend =
                _isWeekend(day, weekendDays: widget.weekendDays);

                dowCell = Center(
                  child: ExcludeSemantics(
                    child: Text(
                      weekdayString,
                      style: isWeekend
                          ? widget.daysOfWeekStyle.weekendStyle
                          : widget.daysOfWeekStyle.weekdayStyle,
                    ),
                  ),
                );
              }

              return dowCell;
            },
            dayBuilder: (context, day, focusedMonth) {
              return GestureDetector(
                behavior: widget.dayHitTestBehavior,
                onTap: () => _onDayTapped(day),
                onLongPress: () => _onDayLongPressed(day),
                child: _buildCell(day, focusedMonth),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCell(DateTime day, DateTime focusedDay) {
    final isOutside = day.month != focusedDay.month;

    if (isOutside && _shouldBlockOutsideDays) {
      return Container();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final shorterSide = constraints.maxHeight > constraints.maxWidth
            ? constraints.maxWidth
            : constraints.maxHeight;

        final children = <Widget>[];

        final isWithinRange = widget.rangeStartDay != null &&
            widget.rangeEndDay != null &&
            _isWithinRange(day, widget.rangeStartDay!, widget.rangeEndDay!);

        final isRangeStart = isSameDay(day, widget.rangeStartDay);
        final isRangeEnd = isSameDay(day, widget.rangeEndDay);

        final isToday = isSameDay(day, widget.currentDay);
        final isDisabled = _isDayDisabled(day);
        final isWeekend = _isWeekend(day, weekendDays: widget.weekendDays);

        Widget content = CellContent(
          key: ValueKey('CellContent-${day.year}-${day.month}-${day.day}'),
          day: day,
          focusedDay: focusedDay,
          calendarStyle: widget.calendarStyle,
          calendarBuilders: widget.calendarBuilders,
          isTodayHighlighted: widget.calendarStyle.isTodayHighlighted,
          isToday: isToday,
          isSelected: widget.selectedDayPredicate?.call(day) ?? false,
          isRangeStart: isRangeStart,
          isRangeEnd: isRangeEnd,
          isWithinRange: isWithinRange,
          isOutside: isOutside,
          isDisabled: isDisabled,
          isWeekend: isWeekend,
          isHoliday: widget.holidayPredicate?.call(day) ?? false,
          locale: widget.locale,
        );

        //달력 날짜 삽입
        children.add(content);

        if (!isDisabled) {
          final events = widget.eventLoader?.call(day) ?? [];
          Widget? markerWidget =
          widget.calendarBuilders.markerBuilder?.call(context, day, events);

          if (events.isNotEmpty && markerWidget == null) {
            final center = constraints.maxHeight / 2;

            final markerSize = widget.calendarStyle.markerSize ??
                (shorterSide - widget.calendarStyle.cellMargin.vertical) *
                    widget.calendarStyle.markerSizeScale;

            final markerAutoAlignmentTop = center +
                (shorterSide - widget.calendarStyle.cellMargin.vertical) / 3 -
                (markerSize * widget.calendarStyle.markersAnchor);

            markerWidget = PositionedDirectional(
              top: widget.calendarStyle.markersAutoAligned
                  ? markerAutoAlignmentTop
                  : widget.calendarStyle.markersOffset.top,
              bottom: widget.calendarStyle.markersAutoAligned
                  ? null
                  : widget.calendarStyle.markersOffset.bottom,
              start: widget.calendarStyle.markersAutoAligned
                  ? null
                  : widget.calendarStyle.markersOffset.start,
              end: widget.calendarStyle.markersAutoAligned
                  ? widget.calendarStyle.markersOffset.end
                  : null,
              child: Container(
                width: 18, // 원형의 크기
                height: 18,
                decoration: const BoxDecoration(
                  color: greenColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${events.length}',
                    style: const TextStyle(
                      color: whiteColor,
                      fontSize: 10, // 텍스트 크기
                    ),
                  ),
                ),
              )
            );
          }

          if (markerWidget != null) {
            // children.add(markerWidget);
            children.add(markerWidget);
          }
        }

        return Stack(
          alignment: widget.calendarStyle.markersAlignment,
          clipBehavior: widget.calendarStyle.canMarkersOverflow
              ? Clip.none
              : Clip.hardEdge,
          children: children,
        );
      },
    );
  }

  Widget _buildSingleMarker(DateTime day, T event, double markerSize) {
    return widget.calendarBuilders.singleMarkerBuilder
        ?.call(context, day, event) ??
        Container(
          width: markerSize,
          height: markerSize,
          margin: widget.calendarStyle.markerMargin,
          decoration: widget.calendarStyle.markerDecoration,
        );
  }

  int _calculateWeekNumber(DateTime date) {
    final middleDay = date.add(const Duration(days: 3));
    final dayOfYear = _dayOfYear(middleDay);

    return 1 + ((dayOfYear - 1) / 7).floor();
  }

  int _dayOfYear(DateTime date) {
    return normalizeDate(date)
        .difference(DateTime.utc(date.year, 1, 1))
        .inDays +
        1;
  }

  bool _isWithinRange(DateTime day, DateTime start, DateTime end) {
    if (isSameDay(day, start) || isSameDay(day, end)) {
      return true;
    }

    if (day.isAfter(start) && day.isBefore(end)) {
      return true;
    }

    return false;
  }

  bool _isDayDisabled(DateTime day) {
    return day.isBefore(widget.firstDay) ||
        day.isAfter(widget.lastDay) ||
        !_isDayAvailable(day);
  }

  bool _isDayAvailable(DateTime day) {
    return widget.enabledDayPredicate == null
        ? true
        : widget.enabledDayPredicate!(day);
  }

  DateTime _firstDayOfMonth(DateTime month) {
    return DateTime.utc(month.year, month.month, 1);
  }

  DateTime _lastDayOfMonth(DateTime month) {
    final date = month.month < 12
        ? DateTime.utc(month.year, month.month + 1, 1)
        : DateTime.utc(month.year + 1, 1, 1);
    return date.subtract(const Duration(days: 1));
  }

  bool _isBeforeMonth(DateTime day, DateTime month) {
    if (day.year == month.year) {
      return day.month < month.month;
    } else {
      return day.isBefore(month);
    }
  }

  bool _isAfterMonth(DateTime day, DateTime month) {
    if (day.year == month.year) {
      return day.month > month.month;
    } else {
      return day.isAfter(month);
    }
  }

  bool _isWeekend(
      DateTime day, {
        List<int> weekendDays = const [DateTime.saturday, DateTime.sunday],
      }) {
    return weekendDays.contains(day.weekday);
  }
}
