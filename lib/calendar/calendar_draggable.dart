import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

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
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('todos');
  List<TodoItem> _filteredTodoItems= []; // 선택된 날의 일정을 담아놓는 일정 리스트. 나중에 데이터베이스와 연결하기

  @override
  void initState() {
    super.initState();
    _loadFilteredTodoItems();
  }

  @override
  void didUpdateWidget(CalendarDraggable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDay != widget.selectedDay) {
      _loadFilteredTodoItems();
    }
  }

  void _loadFilteredTodoItems() {
    final selectedDateStr = DateFormat('yyyy-MM-dd').format(widget.selectedDay);
    
    _database.orderByChild('date').startAt(selectedDateStr).endAt(selectedDateStr + '\uf8ff').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          _filteredTodoItems = (event.snapshot.value as Map<dynamic, dynamic>)
              .entries
              .map((e) {
                final todoItem = TodoItem.fromSnapshot(e.key, e.value as Map<dynamic, dynamic>);
                // 날짜만 비교
                if (isSameDay(todoItem.date, widget.selectedDay)) {
                  return todoItem;
                }
                return null;
              })
              .where((item) => item != null)
              .cast<TodoItem>()
              .toList();
        });
        print("${selectedDateStr}에 대해 로드된 일정 수: ${_filteredTodoItems.length}");
      } else {
        setState(() {
          _filteredTodoItems = [];
        });
        print("${selectedDateStr}에 대한 일정이 없습니다.");
      }
    }, onError: (error) {
      print("데이터 로딩 오류: $error");
    });
  }

  // 날짜만 비교하는 헬퍼 함수
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
          date1.month == date2.month && 
          date1.day == date2.day;
  }

  void _deleteTodoItem(TodoItem deletedItem) {
    _database.child(deletedItem.userId!).remove().then((_) {
      setState(() {
        _filteredTodoItems.remove(deletedItem);
      });
    }).catchError((error) {
      print("삭제 오류: $error");
    });
  }

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
                          final newTodo = await Navigator.push( // schedule에 pop하면서 리턴되는 TodoItem을 받습니다
                            context,
                            MaterialPageRoute(builder: (context) => AddTodo()), // TodoItem 리턴
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Container(
                  height: size.height * 0.6 - padding.bottom,
                  child: TodoList(
                    todoItems: _filteredTodoItems,
                    onDelete: _deleteTodoItem,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}