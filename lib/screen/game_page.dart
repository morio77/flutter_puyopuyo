import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_model.dart';
import 'custom_painters/main_puyo_painter.dart';
import 'custom_painters/next_puyo_painter.dart';

class GamePage extends StatelessWidget {
  static const routeName = 'GamePageRoute';
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => GameModel(),
      child: Consumer<GameModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: const Text('flutterでぷよぷよ'),
          ),
          body: Center(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                // メインのフィールド
                CustomPaint(
                  painter:
                      MainPuyoPainter(model.fixedPuyos, model.fallingPairPuyo),
                  child: const SizedBox(
                    width: 300,
                    height: 550,
                  ),
                ),

                // ネクストのフィールド
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomPaint(
                      painter: NextPuyoPainter(model.nextPairPuyos),
                      child: const SizedBox(
                        width: 300,
                        height: 100,
                      ),
                    ),
                  ),
                ),

                // スタートボタン
                if (!model.isPlaying)
                  ElevatedButton(
                    onPressed: model.startGame,
                    child: const Text('スタート'),
                  ),
              ],
            ),
          ),
          // デバッグ用、左右ボタン
          floatingActionButton: SizedBox(
            width: 200,
            height: 50,
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: model.rotateLeft,
                  icon: Icon(Icons.arrow_left),
                  label: Container(),
                ),
                ElevatedButton.icon(
                  onPressed: model.rotateRight,
                  icon: Icon(Icons.arrow_right),
                  label: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
