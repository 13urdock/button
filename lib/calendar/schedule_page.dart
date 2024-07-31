import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../src/color.dart';
import 'add_schedule.dart';

class SchedulePage extends StatefulWidget {
  final DateTime selectedDay;
  final ScrollController scrollController;

  const SchedulePage({
    Key? key,
    required this.selectedDay,
    required this.scrollController,
  }) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<TodoItem> todos = []; // to do list array

  Future<void> addTodo() async {
    final result = await Navigator.push<TodoItem>(
      context,
      MaterialPageRoute(builder: (context) => AddSchedulePage()),
    );
    
    if (result != null) {
      setState(() {
        todos.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.scrollController,
      children: [
        Center( // draggable 상단 바
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
        Padding( // 날짜, 일기 추가
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text( // 날짜
                '${widget.selectedDay.year}년 ${widget.selectedDay.month}월 ${widget.selectedDay.day}일 일정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton( // todo list 추가 
                icon: Icon(Icons.add),
                onPressed: addTodo,
              ),
            ],
          ),
        ),
        ListView( // todo list
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: todos.asMap().entries.map((entry) {
            final index = entry.key;
            final todo = entry.value;
            return Dismissible(
              key: Key(todo.title),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() {
                  todos.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${todo.title} 삭제됨')),
                );
              },
              background: Container(color: AppColors.deepYellow),
              child: ListTile( // todo 배치
                leading: Icon(todo.icon),
                title: Text(todo.title),
                subtitle: Text('${todo.description}\n${todo.dueDate?.toString() ?? "날짜 미정"}'),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}