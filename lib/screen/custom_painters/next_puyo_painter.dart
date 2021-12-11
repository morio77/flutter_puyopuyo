import 'package:flutter/material.dart';

class NextPuyoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 枠線を描画する
    final height = size.height;
    final width = size.width;
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, height);
    path.lineTo(width, height);
    path.lineTo(width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);

    // ぷよを描画する

    // ぷよのつながりを描画する
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
