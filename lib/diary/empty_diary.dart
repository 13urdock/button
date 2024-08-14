//빈일기, 일기 작성 -> 저장

import 'package:flutter/material.dart';

import '/src/color.dart';
import 'diary_entry.dart';
import 'stt.dart';

class EmptyDiary extends StatefulWidget {
  final DateTime selectedDate;

  const EmptyDiary({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _EmptyDiaryState createState() => _EmptyDiaryState();
}

class _EmptyDiaryState extends State<EmptyDiary> {
  TextEditingController _diaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일'),
        backgroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.mic, color: Colors.black),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => STT()),
              );
              if (result != null) {
                setState(() {
                  _diaryController.text = result;
                });
              }
            },
          ),
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
                child: Image.asset(
                  'assets/danchu_logo.png',
                ),
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
                  SizedBox(height: 16),
                  Expanded(
                    child: _buildContentBox(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBox(BuildContext context) {
    //일기 작성
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: TextField(
        controller: _diaryController,
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
          hintText: '내용을 입력하세요',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
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
    //내용, 날짜 저장
    if (_diaryController.text.isNotEmpty) {
      Navigator.pop(
        context,
        DiaryEntry(content: _diaryController.text, date: widget.selectedDate),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일기 내용을 입력해주세요.')),
      );
    }
  }
}
