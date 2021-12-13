import 'package:flutter/material.dart';

@immutable
class PairPuyoModel {
  final PuyoModel axisPuyo;
  final PuyoModel subPuyo;
  final AngleCW angleCW;
  const PairPuyoModel(this.axisPuyo, this.subPuyo, this.angleCW);

  PairPuyoModel copyWith({
    PuyoModel? axisPuyo,
    PuyoModel? subPuyo,
    AngleCW? angleCW,
  }) {
    return PairPuyoModel(
      axisPuyo ?? this.axisPuyo,
      subPuyo ?? this.subPuyo,
      angleCW ?? this.angleCW,
    );
  }

  PairPuyoModel fall(double dy) {
    return moveTo(dy: dy);
  }

  PairPuyoModel rotate(bool isCW) {
    final axisPuyoDx = axisPuyo.offset.dx;
    final axisPuyoDy = axisPuyo.offset.dy;
    final nextAngleCW = AngleCW.values[(angleCW.index + (isCW ? 1 : -1)) % 4];
    PuyoModel newSubPuyo;
    switch (nextAngleCW) {
      case AngleCW.arg0: // axisの上へ
        newSubPuyo =
            subPuyo.copyWith(offset: Offset(axisPuyoDx, axisPuyoDy - 1));
        break;
      case AngleCW.arg90: // axisの右へ
        newSubPuyo =
            subPuyo.copyWith(offset: Offset(axisPuyoDx + 1, axisPuyoDy));
        break;
      case AngleCW.arg180: // axisの下へ
        newSubPuyo =
            subPuyo.copyWith(offset: Offset(axisPuyoDx, axisPuyoDy + 1));
        break;
      case AngleCW.arg270: // axisの左へ
        newSubPuyo =
            subPuyo.copyWith(offset: Offset(axisPuyoDx - 1, axisPuyoDy));
        break;
    }
    return copyWith(angleCW: nextAngleCW, subPuyo: newSubPuyo);
  }

  PairPuyoModel moveTo({double dx = 0, double dy = 0}) {
    final fallAxisPuyo = axisPuyo.moveTo(dx: dx, dy: dy);
    final fallSubPuyo = subPuyo.moveTo(dx: dx, dy: dy);
    return copyWith(axisPuyo: fallAxisPuyo, subPuyo: fallSubPuyo);
  }
}

@immutable
class PuyoModel {
  final PuyoColor color;
  final Offset offset;
  const PuyoModel(this.color, this.offset);

  PuyoModel copyWith({
    PuyoColor? color,
    Offset? offset,
  }) {
    return PuyoModel(
      color ?? this.color,
      offset ?? this.offset,
    );
  }

  PuyoModel moveTo({double dx = 0, double dy = 0}) {
    final newDx = offset.dx + dx;
    final newDy = offset.dy + dy;
    final newOffset = Offset(newDx, newDy);
    return copyWith(offset: newOffset);
  }

  Color getColor() {
    switch (color) {
      case PuyoColor.green:
        return Colors.green;
      case PuyoColor.red:
        return Colors.red;
      case PuyoColor.blue:
        return Colors.blue;
      case PuyoColor.yellow:
        return Colors.yellow;
      case PuyoColor.purple:
        return Colors.purple;
    }
  }
}

enum PuyoColor {
  green,
  red,
  blue,
  yellow,
  purple,
}

enum AngleCW {
  arg0,
  arg90,
  arg180,
  arg270,
}
