import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:danchu/icon_selector_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../models/todo_item.dart';
import '../models/custom_circle_icon.dart';
import '/src/color.dart';
import '/src/time_picker.dart';

class AddTodo extends StatefulWidget {
  final DateTime selectedDay;

  AddTodo({required this.selectedDay});
  
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Color _selectedColor = Color(0xffb7b7b7);
  DateTime _selectedDate = DateTime.now();
  DateTime _beginTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(Duration(hours: 1));
  bool isAllDay = false;
  bool isRoutine = false;

  final FirebaseFirestore _todos = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    _selectedDate = widget.selectedDay ?? DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('새 할 일 추가', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(screenSize),
              SizedBox(height: screenSize.height * 0.02),
              _buildDatePicker(screenSize),
              SizedBox(height: screenSize.height * 0.02),
              _buildAllDayToggle(screenSize),
              if (!isAllDay) _buildTimeSettings(screenSize, isSmallScreen),
              _buildRoutineToggle(screenSize),
              SizedBox(height: screenSize.height * 0.02),
              if (isRoutine) _buildRoutineCalendar(screenSize),
              _buildDescriptionField(screenSize),
              SizedBox(height: screenSize.height * 0.05),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveTodoItem,
          child: Text('저장하기', style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: AppColors.danchuYellow,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size screenSize) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _showIconSelector(),
          child: Container(
            width: screenSize.width * 0.1,
            height: screenSize.width * 0.1,
            padding: EdgeInsets.all(screenSize.width * 0.01),
            child: CustomCircleIcon(
              isSelected: true,
              color: _selectedColor,
              size: screenSize.width * 0.08,
            ),
          ),
        ),
        SizedBox(width: screenSize.width * 0.03),
        Expanded(
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: '제목',
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(Size screenSize) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: '날짜',
          labelStyle: TextStyle(color: Colors.black),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
              style: TextStyle(color: Colors.black),
            ),
            Icon(Icons.calendar_today, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildAllDayToggle(Size screenSize) {
    return Row(
      children: [
        Text('하루종일',
            style: TextStyle(
                fontSize: screenSize.width * 0.04, color: Colors.black)),
        Spacer(),
        Switch(
          value: isAllDay,
          onChanged: (value) {
            setState(() {
              isAllDay = value;
            });
          },
          activeColor: AppColors.danchuYellow,
        ),
      ],
    );
  }

  Widget _buildTimeSettings(Size screenSize, bool isSmallScreen) {
    return isSmallScreen
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimePicker(
                title: '시작 시간',
                time: _beginTime,
                onChanged: (time) => setState(() => _beginTime = time),
              ),
              SizedBox(height: screenSize.height * 0.02),
              TimePicker(
                title: '종료 시간',
                time: _endTime,
                onChanged: (time) => setState(() => _endTime = time),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TimePicker(
                  title: '시작 시간',
                  time: _beginTime,
                  onChanged: (time) {
                    setState(() => _beginTime = time);
                  }),
              SizedBox(width: screenSize.width * 0.02),
              TimePicker(
                  title: '종료 시간',
                  time: _endTime,
                  onChanged: (time) {
                    setState(() => _endTime = time);
                  }),
            ],
          );
  }

  Widget _buildRoutineToggle(Size screenSize) {
    return Row(
      children: [
        Icon(Icons.repeat, size: screenSize.width * 0.05, color: Colors.black),
        SizedBox(width: screenSize.width * 0.02),
        Text('루틴 설정',
            style: TextStyle(
                fontSize: screenSize.width * 0.04, color: Colors.black)),
        Spacer(),
        Switch(
          value: isRoutine,
          onChanged: (value) {
            setState(() {
              isRoutine = value;
            });
          },
          activeColor: AppColors.danchuYellow,
        ),
      ],
    );
  }

  Widget _buildRoutineCalendar(Size screenSize) {
    return Container(
      height: screenSize.height * 0.3,
      child: Center(
        child: Text('캘린더 위젯 (구현 필요)',
            style: TextStyle(
                fontSize: screenSize.width * 0.04, color: Colors.black)),
      ),
    );
  }

  Widget _buildDescriptionField(Size screenSize) {
    return TextField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: '설명',
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
      style: TextStyle(color: Colors.black),
    );
  }

  void _showIconSelector() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return IconSelector(
          onColorSelected: (Color color) {
            setState(() {
              _selectedColor = color;
            });
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.danchuYellow, // 선택된 날짜 색상
                onPrimary: Colors.black, // 선택된 날짜의 텍스트 색상
                onSurface: Colors.black, // 캘린더의 텍스트 색상
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black, // 버튼 텍스트 색상
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CalendarDatePicker(
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                    onDateChanged: (DateTime newDate) {
                      setState(() {
                        _selectedDate = newDate;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveTodoItem() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('제목과 설명을 모두 입력해주세요.')),
      );
      return;
    }

    final newTodo = TodoItem(
      date: _selectedDate,
      title: _titleController.text,
      description: _descriptionController.text,
      beginTime: isAllDay ? null : _beginTime,
      endTime: isAllDay ? null : _endTime,
      isRoutine: isRoutine,
      isAllDay: isAllDay,
      iconColor: _selectedColor,
    );

    try {
      await _todos
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .add(newTodo.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('할 일이 성공적으로 저장되었습니다.')),
      );
      Navigator.of(context).pop(); // 저장 후 이전 페이지로 돌아갑니다.
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 중 오류가 발생했습니다: $error')),
      );
    }
  }
}
