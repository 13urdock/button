import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../src/custom_todo_icon.dart';
import 'package:danchu/icon_selector_popup.dart';
import 'package:danchu/colorpallet.dart';

class AddSchedulePage extends StatefulWidget {
  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  IconData _selectedIcon = Icons.assignment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // 헤더
        title: Text('새 할 일 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '제목'),
            ),
            TextField(              controller: _descriptionController,
              decoration: InputDecoration(labelText: '설명'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(_selectedDate == null 
                ? '날짜 선택' 
                : '${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}'),
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            Text('아이콘 선택'),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('아이콘 선택'),
                      content: IconSelector(
                        onColorSelected: (Color selectedColor) {
                          print('Selected color: $selectedColor');
                          // 여기에 상태 업데이트 로직을 추가할 수 있습니다.
                        },
                      ),
                    );
                  },
                );
              },
              child: CustomCircleIcon(
                isSelected: true,  // 또는 상태에 따라 true/false
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('아이콘 선택'),
                        content: IconSelector(
                          onColorSelected: (Color selectedColor) {
                            print('Selected color: $selectedColor');
                            // 여기에 상태 업데이트 로직을 추가할 수 있습니다.
                          },
                        ),
                      );
                    },
                  );
                },  // CustomCircleIcon 내부의 onPressed는 비워둡니다.
                color: Colors.blue,  // 원하는 색상으로 설정
                size: 24,  // 원하는 크기로 설정
              ),
            ),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
}