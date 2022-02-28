import 'package:equatable/equatable.dart';
import 'package:wordle/src/models/letter_model.dart';

class Word extends Equatable {
  const Word({required this.letters});

  final List<Letter> letters;

  factory Word.fromString(String word) =>
      Word(letters: word.split('').map((e) => Letter(letter: e)).toList());

  String get wordString => letters.map((e) => e.letter).join();

  void addLetter(String letter) {
    final currentIndex =
        letters.indexWhere((element) => element.letter.isEmpty);

    if (currentIndex != -1) {
      letters[currentIndex] = Letter(letter: letter);
    }
  }

  void removeLetters() {
    final currentIndex =
        letters.lastIndexWhere((element) => element.letter.isNotEmpty);

    if (currentIndex != -1) {
      letters[currentIndex] = Letter.empty();
    }
  }

  @override
  List<Object?> get props => [letters];
}
