import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:danchu/icon_selector_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/todo_item.dart';
import '../models/custom_circle_icon.dart';
import 'calendar_draggable.dart';


class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Color _selectedColor = Color(0xffb7b7b7);
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _beginTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
  bool isAllDay = false;
  bool isRoutine = false;

  final FirebaseFirestore _todos = FirebaseFirestore.instance; // firebase realtime database에 저장할 데이터 리스트
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('새 할 일 추가'),
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
              SizedBox(height: screenSize.height * 0.02),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: _saveTodoItem, // 여기에서 입력된 데이터를 firebase realtime database에 넣습니다
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
            decoration: InputDecoration(labelText: '제목'),
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
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
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

  Widget _buildTimeSettings(Size screenSize, bool isSmallScreen) {
    return isSmallScreen
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimePicker('시작 시간', _beginTime, (time) => setState(() => _beginTime = time!)),
            SizedBox(height: screenSize.height * 0.01),
            _buildTimePicker('종료 시간', _endTime, (time) => setState(() => _endTime = time!)),
          ],
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildTimePicker('시작 시간', _beginTime, (time) => setState(() => _beginTime = time!))),
            SizedBox(width: screenSize.width * 0.02),
            Expanded(child: _buildTimePicker('종료 시간', _endTime, (time) => setState(() => _endTime = time!))),
          ],
        );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, Function(TimeOfDay?) onChanged) {
    return InkWell(
      onTap: () => _selectTime(context, onChanged),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        child: Text('${time.format(context)}'),
      ),
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
    // 여기에 캘린더 드래그 가능한 위젯 구현
    return Container(
      height: screenSize.height * 0.3,
      child: Center(
        child: Text('캘린더 위젯 (구현 필요)', style: TextStyle(fontSize: screenSize.width * 0.04)),
      ),
    );
  }

  Widget _buildDescriptionField(Size screenSize) {
    return TextField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: '설명',
        border: OutlineInputBorder(),
      ),
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context, Function(TimeOfDay?) onChanged) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  void _saveTodoItem() {
    final User? user = _auth.currentUser;

    if(user != null){
      if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
        final newTodo = TodoItem(
          date: _selectedDate,
          title: _titleController.text,
          description: _descriptionController.text,
          beginTime: isAllDay ? null : DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _beginTime.hour, _beginTime.minute),
          endTime: isAllDay ? null : DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _endTime.hour, _endTime.minute),
          isRoutine: isRoutine,
          isAllDay: isAllDay,
          iconColor: _selectedColor,
        );

        _todos.collection('users').doc(user.uid).collection('todos').add(newTodo.toJson()).then((docRef) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('할 일이 성공적으로 저장되었습니다.')),
          );
          Navigator.of(context).pop();
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('저장 중 오류가 발생했습니다: $error')),
          );
        });
      } 
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('제목과 설명을 모두 입력해주세요.')),
        );
      }
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('로그인이 필요합니다.')),
    );
    }
  }
}