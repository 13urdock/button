import 'package:flutter/material.dart';
import 'package:danchu/icon_selector_popup.dart';

import '../models/todo_item.dart';
import '../models/custom_todo_icon.dart';

class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  bool isAllDay = false;
  bool isRoutine = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Color _selectedColor = Color(0xffb7b7b7);
  DateTime? _selectedDate;
  IconData _selectedIcon = Icons.assignment;

  @override
  Widget build(BuildContext context) {
    // 화면의 크기를 가져옵니다.
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('새 할 일 추가'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05), // 화면 너비의 5%를 패딩으로 사용
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ // 할 일 추가 세팅들
              _buildHeader(screenSize),
              SizedBox(height: screenSize.height * 0.02),
              _buildTimeSettings(screenSize, isSmallScreen),
              SizedBox(height: screenSize.height * 0.02),
              _buildAllDayToggle(screenSize),
              if (!isAllDay) _buildTimeDropdowns(screenSize, isSmallScreen),
              _buildRoutineToggle(screenSize),
              SizedBox(height: screenSize.height * 0.02),
              if (isRoutine) _buildRoutineCalendar(screenSize),
              _buildNotificationSettings(screenSize),
              SizedBox(height: screenSize.height * 0.02),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton( // 완료 버튼
        child: Icon(Icons.check),
        onPressed: () {
          if (_titleController.text.isNotEmpty) {
            Navigator.of(context).pop(TodoItem(
              title: _titleController.text,
              description: _descriptionController.text,
              dueDate: _selectedDate,
              icon: _selectedIcon,
            ));
          }
        },
      ),
    );
  }

  Widget _buildHeader(Size screenSize){ // 아이콘 색상과 todo 제목
    return Row( 
      children: [
        GestureDetector(
          onTap: () {
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
          },
          child: Container(
            width: screenSize.width * 0.1,  // 명시적으로 너비 설정
            height: screenSize.width * 0.1,
            padding: EdgeInsets.all(screenSize.width * 0.01),
            child: CustomCircleIcon(
              isSelected: true,
              color: _selectedColor,
              size: screenSize.width * 0.08, // 화면 너비의 8%로 아이콘 크기 설정
            ),
          ),
        ),
        SizedBox(width: screenSize.width * 0.03), // 간격 추가
        Expanded(
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: '제목'),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSettings(screenSize, isSmallScreen){
    return isSmallScreen
    ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.access_time, size: screenSize.width * 0.05),
            SizedBox(width: screenSize.width * 0.02),
            Text('일정 시작 날짜', style: TextStyle(fontSize: screenSize.width * 0.04)),
          ],
        ),
        SizedBox(height: screenSize.height * 0.01),
        Text('일정 시작 시간', style: TextStyle(fontSize: screenSize.width * 0.04)),
      ],
    )
    : Row(
      children: [
        Icon(Icons.access_time, size: screenSize.width * 0.03),
        SizedBox(width: screenSize.width * 0.01),
        Text('일정 시작 날짜', style: TextStyle(fontSize: screenSize.width * 0.025)),
        Spacer(),
        Text('일정 시작 시간', style: TextStyle(fontSize: screenSize.width * 0.025)),
      ],
    );
  }

  Widget _buildAllDayToggle(Size screenSize) {
    return Row(
      children: [
        Text('하루종일', style: TextStyle(fontSize: screenSize.width * 0.04)),
        Spacer(),
        Switch(
          value: isAllDay,
          onChanged: (value) {
            setState(() {
              isAllDay = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTimeDropdowns(Size screenSize, bool isSmallScreen) {
    return isSmallScreen
    ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton(
            items: [],
            onChanged: null,
            hint: Text('시작 시간', style: TextStyle(fontSize: screenSize.width * 0.04)),
          ),
          SizedBox(height: screenSize.height * 0.01),
          DropdownButton(
            items: [],
            onChanged: null,
            hint: Text('종료 시간', style: TextStyle(fontSize: screenSize.width * 0.04)),
          ),
        ],
      )
    : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: DropdownButton(
              items: [],
              onChanged: null,
              hint: Text('시작 시간', style: TextStyle(fontSize: screenSize.width * 0.025)),
            ),
          ),
          SizedBox(width: screenSize.width * 0.02),
          Expanded(
            child: DropdownButton(
              items: [],
              onChanged: null,
              hint: Text('종료 시간', style: TextStyle(fontSize: screenSize.width * 0.025)),
            ),
          ),
        ],
      );
  }

  Widget _buildRoutineToggle(Size screenSize) {
    return Row(
      children: [
        Icon(Icons.repeat, size: screenSize.width * 0.05),
        SizedBox(width: screenSize.width * 0.02),
        Text('루틴 설정', style: TextStyle(fontSize: screenSize.width * 0.04)),
        Spacer(),
        Switch(
          value: isRoutine,
          onChanged: (value) {
            setState(() {
              isRoutine = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRoutineCalendar(Size screenSize) {
    return Container(
      height: screenSize.height * 0.3,
      child: Center(
        child: Text('캘린더 위젯', style: TextStyle(fontSize: screenSize.width * 0.04)),
      ),
    );
  }

  Widget _buildNotificationSettings(Size size) {
    return Row(
      children: [
        Icon(Icons.notifications, size: size.width * 0.05),
        SizedBox(width: size.width * 0.02),
        Text('푸시 알림', style: TextStyle(fontSize: size.width * 0.04)),
        Spacer(),
        Switch(value: true, onChanged: null),
      ],
    );
  }
}