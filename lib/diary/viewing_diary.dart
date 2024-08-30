import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/diary/diary_entry.dart';
import '/src/color.dart';
import 'edit_diary.dart';
import 'danchu_list.dart';

class ViewingDiary extends StatelessWidget {
  final DateTime selectedDay;

  const ViewingDiary({Key? key, required this.selectedDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);

    return Scaffold(
        appBar: AppBar(
          title: Text(formattedDate),
          backgroundColor: AppColors.white,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () async {
                  final updatedContent = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDiary(
                        selectedDay: selectedDay,
                      ),
                    ),
                  );
                },
                child: Icon(Icons.edit),
              ),
            ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('danchu')
              .doc(formattedDate)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var data = snapshot.data!.data() as Map<String, dynamic>;
            DiaryEntry diary = DiaryEntry(
              content: data['content'] ?? '',
              date: selectedDay,
              danchu: data['danchu'] ?? '미정',
            );
            String aiSummary = data['aiSummary'] ?? '아직 AI 요약이 없습니다.';
              return Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      child: Center(
                          child: Image.asset(Danchu().getDanchu(diary.danchu))),
                    ),
                  ),
                  Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.danchuYellow,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSectionTitle('AI 요약'),
                      _buildContentBox(
                        context,
                        height: 110,
                        content: aiSummary,
                      ),
                      SizedBox(height: 16),
                      _buildSectionTitle('일기'),
                      Expanded(
                        child: _buildContentBox(
                          context,
                          content: diary.content,
                          scrollable: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildContentBox(BuildContext context,
      {double? height, required String content, bool scrollable = false}) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: scrollable
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  content,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            )
          : Center(
              child: Text(
                content,
                style: TextStyle(fontSize: 14),
              ),
            ),
    );
  }
}
