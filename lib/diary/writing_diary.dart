import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/src/color.dart';
import 'diary_entry.dart';
import 'stt.dart';

class WritingDiary extends StatefulWidget {
  final DateTime selectedDate;

  const WritingDiary({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _WritingDiaryState createState() => _WritingDiaryState();
}

class _WritingDiaryState extends State<WritingDiary> {
  final TextEditingController _diaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일',
        ),
        backgroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.black),
            onPressed: _openSTT,
          ),
          TextButton(
            onPressed: () => _saveDiary(context),
            child: const Text('저장', style: TextStyle(color: Colors.black)),
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
                child: Image.asset('assets/empty.png'),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.danchuYellow,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildContentBox(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
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
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Future<void> _openSTT() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => STT(selectedDate: widget.selectedDate)),
    );
    if (result != null) {
      setState(() {
        _diaryController.text = result;
      });
    }
  }

  void _saveDiary(BuildContext context) {
    if (_diaryController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('danchu')
          .doc(DateFormat('yyyy-MM-dd').format(widget.selectedDate))
          .set({
        'date': widget.selectedDate,
        'content': _diaryController.text,
        'danchu': "미정",
      }).then((_) {
        Navigator.pop(
          context,
          DiaryEntry(
            content: _diaryController.text,
            date: widget.selectedDate,
            danchu: '미정',
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('일기 저장 중 오류가 발생했습니다.')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('일기 내용을 입력해주세요.')),
      );
    }
  }
}