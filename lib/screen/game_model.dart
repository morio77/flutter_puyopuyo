import 'package:flutter/material.dart';

import '../model/puyo_model.dart';
import '../utils/puyo_utils.dart';

class GameModel extends ChangeNotifier {
  // 定数など
  static const int fieldWidth = 6;
  static const int fieldHeight = 13;
  static const int nextPuyoCount = 2;

  // ゲームの状態値
  bool isPlaying = false;

  // ぷよに関する状態値
  List<PuyoModel> fixedPuyos = []; // 落ちて固まったぷよのリスト
  PairPuyoModel? fallingPairPuyo; // 落下中のペアぷよ
  List<PairPuyoModel> nextPairPuyos = []; // NEXTのペアぷよ（リスト）

  GameModel() {
    // NEXTのペアぷよを生成する
    for (var i = 0; i < nextPuyoCount + 1; i++) {
      nextPairPuyos.add(PuyoUtils.generatePairPuyoModel());
    }
  }

  // ゲーム開始時に呼ぶ
  void startGame() {
    isPlaying = true;
    mainLoop();
    notifyListeners();
    return;
  }

  // メインのループ
  Future<void> mainLoop() async {
    await Future.delayed(const Duration(seconds: 2));
    _endGame();
  }

  // ゲーム終了時に呼ぶ
  void _endGame() {
    isPlaying = false;
    notifyListeners();
  }
}
