import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_puyopuyo/model/puyo_model.dart';

class PuyoUtils {
  static PairPuyoModel generatePairPuyoModel() {
    final axisPuyo = _generatePuyoModel(isAxisPuyo: true);
    final subPuyo = _generatePuyoModel(isAxisPuyo: false);
    const angleCW = AngleCW.arg0;
    return PairPuyoModel(axisPuyo, subPuyo, angleCW);
  }

  static PuyoModel _generatePuyoModel({
    required bool isAxisPuyo,
    PuyoColor? puyoColor,
  }) {
    // 色の指定がない場合、ランダムで色を決定する
    if (puyoColor == null) {
      final random = Random();
      final index = random.nextInt(PuyoColor.values.length);
      puyoColor = PuyoColor.values[index];
    }

    // 軸になるぷよかどうかで、Offsetを調整する
    final offset = Offset(4, isAxisPuyo ? 1 : 0);

    // インスタンス生成してリターン
    return PuyoModel(puyoColor, offset);
  }
}
