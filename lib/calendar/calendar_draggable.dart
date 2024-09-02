import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'calendar_add_todo.dart';
import 'calendar_todo_list.dart';
import '../models/todo_item.dart';

class CalendarDraggable extends StatefulWidget {
  final DateTime selectedDay;

  const CalendarDraggable({Key? key, required this.selectedDay})
      : super(key: key);

  @override
  _CalendarDraggableState createState() => _CalendarDraggableState();
}

class _CalendarDraggableState extends State<CalendarDraggable> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  Stream<List<TodoItem>> _getTodoItemsStream() {
    final User? user = _auth.currentUser;
    if (user == null) {
      print('로그인하세요');
      return Stream
          .empty(); // Return an empty stream if the user is not logged in
    }

    final DateTime startOfDay = DateTime(widget.selectedDay.year,
        widget.selectedDay.month, widget.selectedDay.day);
    final DateTime endOfDay =
        startOfDay.add(Duration(days: 1)).subtract(Duration(microseconds: 1));
    final Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
    final Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('todos')
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThan: endTimestamp)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TodoItem.fromFirestore(doc)).toList());
  }

  String getDateText(DateTime selectedDay) {
    final now = DateTime.now();
    if (selectedDay.year == now.year &&
        selectedDay.month == now.month &&
        selectedDay.day == now.day) {
      return 'TODAY';
    } else {
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
        return Container(
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
                  child: Container(
                    // 상단 회색 바
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
                  child: Row(
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
                          final newTodo = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddTodo()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                StreamBuilder<List<TodoItem>>(
                  stream: _getTodoItemsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return Container(
                        height: size.height * 0.6 - padding.bottom,
                        child: TodoList(
                          todoItems: snapshot.data!,
                          onDelete: (item) async {
                            final User? user = _auth.currentUser;
                            if (user == null) return;

                            try {
                              await _firestore
                                  .collection('users')
                                  .doc(user.uid)
                                  .collection('todos')
                                  .doc(item.id)
                                  .delete();
                            } catch (error) {
                              print("삭제 오류: $error");
                            }
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
