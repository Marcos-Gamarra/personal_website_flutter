import 'package:flutter/material.dart';

Future<void> playerWinDialog(BuildContext context, Function() function) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Congrats. You win!'),
        actions: <Widget>[
          TextButton(
            child: const Text('Play Again'),
            onPressed: () {
              Navigator.of(context).pop();
              function();
            },
          ),
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

Future<void> playerLostDialog(BuildContext context, Function() function, String word) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Sorry. You lost. The word was $word'),
        actions: <Widget>[
          TextButton(
            child: const Text('Play Again'),
            onPressed: () {
              Navigator.of(context).pop();
              function();
            },
          ),
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}
