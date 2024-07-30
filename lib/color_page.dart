import 'package:flutter/material.dart';

class ColorPage extends StatelessWidget {
  final Color color;
  final String pageName;

  const ColorPage({
    Key? key,
    required this.color,
    required this.pageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: Center(
        child: Text(
          pageName,
          style: TextStyle(
              //color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              //fontSize: 24,
              //fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
