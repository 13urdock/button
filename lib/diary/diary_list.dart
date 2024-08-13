//일기 목록(밑 부분)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'diary_entry.dart';
import '/src/color.dart';

class DiaryList extends StatelessWidget {
  final List<DiaryEntry> diaries;

  DiaryList({required this.diaries});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: diaries.length,
      itemBuilder: (context, index) {
        final diary = diaries[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: InkWell(
              onTap: () {}, //viewing연결
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    //단추 추가하기
                    Icon(Icons.book, size: 40, color: AppColors.danchuYellow),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            //날짜
                            DateFormat('yyyy년 MM월 dd일').format(diary.date),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            //일기
                            diary.content,
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
          ),
        );
      },
    );
  }
}
