import 'package:flutter/material.dart';
import 'package:flutter_puyopuyo/model/puyo_model.dart';
import 'package:flutter_puyopuyo/utils/puyo_constants.dart';

class MainPuyoPainter extends CustomPainter {
  final List<PuyoModel> fixedPuyos;
  final PairPuyoModel? fallingPairPuyo;
  MainPuyoPainter(this.fixedPuyos, this.fallingPairPuyo);

  @override
  void paint(Canvas canvas, Size size) {
    // 枠線を描画する
    final height = size.height;
    final width = size.width;
    final borderPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final borderPath = Path();
    borderPath.moveTo(0, 0);
    borderPath.lineTo(0, height);
    borderPath.lineTo(width, height);
    borderPath.lineTo(width, 0);
    borderPath.lineTo(0, 0);
    borderPath.close();

    canvas.drawPath(borderPath, borderPaint);

    final cellSize = Size(
      size.width / PuyoConstants.widthCellCount,
      size.height / PuyoConstants.heightCellCount,
    );

    // バツを描画する
    final batsuPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final batsuPath = Path();
    batsuPath.moveTo(cellSize.width * 2, 0);
    batsuPath.lineTo(cellSize.width * 3, cellSize.height);
    canvas.drawPath(batsuPath, batsuPaint);
    batsuPath.moveTo(cellSize.width * 2, cellSize.height);
    batsuPath.lineTo(cellSize.width * 3, 0);
    canvas.drawPath(batsuPath, batsuPaint);
    batsuPath.moveTo(cellSize.width * 3, 0);
    batsuPath.lineTo(cellSize.width * 4, cellSize.height);
    canvas.drawPath(batsuPath, batsuPaint);
    batsuPath.moveTo(cellSize.width * 3, cellSize.height);
    batsuPath.lineTo(cellSize.width * 4, 0);
    canvas.drawPath(batsuPath, batsuPaint);

    // 落下中のぷよを描画する
    if (fallingPairPuyo != null) {
      final axisPuyo = fallingPairPuyo!.axisPuyo;
      final axisPuyoPaint = Paint()..color = axisPuyo.getColor();
      canvas.drawRect(
        Rect.fromLTWH(
          axisPuyo.offset.dx * cellSize.width,
          axisPuyo.offset.dy * cellSize.height,
          cellSize.width,
          cellSize.height,
        ),
        axisPuyoPaint,
      );

      final subPuyo = fallingPairPuyo!.subPuyo;
      final subPuyoPaint = Paint()..color = subPuyo.getColor();
      canvas.drawRect(
        Rect.fromLTWH(
          subPuyo.offset.dx * cellSize.width,
          subPuyo.offset.dy * cellSize.height,
          cellSize.width,
          cellSize.height,
        ),
        subPuyoPaint,
      );
    }

    // Fixぷよを描画する
    for (final puyo in fixedPuyos) {
      final subPuyoPaint = Paint()..color = puyo.getColor();
      canvas.drawRect(
        Rect.fromLTWH(
          puyo.offset.dx * cellSize.width,
          puyo.offset.dy * cellSize.height,
          cellSize.width,
          cellSize.height,
        ),
        subPuyoPaint,
      );
    }

    // ぷよのつながりを描画する
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
