import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../models/custom_circle_icon.dart';
import '../src/color.dart';
import 'calendar_edit_todo.dart';

class TodoList extends StatefulWidget {
  final DateTime today;
  final List<TodoItem> todoItems;
  final Function(TodoItem) onDelete;
  final Function(TodoItem) onEdit;  // 새로 추가된 콜백

  const TodoList({
    Key? key,
    required this.today,
    required this.todoItems,
    required this.onDelete,
    required this.onEdit,  // 새로 추가된 콜백
  }): super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  late List<bool> _isDoneList;

  @override
  void initState() {
    super.initState();
    _isDoneList = List.generate(widget.todoItems.length, (_) => false);
  }

  @override
  void didUpdateWidget(TodoList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.todoItems.length != _isDoneList.length) {
      _isDoneList = List.generate(widget.todoItems.length, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("TodoList: 총 ${widget.todoItems.length}개의 일정이 있습니다.");
    if (widget.todoItems.isEmpty) {
      return Center(child: Text("일정이 없습니다."));
    }
    try {
      return ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: widget.todoItems.length,
        itemBuilder: (context, index) {
          final todo = widget.todoItems[index];
          print("렌더링 중인 일정: ${todo.title}");
          return Dismissible(
            key: Key(todo.id ?? ''),
            onDismissed: (direction) {
              widget.onDelete(todo);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${todo.title} 삭제됨')),
              );
            },
            background: Container(color: AppColors.deepYellow),
            child: ListTile(
              leading: GestureDetector(
                onTap: () {
                  setState(() {
                    _isDoneList[index] = !_isDoneList[index];
                  });
                },
                child: CustomCircleIcon(
                  color: todo.iconColor,
                  isSelected: _isDoneList[index],
                ),
              ),
              title: Text(todo.title),
              subtitle: Text(todo.description),
              onTap: () async {
                final updatedTodo = await Navigator.push<TodoItem>(
                  context,
                  MaterialPageRoute(builder: (context) => EditTodo(todoItem: todo)),
                );
                if (updatedTodo != null) {
                  widget.onEdit(updatedTodo);
                }
              },
            ),
          );
        },
      );
    } catch (e) {
      print("TodoList 렌더링 중 오류 발생: $e");
      return Center(child: Text("일정을 불러오는 중 오류가 발생했습니다."));
    }
  }
}