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