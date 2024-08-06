import 'package:flutter/material.dart';
import 'calendar.dart';

class CalendarDraggable extends StatelessWidget {
  const CalendarDraggable({Key? key}) : super(key: key);

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
          child: ListView(
            controller: scrollController,
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
              Text('test page')
            ],
          ),
        );
      },
    );
  }
}
