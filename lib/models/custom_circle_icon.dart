import 'package:flutter/material.dart';

class CustomCircleIcon extends StatelessWidget {
  final double size;
  final Color color;
  final bool isSelected;

  const CustomCircleIcon({
    Key? key,
    this.size = 30,
    this.color = const Color(0xffffc56e),
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CirclePainter(color: color, isSelected: isSelected),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final Color color;
  final bool isSelected;

  _CirclePainter({required this.color, required this.isSelected});

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
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isSelected != isSelected;
  }
}