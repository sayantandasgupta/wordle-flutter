import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:wordle/src/data/word_list.dart';
import 'package:wordle/src/models/letter_model.dart';
import 'package:wordle/src/utils/colors.dart';
import 'package:wordle/src/widgets/board.dart';
import 'package:wordle/src/widgets/keyboard.dart';

import '../models/word_model.dart';

enum GameStatus { playing, submitted, win, lose }

class WordleScreen extends StatefulWidget {
  const WordleScreen({Key? key}) : super(key: key);

  @override
  _WordleScreenState createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  GameStatus _gameStatus = GameStatus.playing;

  List<Word> _board = List.generate(
    6,
    (_) => Word(
      letters: List.generate(
        5,
        (_) => Letter.empty(),
      ),
    ),
  );

  // Flip Cards
  final List<List<GlobalKey<FlipCardState>>> _flipCardKeys = List.generate(
    6,
    (_) => List.generate(
      5,
      (_) => GlobalKey<FlipCardState>(),
    ),
  );

  int _currentIndex = 0;

  Word? get _currentWord =>
      _currentIndex < _board.length ? _board[_currentIndex] : null;

  Word _solution =
      Word.fromString(words[Random().nextInt(words.length)].toUpperCase());

  final Set<Letter> _keyboardLetters = {};

  void _onKeyTapped(String letter) {
    if (_gameStatus == GameStatus.playing) {
      setState(() {
        _currentWord?.addLetter(letter);
      });
    }
  }

  void _onDeleteTapped() {
    if (_gameStatus == GameStatus.playing) {
      setState(() {
        _currentWord?.removeLetters();
      });
    }
  }

  Future<void> _onEnterTapped() async {
    if (_gameStatus == GameStatus.playing &&
        _currentWord != null &&
        !_currentWord!.letters.contains(Letter.empty())) {
      _gameStatus = GameStatus.submitted;

      for (var i = 0; i < _currentWord!.letters.length; i++) {
        final currentWordLetter = _currentWord!.letters[i];

        final solutionWordLetter = _solution.letters[i];

        setState(() {
          if (currentWordLetter == solutionWordLetter) {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.correct);
          } else if (_solution.letters.contains(currentWordLetter)) {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.inWord);
          } else {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.notInWord);
          }
        });

        final letter = _keyboardLetters.firstWhere(
            (element) => element.letter == currentWordLetter.letter,
            orElse: () => Letter.empty());

        if (letter.status != LetterStatus.correct) {
          _keyboardLetters.removeWhere(
              (element) => element.letter == currentWordLetter.letter);
          _keyboardLetters.add(_currentWord!.letters[i]);
        }

        await Future.delayed(
          Duration(milliseconds: 150),
          () => _flipCardKeys[_currentIndex][i].currentState?.toggleCard(),
        );
      }

      _checkWinOrLoss();
    }
  }

  void _checkWinOrLoss() {
    if (_currentWord!.wordString == _solution.wordString) {
      _gameStatus = GameStatus.win;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: correctLetterColor,
          content: const Text(
            'You Won!',
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'New Game',
            onPressed: _restart,
            textColor: Colors.white,
          ),
        ),
      );
    } else if (_currentIndex + 1 >= _board.length) {
      _gameStatus = GameStatus.lose;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: Colors.red,
          content: Text(
            'You lost! Solution: ${_solution.wordString}',
            style: const TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'New Game',
            onPressed: _restart,
            textColor: Colors.white,
          ),
        ),
      );
    } else {
      _gameStatus = GameStatus.playing;
    }

    _currentIndex += 1;
  }

  void _restart() {
    setState(
      () {
        _gameStatus = GameStatus.playing;
        _currentIndex = 0;
        _board
          ..clear()
          ..addAll(
            List.generate(
              6,
              (_) => Word(
                letters: List.generate(
                  5,
                  (_) => Letter.empty(),
                ),
              ),
            ),
          );
        _solution = Word.fromString(
            words[Random().nextInt(words.length)].toUpperCase());

        _keyboardLetters.clear();

        _flipCardKeys
          ..clear()
          ..addAll(
            List.generate(
              6,
              (_) => List.generate(
                5,
                (_) => GlobalKey<FlipCardState>(),
              ),
            ),
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'W O R D L E',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Board(board: _board, flipCardKeys: _flipCardKeys),
          const SizedBox(
            height: 80,
          ),
          Keyboard(
            onKeyTapped: _onKeyTapped,
            onDeleteTapped: _onDeleteTapped,
            onEnterTapped: _onEnterTapped,
            letters: _keyboardLetters,
          ),
        ],
      ),
    );
  }
}
