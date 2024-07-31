import 'package:flutter/material.dart';

class CustomCircleIcon extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onPressed;
  final double size;
  final Color color;

  const CustomCircleIcon({
    Key? key,
    required this.isSelected,
    required this.onPressed,
    this.size = 30,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        size: Size(size, size),
        painter: _CirclePainter(
          isSelected: isSelected,
          color: color,
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final bool isSelected;
  final Color color;

  _CirclePainter({required this.isSelected, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);

    if (isSelected) {
      paint
        ..style = PaintingStyle.fill
        ..color = color.withOpacity(1);
      canvas.drawCircle(size.center(Offset.zero), size.width / 3.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}