import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/src/color.dart';
import 'diary_entry.dart';
import '/diary/danchu_list.dart';

class EditDiary extends StatefulWidget {
  final DateTime selectedDay;

  const EditDiary({Key? key, required this.selectedDay}) : super(key: key);

  @override
  _EditDiaryState createState() => _EditDiaryState();
}

class _EditDiaryState extends State<EditDiary> {
  TextEditingController _diaryController = TextEditingController();
  TextEditingController _aiController = TextEditingController(text: '내용없음');
  String _selectedDanchu = '미정';

  @override
  void initState() {
    super.initState();
    _loadDiaryData();
  }

  @override
  void dispose() {
    _diaryController.dispose();
    _aiController.dispose();
    super.dispose();
  }

  Future<void> _loadDiaryData() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDay);
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('danchu')
        .doc(formattedDate)
        .get();

    if (doc.exists) {
      var diary = doc.data() as Map<String, dynamic>;
      setState(() {
        _diaryController.text = diary['content'] ?? '';
        _aiController.text = diary['aiSummary'] ?? '내용없음';
        _selectedDanchu = diary['danchu'] ?? '미정';
      });
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
          TextButton(
            onPressed: () {
              _saveDiary(context);
            },
            child: Text('저장', style: TextStyle(color: Colors.black)),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionTitle('AI 요약'),
                  _buildEditableContentBox(
                    context,
                    height: 110,
                    controller: _aiController,
                  ),
                  SizedBox(height: 16),
                  _buildSectionTitle('일기'),
                  Expanded(
                    child: _buildEditableContentBox(
                      context,
                      controller: _diaryController,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEditableContentBox(BuildContext context,
      {required TextEditingController controller, double? height}) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: height == null,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  void _saveDiary(BuildContext context) {
    if (_diaryController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('danchu')
          .doc(DateFormat('yyyy-MM-dd').format(widget.selectedDay))
          .set({
        'date': widget.selectedDay,
        'content': _diaryController.text,
        'aiSummary': _aiController.text,
        'danchu': _selectedDanchu,
      }).then((_) {
        Navigator.pop(
          context,
          DiaryEntry(
            content: _diaryController.text,
            date: widget.selectedDay,
            danchu: _selectedDanchu,
          ),
        );
      }).catchError((error) {
        print("Error writing document: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('일기 저장 중 오류가 발생했습니다.')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일기 내용을 입력해주세요.')),
      );
    }
  }
}
