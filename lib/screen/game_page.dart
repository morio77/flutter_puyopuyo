import 'package:flutter/material.dart';
import 'package:flutter_puyopuyo/screen/game_model.dart';
import 'package:provider/provider.dart';

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
        ),
      ),
    );
  }
}
