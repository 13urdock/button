import 'package:flutter/material.dart';

class DiaryApp extends StatefulWidget {
  const DiaryApp({super.key});

  @override
  _DiaryAppState createState() => _DiaryAppState();
}

class _DiaryAppState extends State<DiaryApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DiaryPage(),
    );
  }
}

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: CustomPaint(
                    size: Size(
                        constraints.maxWidth / 3, constraints.maxWidth / 3),
                    painter: CirclePainter(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(), // content of diary
              ),
            ],
          );
        },
      ),
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
      ..color = Colors.blue // 원하는 색상으로 변경 가능
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
