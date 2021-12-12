import 'package:flutter/material.dart';
import 'package:flutter_puyopuyo/utils/puyo_constants.dart';

import '../model/puyo_model.dart';
import '../utils/puyo_utils.dart';

class GameModel extends ChangeNotifier {
  // ゲームの状態値
  bool isPlaying = false;

  // ぷよに関する状態値
  List<PuyoModel> fixedPuyos = []; // 落ちて固まったぷよのリスト
  PairPuyoModel? fallingPairPuyo; // 落下中のペアぷよ
  List<PairPuyoModel> nextPairPuyos = []; // NEXTのペアぷよ（リスト）

  GameModel() {
    // NEXTのペアぷよを生成する
    for (var i = 0; i < PuyoConstants.nextPuyoCount; i++) {
      nextPairPuyos.add(PuyoUtils.generatePairPuyoModel());
    }
  }

  // ゲーム開始時に呼ぶ
  void startGame() {
    isPlaying = true;
    _pickNextPuyo();
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

  // NEXTぷよを押し出して、一つ生成する
  void _pickNextPuyo() {
    fallingPairPuyo = nextPairPuyos.removeAt(0);
    nextPairPuyos.add(PuyoUtils.generatePairPuyoModel());
    notifyListeners();
  }
}
