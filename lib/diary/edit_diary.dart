//일기 수정페이지
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/src/color.dart';
import '../danchu/danchu_list.dart';
import 'ai_analyzer.dart';

class EditDiary extends StatefulWidget {
  final DateTime selectedDay;

  const EditDiary({Key? key, required this.selectedDay}) : super(key: key);

  @override
  _EditDiaryState createState() => _EditDiaryState();
}

class _EditDiaryState extends State<EditDiary> {
  TextEditingController _diaryController = TextEditingController();
  String _selectedDanchu = '미정';

  @override
  void initState() {
    super.initState();
    _loadDiaryData();
  }

  @override
  void dispose() {
    _diaryController.dispose();
    super.dispose();
  }

  Future<void> _loadDiaryData() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDay);

    if (user == null) return;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('danchu')
        .doc(formattedDate)
        .get();

    if (doc.exists) {
      var diary = doc.data() as Map<String, dynamic>;
      setState(() {
        _diaryController.text = diary['content'] ?? '';
        _selectedDanchu = diary['danchu'] ?? '미정';
      });
    }
  }

  Future<void> _saveDiary() async {
    //저장함수
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    if (user == null) return;

    if (_diaryController.text.isNotEmpty) {
      Map<String, dynamic> sentimentResult =
          await AISentimentAnalyzer.analyzeSentiment(_diaryController.text);

      String selectedDanchu =
          AISentimentAnalyzer.determineEmotionDanchu(sentimentResult);

      String summary = AISentimentAnalyzer.createSummary(sentimentResult);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('danchu')
          .doc(DateFormat('yyyy-MM-dd').format(widget.selectedDay))
          .set({
        'date': widget.selectedDay,
        'content': _diaryController.text,
        'danchu': selectedDanchu,
        'summary': summary,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일기가 저장되었습니다.')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일기 내용을 입력해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
        backgroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () => _deleteDiary(context),
          ),
          TextButton(
            onPressed: _saveDiary,
            child: Text('저장장장장장장', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Image.asset(Danchu().getDanchu(_selectedDanchu)),
              ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24, top: 16, bottom: 8),
                    child: Text(
                      '일기',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: _buildContentBox(
                      context,
                      content: _diaryController.text,
                      isEditable: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBox(BuildContext context, //일기작성박스
      {double? height,
      required String content,
      required bool isEditable}) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: isEditable
          ? TextField(
              controller: _diaryController,
              maxLines: null,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(16),
                hintText: '오늘의 일기를 작성해주세요...',
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  content,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
    );
  }

  void _deleteDiary(BuildContext context) {
    //삭제함수
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('일기 삭제'),
          content: Text('정말로 이 일기를 삭제하시겠습니까?'),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              child: Text('취소', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('삭제', style: TextStyle(color: Colors.red)),
              onPressed: () {
                final FirebaseAuth _auth = FirebaseAuth.instance;
                final User? user = _auth.currentUser;
                if (user == null) return;

                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('danchu')
                    .doc(DateFormat('yyyy-MM-dd').format(widget.selectedDay))
                    .delete()
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('일기가 삭제되었습니다.')),
                  );
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  Navigator.of(context).pop(); // EditDiary 페이지 닫기
                  Navigator.of(context).pop(); // ViewingDiary 페이지 닫기
                }).catchError((error) {
                  print("Error deleting document: $error");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('일기 삭제 중 오류가 발생했습니다.')),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}
