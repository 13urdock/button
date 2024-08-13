//danchu page에서 날짜, 선택한 날짜 일기 보이는 부분

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/diary/diary_entry.dart';
import '/diary/empty_diary.dart';
import '/src/color.dart';

class DateFunction {
  static DateTime _removeDateTimeComponents(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static void addOrUpdateEntry(
      Map<DateTime, DiaryEntry> diaries, DiaryEntry diaryEntry) {
    DateTime dateKey = _removeDateTimeComponents(diaryEntry.date);
    diaries[dateKey] = diaryEntry;
  }

  static DiaryEntry? getSelectedDayEntry(
      Map<DateTime, DiaryEntry> diaries, DateTime selectedDay) {
    DateTime dateKey = _removeDateTimeComponents(selectedDay);
    return diaries[dateKey];
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class DiaryContentWidget extends StatelessWidget {
  final DiaryEntry? selectedDayEntry;
  final DateTime selectedDay;
  final Function(DiaryEntry) onAddOrUpdateEntry;

  const DiaryContentWidget({
    Key? key,
    required this.selectedDayEntry,
    required this.selectedDay,
    required this.onAddOrUpdateEntry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: selectedDayEntry != null
          ? Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.danchuYellow,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //단추로 바꾸기
                    Icon(Icons.book, size: 40, color: AppColors.danchuYellow),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            //날짜
                            DateFormat('yyyy년 MM월 dd일')
                                .format(selectedDayEntry!.date),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            //일기
                            selectedDayEntry!.content,
                            style: TextStyle(fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              //목록 없을경우 empty
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmptyDiary(
                        selectedDate: selectedDay,
                      ),
                    ),
                  ).then((value) {
                    if (value != null && value is DiaryEntry) {
                      onAddOrUpdateEntry(value);
                    }
                  });
                },
                child: Image.asset(
                  'assets/newDanchu.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
    );
  }
}
