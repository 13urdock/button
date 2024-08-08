import 'package:flutter/material.dart';

import '/diary/diary.dart';

class DanchuDraggable extends StatefulWidget {
  final DateTime selectedDay;
  const DanchuDraggable({Key? key, required this.selectedDay})
      : super(key: key);
  @override
  _DanchuDraggableState createState() => _DanchuDraggableState();
}

class _DanchuDraggableState extends State<DanchuDraggable> {
  //일기 목록
  List<DiaryEntry> entries = [];

  void _addEntry(String content) {
    setState(() {
      entries.add(DiaryEntry(content: content, date: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.35,
      maxChildSize: 1.0,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            //draggablesheet 스타일
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
                    //회색 상단 바
                    width: 40,
                    height: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                Text(
                  '${widget.selectedDay.toString().split(' ')[0]}', //가져온 날짜 사용
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  //목록 추가 버튼
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DiaryPage()),
                    ).then((value) {
                      if (value != null) {
                        _addEntry(value);
                      }
                    });
                  },
                ),
                ListView.builder(
                  //목록 스크롤
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(entries[index].content),
                      subtitle:
                          Text(entries[index].date.toString().split(' ')[0]),
                    );
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
