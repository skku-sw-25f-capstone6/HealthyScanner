import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/component/bottom_button.dart';
import 'package:healthy_scanner/view/archive/archive_list.dart';

class ArchiveCalendarView extends StatefulWidget {
  const ArchiveCalendarView({super.key});

  @override
  State<ArchiveCalendarView> createState() => _ArchiveCalendarViewState();
}

class _ArchiveCalendarViewState extends State<ArchiveCalendarView> {
  final DateTime _today =
      CalendarUtils.dateOnly(DateTime.now()); // 오늘 날짜 (시간 삭제)
  late DateTime _currentMonth; // 현재 달
  DateTime? _selected; // 선택된 날짜

  @override
  void initState() {
    super.initState();
    _currentMonth = CalendarUtils.firstDayOfMonth(_today);
    _selected = _today;
  }

  @override
  Widget build(BuildContext context) {
    final days = CalendarUtils.daysForMonth(_currentMonth, mondayFirst: true);

    final bool isFutureSelected =
        _selected != null && _selected!.isAfter(_today);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 13),
              _MonthHeader(
                month: _currentMonth,
                onPrev: () {
                  setState(() {
                    _currentMonth = CalendarUtils.addMonths(_currentMonth, -1);
                  });
                },
                onNext: () {
                  setState(() {
                    _currentMonth = CalendarUtils.addMonths(_currentMonth, 1);
                  });
                },
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 0),
                  _WeekdayLabel('월'),
                  _WeekdayLabel('화'),
                  _WeekdayLabel('수'),
                  _WeekdayLabel('목'),
                  _WeekdayLabel('금'),
                  _WeekdayLabel('토'),
                  _WeekdayLabel('일'),
                  SizedBox(width: 0),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                  ),
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final day = days[index];

                    // 이전 달, 다음 달 자리 비워두기
                    if (day == null) {
                      return const SizedBox.shrink();
                    }

                    final isToday = CalendarUtils.isSameDate(day, _today);
                    final isSelected = _selected != null &&
                        CalendarUtils.isSameDate(day, _selected!);
                    final isFuture = day.isAfter(_today);

                    // 텍스트 컬러
                    Color textColor;
                    if (isFuture) {
                      textColor = AppColors.stoneGray;
                    } else {
                      textColor = AppColors.staticBlack;
                    }
                    if (isSelected) {
                      textColor = Colors.white;
                    }

                    // 원형 하이라이트 컬러
                    Color? circleColor;
                    if (isSelected) {
                      circleColor = AppColors.mainRed;
                    } else if (isToday) {
                      circleColor = AppColors.warmGray;
                    } else {
                      circleColor = null;
                    }

                    return Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          setState(() => _selected = day);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: circleColor,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${day.day}',
                            style: context.bodyMedium.copyWith(
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              BottomButton(
                text: '기록 확인하기',
                isEnabled: !isFutureSelected,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ArchiveListView()),
                  );
                },
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}

/// 월/연도와 좌우 화살표 헤더
class _MonthHeader extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _MonthHeader({
    required this.month,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final title = '${month.year}년 ${month.month}월';

    return Row(
      children: [
        const SizedBox(width: 5),

        // 2025년 10월
        Text(
          title,
          style: context.footnote2Medium,
        ),
        const Spacer(),

        // 월 이동 버튼
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onPrev,
              highlightColor: Colors.transparent,
              icon: const Icon(Icons.chevron_left, size: 24),
              color: AppColors.staticBlack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            IconButton(
              onPressed: onNext,
              highlightColor: Colors.transparent,
              icon: const Icon(Icons.chevron_right, size: 24),
              color: AppColors.staticBlack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }
}

/// 요일 라벨
class _WeekdayLabel extends StatelessWidget {
  final String text;
  const _WeekdayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Center(
        child: Text(
          text,
          style: context.bodyMedium.copyWith(
            color: AppColors.stoneGray,
          ),
        ),
      ),
    );
  }
}

/// 달력 계산
class CalendarUtils {
  CalendarUtils._();

  static CalendarUtils mondayFirst() => CalendarUtils._();
  static DateTime dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
  static DateTime firstDayOfMonth(DateTime dt) =>
      DateTime(dt.year, dt.month, 1);
  static DateTime addMonths(DateTime base, int delta) {
    final y = base.year;
    final m = base.month + delta;
    const d = 1;
    return DateTime(y, m, d);
  }

  static bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// 해당 월의 달력 그리드를 반환
  /// 월요일 시작, 총 6주 * 7칸 = 42칸 배열을 리턴
  /// 현재 월이 아닌 칸은 null로 채움
  static List<DateTime?> daysForMonth(
    DateTime month, {
    required bool mondayFirst,
  }) {
    final first = firstDayOfMonth(month);
    // DateTime.weekday: Mon=1 ... Sun=7
    int firstWeekday = first.weekday; // 1~7

    // 월요일 시작 기준 offset (월=0, 화=1, ..., 일=6)
    int leading = (firstWeekday + 6) % 7;

    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    const totalCells = 42; // 6주
    final List<DateTime?> out = List<DateTime?>.filled(totalCells, null);

    // 현재 달 날짜 배치
    for (int i = 0; i < daysInMonth; i++) {
      out[leading + i] = DateTime(month.year, month.month, i + 1);
    }
    return out;
  }
}
