import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calendar.dart'; // 날짜와 연결하기 위해서 
import 'calendar_add_todo.dart';
import 'calendar_todo_list.dart';
import '../models/todo_item.dart';

class CalendarDraggable extends StatefulWidget {
  final DateTime selectedDay;

  const CalendarDraggable({Key? key, required this.selectedDay}) : super(key: key);

  @override
  _CalendarDraggableState createState() => _CalendarDraggableState();
}

class _CalendarDraggableState extends State<CalendarDraggable> {
  final List<TodoItem> todoItems = []; // 선택된 날의 일정을 담아놓는 일정 리스트. 나중에 데이터베이스와 연결하기

String getDateText(DateTime selectedDay){
  final now = DateTime.now();
  if (selectedDay.year == now.year &&
      selectedDay.month == now.month &&
      selectedDay.day == now.day) {
    return 'TODAY';
  } 
  else {
    return DateFormat('M.d').format(selectedDay);
  }
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return DraggableScrollableSheet(
      initialChildSize: 0.35, // draggable 첫 위치
      minChildSize: 0.35, // 최소 위치
      maxChildSize: 1.0, // 최대 위치
      builder: (BuildContext context, ScrollController scrollController) {
        return Container( // draggable되는 박스
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Center(
                  child: Container( // 상단 회색 바
                    width: size.width * 0.1,
                    height: 5,
                    margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Row( // 날짜 표시, 일정 추가 버튼
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getDateText(widget.selectedDay),
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, size: size.width * 0.06),
                        onPressed: () async {
                          final schedule = await Navigator.push( // schedule에 pop하면서 리턴되는 TodoItem을 받습니다
                            context,
                            MaterialPageRoute(builder: (context) => AddTodo()), // TodoItem 리턴
                          );
                          if (schedule != null && schedule is TodoItem) {
                            setState(() {
                              todoItems.add(schedule); // todoItems에 받아온 schedule 저장
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Container(
                  height: size.height * 0.6 - padding.bottom,
                  child: TodoList(todos: todoItems),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}