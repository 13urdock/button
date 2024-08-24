import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/diary/diary_entry.dart';
import 'writing_diary.dart';
import '/diary/viewing_diary.dart';
import '/diary/danchu_list.dart';
import '/src/color.dart';

class SelectedDiary extends StatelessWidget {
  final DateTime selectedDay;

  const SelectedDiary({
    Key? key,
    required this.selectedDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('danchu')
          .doc(formattedDate)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          DiaryEntry entry = DiaryEntry(
            content: data['content'],
            date: selectedDay,
            danchu: data['danchu'], //단추 종류로 변경
          );
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildDiaryContent(context, entry),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: !selectedDay.isAfter(DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day))
                ? _buildEmptyDiaryButton(context)
                : SizedBox(), // 미래 날짜일 경우 빈 화면 표시
          );
        }
      },
    );
  }

  Widget _buildDiaryContent(BuildContext context, DiaryEntry entry) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewingDiary(
              selectedDay: selectedDay,
            ),
          ),
        );
      },
      child: Container(
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
              Image.asset(
                Danchu().getDanchu(entry.danchu),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('yyyy년 MM월 dd일').format(entry.date),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      entry.content,
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
      ),
    );
  }

  Widget _buildEmptyDiaryButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WritingDiary(
                selectedDate: selectedDay,
              ),
            ),
          );
        },
        child: Image.asset(
          'assets/empty.png',
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
