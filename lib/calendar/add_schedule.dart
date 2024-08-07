import 'package:flutter/material.dart';
import 'package:danchu/icon_selector_popup.dart';
import 'package:danchu/colorpallet.dart';

import '../models/todo_item.dart';
import '../src/custom_todo_icon.dart';

//TodoItem : 일정 정보 저장하는 클래스, 정보를 받아서 calendar_draggable로 TodoItem을 리턴합니다
//정보 받는 코드들 뿐이라 리턴하는 코드는 line 112부터
class AddSchedulePage extends StatefulWidget {
  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  // TodoItem(models/todo_item.dart)에 추가될 데이터들 제목, 설명, 날짜, 아이콘 색상
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
            TextField( // 계획 제목
              controller: _titleController,
              decoration: InputDecoration(labelText: '제목'),
            ),
            TextField( // 계획 설명
              controller: _descriptionController,
              decoration: InputDecoration(labelText: '설명'),
            ),
            SizedBox(height: 20), // 아이콘 간 간격. 의미 없음

            ElevatedButton( // 날짜 선택 팝업
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
            GestureDetector( // 아이콘 색상 정하는 창
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('COLOR'),
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
                onPressed: () async {  // 아이콘 색깔 선택창
                  final Color? selectedColor = await showDialog<Color>( // Color? 타입으로 결과를 받습니다.
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('COLOR'),
                        content: IconSelector(
                          onColorSelected: (Color color) {
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  );

                  if (selectedColor != null) {
                    print('Selected color: $selectedColor');
                    setState(() {
                      
                    });
                  }
                },
                color: Colors.blue,  // 현재 선택된 색상 또는 기본 색상
                size: 24,  // 원하는 크기로 설정
              ),
            ),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check), // 스케줄 추가 완료 버튼, 입력된 데이터들은 calendar_draggble에 표시됨
        onPressed: () {
          if (_titleController.text.isNotEmpty) {
            Navigator.of(context).pop(TodoItem( // TodoItem 정보 저장 후 리턴하면 calendar_draggable에 있는 schedule에 저장됨
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