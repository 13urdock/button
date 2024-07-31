import 'package:flutter/material.dart';
import '../src/color.dart';

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

  List<String> todos = [];

  // 새로운 할 일을 추가하는 메서드
  void addTodo() {
    setState(() {
      todos.add('새로운 할 일 ${todos.length + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.scrollController,
      children: [
        Center( // 상단 회색 바
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
        Padding( // 날짜, 일정 추가 부분
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text( // 날짜 표시
                '${widget.selectedDay.year}년 ${widget.selectedDay.month}월 ${widget.selectedDay.day}일 일정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton( // 할 일 추가 버튼
                icon: Icon(Icons.add),
                onPressed: addTodo, 
              ),
            ],
          ),
        ),
        ListView( // 할일 목록
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: todos.asMap().entries.map((entry) {
            final index = entry.key;
            final todo = entry.value;
            return Dismissible(
              key: Key(todo),
              onDismissed: (direction) { // 슬라이드 하면 삭제하는 버튼
                setState(() {
                  todos.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$todo 삭제됨')),
                );
              },
              background: Container(color: AppColors.deepYellow),
              child: ListTile(
                title: Text(todo),
              ),
            );
          }).toList(),
        ),
        
      ],
    );
  }
}