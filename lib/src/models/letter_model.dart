import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wordle/src/utils/colors.dart';

enum LetterStatus { initial, inWord, notInWord, correct }

class Letter extends Equatable {
  const Letter({
    required this.letter,
    this.status = LetterStatus.initial,
  });

  final String letter;
  final LetterStatus status;

  factory Letter.empty() => const Letter(letter: '');

  Color get backgroundColor {
    switch (status) {
      case LetterStatus.initial:
        return Colors.transparent;
      case LetterStatus.inWord:
        return inWordButWrongPlaceLetterColor;
      case LetterStatus.notInWord:
        return notInWordLetterColor;
      case LetterStatus.correct:
        return correctLetterColor;
    }
  }

  Color get borderColor {
    switch (status) {
      case LetterStatus.initial:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  Letter copyWith({
    String? letter,
    LetterStatus? status,
  }) {
    return Letter(
      letter: letter ?? this.letter,
      status: status ?? this.status,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [letter, status];
}
