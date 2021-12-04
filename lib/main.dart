import 'package:flutter/material.dart';
import 'package:flutter_puyopuyo/screen/game_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_puyopuyo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: GamePage.routeName,
      routes: {
        GamePage.routeName: (_) => const GamePage(),
      },
    );
  }
}
