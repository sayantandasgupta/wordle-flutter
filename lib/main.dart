import 'package:flutter/material.dart';

import 'src/screens/wordle_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(backgroundColor: Colors.black),
      home: const WordleScreen(),
    );
  }
}
