import 'package:flutter/material.dart';
import '../main.dart';

void main() async {
  runApp(const SettingApp());
}

class SettingApp extends StatefulWidget {
  const SettingApp({super.key});

  @override
  _SettingAppState createState() => _SettingAppState();
}

class _SettingAppState extends State<SettingApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SettingPage(),
    );
  }
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
                    size: Size(constraints.maxWidth / 3, constraints.maxWidth / 3),
                    painter: CirclePainter(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // profile.dart
                      _buildButton('프로필 설정', () {
                        Navigator.pop(context);
                      }),
                      // theme.dart
                      _buildButton('테마 설정', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyApp()),
                        );
                      }),
                      // danchu_collection.dart
                      _buildButton('모은 단추 확인하기', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyApp()),
                        );
                      }),
                      _buildButton('개발자에게 문의하기', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyApp()),
                        );
                      }),
                      _buildButton('계정 탈퇴하기', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyApp()),
                        );
                      }),
                    ],
                  ),
                ),
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