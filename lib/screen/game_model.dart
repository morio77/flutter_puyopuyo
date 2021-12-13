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

  // ユーザ操作に関する状態値
  double moveThresholdDx = 75;
  double cumulativeDx = 0;

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
      if (_hasCollision()) {
        // Fix処理
        _fixFallingPuyo();

        // ドラッグ変数を初期化
        resetDrag();

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
  bool _hasCollision() {
    final axisPuyoDx = fallingPairPuyo!.axisPuyo.offset.dx;
    final axisPuyoDy = fallingPairPuyo!.axisPuyo.offset.dy;
    final subPuyoDx = fallingPairPuyo!.subPuyo.offset.dx;
    final subPuyoDy = fallingPairPuyo!.subPuyo.offset.dy;

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
        if (lowerAxisPuyoDy > fixPuyo.offset.dy - 1) {
          lowerAxisPuyoDy = fixPuyo.offset.dy - 1;
        }
      }
      if (fixPuyo.offset.dx == subPuyoDx) {
        if (lowerSubPuyoDy > fixPuyo.offset.dy - 1) {
          lowerSubPuyoDy = fixPuyo.offset.dy - 1;
        }
      }
    }
    if (axisPuyoDy > lowerAxisPuyoDy || subPuyoDy > lowerSubPuyoDy) {
      return true;
    }

    // 左右判定
    if (axisPuyoDx < 0 ||
        axisPuyoDx > PuyoConstants.widthCellCount - 1 ||
        subPuyoDx < 0 ||
        subPuyoDx > PuyoConstants.widthCellCount - 1) {
      return true;
    }
    return false;
  }

  // 落下中のぷよをFixさせる処理
  void _fixFallingPuyo() {
    // ToDo: 片方のぷよを落下させる
    // Offsetの誤差を補正
    final axisPuyoOffset = fallingPairPuyo!.axisPuyo.offset;
    final correctAxisPuyoOffset = Offset(
      axisPuyoOffset.dx.round().toDouble(),
      axisPuyoOffset.dy.round().toDouble(),
    );
    final subPuyoOffset = fallingPairPuyo!.subPuyo.offset;
    final correctSubPuyoOffset = Offset(
      subPuyoOffset.dx.round().toDouble(),
      subPuyoOffset.dy.round().toDouble(),
    );

    final axisPuyo =
        fallingPairPuyo!.axisPuyo.copyWith(offset: correctAxisPuyoOffset);
    final subPuyo =
        fallingPairPuyo!.subPuyo.copyWith(offset: correctSubPuyoOffset);
    fixedPuyos.addAll([axisPuyo, subPuyo]);
  }

  // ゲームオーバー判定
  bool _isGameOver() {
    const batsuOffset1 = Offset(2, 0);
    const batsuOffset2 = Offset(3, 0);
    for (final fixPuyo in fixedPuyos) {
      if (fixPuyo.offset == batsuOffset1 || fixPuyo.offset == batsuOffset2) {
        return true;
      }
    }
    return false;
  }

  // ゲーム終了時に呼ぶ
  void _endGame() {
    isPlaying = false;
    fallingPairPuyo = null;
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

  // 左回転
  void rotateLeft() {
    _tyrRotate(isCW: false);
    return;
  }

  // 右回転
  void rotateRight() {
    _tyrRotate(isCW: true);
    return;
  }

  // ぷよを回転させてみてダメなら戻す関数
  void _tyrRotate({required bool isCW}) {
    final orginFallingPairPuyo = fallingPairPuyo!.copyWith();
    fallingPairPuyo = fallingPairPuyo!.rotate(isCW);
    if (_hasCollision()) {
      fallingPairPuyo = orginFallingPairPuyo.copyWith();
      return;
    }
    notifyListeners();
  }

  // ドラッグしたら呼ばれる
  void drag(DragUpdateDetails details) {
    // 方向転換したら蓄積したドラッグはリセットする
    if (cumulativeDx == 0 && details.delta.dx.sign != cumulativeDx.sign) {
      cumulativeDx = 0;
    }

    // ドラッグ距離を蓄積する
    cumulativeDx += details.delta.dx;

    // 蓄積したドラッグ距離が閾値を超えたら移動
    if (cumulativeDx > moveThresholdDx) {
      _moveRight();
      cumulativeDx = 0;
    } else if (cumulativeDx < -moveThresholdDx) {
      _moveLeft();
      cumulativeDx = 0;
    }
  }

  // 左移動
  void _moveLeft() {
    _tryMoveTo(dx: -1);
    return;
  }

  // 右移動
  void _moveRight() {
    _tryMoveTo(dx: 1);
    return;
  }

  // ぷよを動かしてみてダメなら戻す関数
  void _tryMoveTo({double dx = 0, double dy = 0}) {
    final orginFallingPairPuyo = fallingPairPuyo!.copyWith();
    fallingPairPuyo = fallingPairPuyo!.moveTo(dx: dx, dy: dy);
    if (_hasCollision()) {
      fallingPairPuyo = orginFallingPairPuyo.copyWith();
      return;
    }
    notifyListeners();
  }

  // 指を離したとき
  void resetDrag() => cumulativeDx = 0;
}
