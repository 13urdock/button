import 'package:flutter/material.dart';

import 'calendar.dart'; // 날짜와 연결하기 위해서
import 'calendar_add_todo.dart';
import 'calendar_todo_list.dart';
import '../models/todo_item.dart';

class CalendarDraggable extends StatefulWidget {
  const CalendarDraggable({Key? key}) : super(key: key);

  @override
  _CalendarDraggableState createState() => _CalendarDraggableState();
}

class _CalendarDraggableState extends State<CalendarDraggable> {
  final List<TodoItem> todoItems = []; // 일정들 담아놓는 리스트

  @override
  Widget build(BuildContext context) {

    return DraggableScrollableSheet(
      initialChildSize: 0.35, //draggable 첫 위치
      minChildSize: 0.35, //최소 위치
      maxChildSize: 1.0, //최대 위치
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          //draggable되는 박스
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
                  // 상단 회색 바
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                Row( // 날짜 표시, 일정 추가 버튼
                  children: [
                    Text('TODAY'), 
                    IconButton(
                      icon: Icon(Icons.add), // 일정 추가 버튼
                      onPressed: () async {
                        final schedule = await Navigator.push( // schedule에 pop하면서 리턴되는 TodoItem을 받습니다
                          context,
                          MaterialPageRoute(builder: (context) => AddTodo()), // TodoItem 리턴
                        );
                        if (schedule != null && schedule is TodoItem){
                          setState((){
                            todoItems.add(schedule); // todoItems에 받아온 schedule 저장
                          });
                        }
                      },
                    ),
                  ],
                ), 
                // 제가 실수한 부분이 여기에요 가로로 배치할 때는 위젯들이 화면을 안 튀어나가는지 확인해주세요
                // 앱 실행하고 Another exception was thrown: RenderBox was not laid out: RenderDecoratedBox#debbe 가 다다다 뜨면 배치한 위젯들의 길이가 화면 밖으로 튀어나간다는 뜻이에요
                TodoList(todos: todoItems), // todos에서 오류가 뜰텐데 schedule_list 파일 처음에 선언된 List<TodoItem>의 변수명과 같다면 앱 작동에 상관없습니다
              ],
            )
          ),
        );
      },
    );
  }
}
