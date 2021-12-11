import 'dart:io';

import 'package:flutter/material.dart';

class GameModel extends ChangeNotifier {
  // 定数など
  static const int fieldWidth = 6;
  static const int fieldHeight = 13;

  // ゲームの状態値
  bool isPlaying = false;

  GameModel() {
    // いろんな初期化
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
