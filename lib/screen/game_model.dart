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
    fixedPuyos = [];
    _pickNextPuyo();
    mainLoop();
    notifyListeners();
    return;
  }

  // メインのループ
  Future<void> mainLoop() async {
    while (isPlaying) {
      // ぷよを落下させる
      _fallPuyo();

      // 衝突判定
      if (_hasCollide()) {
        // Fix処理
        _fixFallingPuyo();

        // ゲームオーバー判定
        if (_isGameOver()) {
          _endGame();
          return;
        }

        // 次のぷよを出現させる
        _pickNextPuyo();
      }

      await Future.delayed(const Duration(milliseconds: 20));
    }
  }

  // 落下中のぷよを落下させる
  void _fallPuyo() {
    fallingPairPuyo = fallingPairPuyo!.fall(PuyoConstants.fallSpeed);
    notifyListeners();
  }

  // 衝突判定
  bool _hasCollide() {
    // 落下させてみる
    final tmpFallingPuyo = fallingPairPuyo!.fall(PuyoConstants.fallSpeed);
    final axisPuyoDx = tmpFallingPuyo.axisPuyo.offset.dx;
    final axisPuyoDy = tmpFallingPuyo.axisPuyo.offset.dy;
    final subPuyoDx = tmpFallingPuyo.subPuyo.offset.dx;
    final subPuyoDy = tmpFallingPuyo.subPuyo.offset.dy;

    // 下端判定
    const lowerDy = PuyoConstants.heightCellCount - 1;
    if (axisPuyoDy > lowerDy || subPuyoDy > lowerDy) {
      return true;
    }

    // Fixぷよ判定
    // axis, subそれぞれの境界dyを求めてから判定
    double lowerAxisPuyoDy = PuyoConstants.heightCellCount - 1;
    double lowerSubPuyoDy = PuyoConstants.heightCellCount - 1;
    for (final fixPuyo in fixedPuyos) {
      if (fixPuyo.offset.dx == axisPuyoDx) {
        lowerAxisPuyoDy = fixPuyo.offset.dy - 1;
      }
      if (fixPuyo.offset.dx == subPuyoDx) {
        lowerSubPuyoDy = fixPuyo.offset.dy - 1;
      }
    }
    if (axisPuyoDy > lowerAxisPuyoDy || subPuyoDy > lowerSubPuyoDy) {
      return true;
    }

    return false;
  }

  // 落下中のぷよをFixさせる処理
  void _fixFallingPuyo() {
    // ToDo: 片方のぷよを落下させる
    // ToDo: 高さの誤差を補正
    final axisPuyo = fallingPairPuyo!.axisPuyo;
    final subPuyo = fallingPairPuyo!.subPuyo;
    fixedPuyos.addAll([axisPuyo, subPuyo]);
  }

  // ゲームオーバー判定
  bool _isGameOver() {
    return true;
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

  /// ***
  /// ユーザ操作
  /// ***

  // 左移動
  void moveLeft() {
    _tryMoveTo(dx: -1);
    return;
  }

  // 右移動
  void moveRight() {
    _tryMoveTo(dx: 1);
    return;
  }

  // ぷよを動かしてみてダメなら戻す関数
  void _tryMoveTo({double dx = 0, double dy = 0}) {
    final orginFallingPairPuyo = fallingPairPuyo!.copyWith();
    fallingPairPuyo = fallingPairPuyo!.moveTo(dx: dx, dy: dy);
    if (_hasCollide()) {
      fallingPairPuyo = orginFallingPairPuyo.copyWith();
      return;
    }
    notifyListeners();
  }
}
