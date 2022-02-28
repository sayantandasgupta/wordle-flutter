import 'package:flutter/material.dart';

import '../models/letter_model.dart';

const _buttons = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'DEL'],
];

class Keyboard extends StatelessWidget {
  const Keyboard({
    Key? key,
    required this.onKeyTapped,
    required this.onDeleteTapped,
    required this.onEnterTapped,
    required this.letters,
  }) : super(key: key);

  final void Function(String) onKeyTapped;

  final VoidCallback onDeleteTapped;

  final VoidCallback onEnterTapped;

  final Set<Letter> letters;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buttons
          .map(
            (keyRow) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: keyRow.map((letter) {
                if (letter == 'DEL') {
                  return _KeyboardButton(
                    onTap: onDeleteTapped,
                    backgroundColor: Colors.grey,
                    letter: letter,
                  );
                } else if (letter == 'ENTER') {
                  return _KeyboardButton(
                    onTap: onEnterTapped,
                    backgroundColor: Colors.grey,
                    letter: letter,
                  );
                }

                final letterKey = letters.firstWhere(
                  (element) => element.letter == letter,
                  orElse: () => Letter.empty(),
                );

                return _KeyboardButton(
                  onTap: () => onKeyTapped(letter),
                  backgroundColor: letterKey != Letter.empty()
                      ? letterKey.backgroundColor
                      : Colors.grey,
                  letter: letter,
                );
              }).toList(),
            ),
          )
          .toList(),
    );
  }
}

class _KeyboardButton extends StatelessWidget {
  const _KeyboardButton({
    Key? key,
    this.height = 48,
    this.width = 32,
    required this.onTap,
    required this.backgroundColor,
    required this.letter,
  }) : super(key: key);

  final double height;
  final double width;
  final VoidCallback onTap;
  final Color backgroundColor;
  final String letter;

  factory _KeyboardButton.enter({required VoidCallback onTap}) =>
      _KeyboardButton(
        width: 60,
        onTap: onTap,
        backgroundColor: Colors.grey,
        letter: 'ENTER',
      );
  factory _KeyboardButton.delete({required VoidCallback onTap}) =>
      _KeyboardButton(
        width: 56,
        onTap: onTap,
        backgroundColor: Colors.grey,
        letter: 'DEL',
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
        horizontal: 2.0,
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
