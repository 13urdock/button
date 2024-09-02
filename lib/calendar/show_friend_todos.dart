import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'show_friend_list.dart';

class ShowFriendTodos extends StatefulWidget {
  final String userId;

  const ShowFriendTodos({Key? key, required this.userId}) : super(key: key);

  @override
  _ShowFriendTodosState createState() => _ShowFriendTodosState();
}

class _ShowFriendTodosState extends State<ShowFriendTodos> {
  late DateTime _currentWeekStart;
  final ScrollController _scrollController = ScrollController();
@override
  void initState() {
    super.initState();
    _currentWeekStart = _getWeekStart(DateTime.now());
  }

  DateTime _getWeekStart(DateTime date) {
    // 시간, 분, 초를 0으로 설정하여 날짜만 고려합니다.
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateOnly.subtract(Duration(days: dateOnly.weekday - 1));
  }

  void _changeWeek(int weeks) {
    setState(() {
      _currentWeekStart = DateTime(
        _currentWeekStart.year,
        _currentWeekStart.month,
        _currentWeekStart.day + (7 * weeks),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend\'s Schedule'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            child: ShowFriendList(),
          ),
          _buildWeekNavigator(),
          Expanded(
            child: _buildScheduleContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekNavigator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => _changeWeek(-1),
          ),
          Text(
            '${DateFormat('MM/dd').format(_currentWeekStart)} - ${DateFormat('MM/dd').format(_currentWeekStart.add(Duration(days: 6)))}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () => _changeWeek(1),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleContent() {
  print('Loading todos for user ID: ${widget.userId}');
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: widget.userId)
        .limit(1)
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
      if (userSnapshot.hasError) {
        return Text('Error: ${userSnapshot.error}');
      }

      if (userSnapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (userSnapshot.data == null || userSnapshot.data!.docs.isEmpty) {
        return Text('User not found');
      }

      String userDocId = userSnapshot.data!.docs.first.id;

      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userDocId)
            .collection('todos')
            .where('beginTime', isGreaterThanOrEqualTo: _currentWeekStart)
            .where('beginTime', isLessThan: _currentWeekStart.add(Duration(days: 7)))
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> todosSnapshot) {
          if (todosSnapshot.hasError) {
            return Text('Error: ${todosSnapshot.error}');
          }

          if (todosSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // 디버깅: 받아온 데이터 출력
          print('name of the user: ${widget.userId}');
          print('Received ${todosSnapshot.data!.docs.length} todos');
          todosSnapshot.data!.docs.forEach((doc) {
            print('Todo: ${doc['title']}, Start: ${doc['beginTime']}, End: ${doc['endTime']}');
          });

          return _buildSchedule(todosSnapshot.data!.docs);
        },
      );
    },
  );
}

  Widget _buildSchedule(List<QueryDocumentSnapshot> todos) {
    final double hourHeight = 60.0;
    final int startHour = 7;
    final int endHour = 24;

    return SingleChildScrollView(
      controller: _scrollController,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 시간 열
          SizedBox(
            width: 50,
            child: Column(
              children: [
                SizedBox(height: 30),
                ...List.generate(endHour - startHour, (index) {
                  final hour = startHour + index;
                  return SizedBox(
                    height: hourHeight,
                    child: Center(
                      child: Text(
                        '${hour.toString().padLeft(2, '0')}:00',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          // 요일별 일정
          ...List.generate(7, (dayIndex) {
            final day = _currentWeekStart.add(Duration(days: dayIndex));
            final dayTodos = todos.where((todo) {
              final startTime = (todo['beginTime'] as Timestamp).toDate();
              return startTime.year == day.year &&
                  startTime.month == day.month &&
                  startTime.day == day.day;
            }).toList();

            return Expanded(
              child: Column(
                children: [
                  Container(
                    height: 30,
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: Text(DateFormat('E').format(day)),
                  ),
                  Container(
                    height: hourHeight * (endHour - startHour),
                    child: Stack(
                      children: [
                        // 시간 구분선
                        ...List.generate(endHour - startHour, (hourIndex) {
                          return Positioned(
                            top: hourHeight * hourIndex,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 1,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          );
                        }),
                        // 일정 항목
                        ...dayTodos.map((todo) => _buildTodoItem(todo, hourHeight, startHour)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTodoItem(QueryDocumentSnapshot todo, double hourHeight, int startHour) {
    final startTime = (todo['beginTime'] as Timestamp).toDate();
    final endTime = (todo['endTime'] as Timestamp).toDate();
    
    final startOffset = (startTime.hour - startHour + startTime.minute / 60) * hourHeight;
    final duration = endTime.difference(startTime);
    final height = duration.inMinutes / 60 * hourHeight;

    return Positioned(
      top: startOffset,
      left: 2,
      right: 2,
      height: height,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _getColorForTodo(todo),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}\n${todo['title']}',
          style: TextStyle(fontSize: 10, color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Color _getColorForTodo(QueryDocumentSnapshot todo) {
    // TODO: Implement color logic based on todo type or category
    return Colors.blue.withOpacity(0.7);
  }
}