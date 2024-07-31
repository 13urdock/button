import 'package:flutter/material.dart';
import '../src/color.dart';

class TodoList extends StatefulWidget {
  const TodoList(Key? key) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> todos = [];

  void addTodo() {
    setState(() {
      todos.add('새로운 할 일 ${todos.length + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // 할일 목록
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: todos.asMap().entries.map((entry) {
        final index = entry.key;
        final todo = entry.value;
        return Dismissible(
          key: Key(todo),
          onDismissed: (direction) {
            // 슬라이드 하면 삭제하는 버튼
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
    );
  }
}
