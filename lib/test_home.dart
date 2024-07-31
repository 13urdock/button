import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:rxdart/rxdart.dart';

void main() async {
  runApp(const TestDiaryApp());
}

class TestDiaryApp extends StatefulWidget {
  const TestDiaryApp({super.key});

  @override
  _TestDiaryAppState createState() => _TestDiaryAppState();
}

class _TestDiaryAppState extends State<TestDiaryApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TestDiaryPage(),
    );
  }
}

class TestDiaryPage extends StatefulWidget {
  const TestDiaryPage({super.key});

  @override
  _TestDiaryPageState createState() => _TestDiaryPageState();
}

class _TestDiaryPageState extends State<TestDiaryPage> {
  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      title: Text("Title"),
      headerWidget: TestDiaryPage(),
      body: [
        Container(
          // child: Text(
          //   'Hello, Flutter!',
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 20,
          //   ),
          // ),
        ),
        // shrinkWrap true required for ListView.builder()
        // disable the scroll for any vertically scrollable widget
        // provide top padding 0 to fix extra space in listView
        ListView.builder(
          padding: EdgeInsets.only(top: 0),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              title: Text("$index"),
            ),
          ),
        ),
      ]
);
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue  // 원하는 색상으로 변경 가능
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}