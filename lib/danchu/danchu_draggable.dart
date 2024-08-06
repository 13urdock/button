import 'package:flutter/material.dart';
import 'package:danchu/diary/diary.dart';

class DanchuDraggable extends StatefulWidget {
  @override
  _DanchuDraggableState createState() => _DanchuDraggableState();
}

class _DanchuDraggableState extends State<DanchuDraggable> {
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
                    width: 40,
                    height: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                IconButton(
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
