import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'networking.dart' as net;
import 'dialogs.dart';

class Wordle extends StatefulWidget {
  const Wordle({Key? key}) : super(key: key);

  @override
  State<Wordle> createState() => _WordleState();
}

class _WordleState extends State<Wordle> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isIgnoring = true;
  int currentRow = 0;
  var target = "hello";
  String? errorText;
  http.Client client = http.Client();

  List words = [
    List<String>.filled(5, ""),
    List<String>.filled(5, ""),
    List<String>.filled(5, ""),
    List<String>.filled(5, ""),
    List<String>.filled(5, ""),
  ];

  List colors = [
    List<Color>.filled(5, Colors.grey),
    List<Color>.filled(5, Colors.grey),
    List<Color>.filled(5, Colors.grey),
    List<Color>.filled(5, Colors.grey),
    List<Color>.filled(5, Colors.grey),
  ];

  Future<void> playGame() async {
    words = [
      List<String>.filled(5, ""),
      List<String>.filled(5, ""),
      List<String>.filled(5, ""),
      List<String>.filled(5, ""),
      List<String>.filled(5, ""),
    ];

    colors = [
      List<Color>.filled(5, Colors.grey),
      List<Color>.filled(5, Colors.grey),
      List<Color>.filled(5, Colors.grey),
      List<Color>.filled(5, Colors.grey),
      List<Color>.filled(5, Colors.grey),
    ];

    currentRow = 0;
    var word = "";
    try {
      word = await net.getTarget(client);
    } finally {
      setState(() {
        target = word;
        isIgnoring = false;
      });
      focusNode.requestFocus();
    }
  }

  void handleInput(input) {
    if (currentRow < 5) {
      for (var i = 0; i < words[currentRow].length; i++) {
        setState(() {
          if (i < input.length) {
            words[currentRow][i] = input[i];
          } else {
            words[currentRow][i] = "";
          }
        });
      }
    }
  }

  Future<void> handleSubmission(input) async {
    if (input.length < 5) {
      setState(() {
        errorText = "The word has 5 letters";
      });
      focusNode.requestFocus();
      return;
    } else {
      if (!await net.isValidGuess(client, input)) {
        setState(() {
          errorText = "$input is not a valid word";
        });
        focusNode.requestFocus();
        return;
      }
    }

    errorText = null;
    if (isGuessCorrect(input)) {
      setState(() {
        isIgnoring = true;
      });
      controller.clear();
      if (!mounted) return;
      playerWinDialog(context, playGame);
      return;
    }

    controller.clear();
    if (currentRow == 4) {
      setState(() {
        currentRow++;
        isIgnoring = true;
      });
      focusNode.unfocus();
      if (!mounted) return;
      playerLostDialog(context, playGame, target);
    }

    if (currentRow < 4) {
      setState(() {
        currentRow++;
      });
      focusNode.requestFocus();
    }
  }

  bool isGuessCorrect(String input) {
    for (var i = 0; i < target.length; i++) {
      if (target.contains(input[i])) {
        if (target[i] == input[i]) {
          colors[currentRow][i] = Colors.green;
        } else {
          colors[currentRow][i] = Colors.orange;
        }
      }
    }
    if (target == input) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double size = width > height ? height : width;
    return GestureDetector(
      onTap: () => focusNode.unfocus(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Wordle",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(
            width: size * 0.4,
            height: size * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                WordleRow(word: words[0], colors: colors[0]),
                WordleRow(word: words[1], colors: colors[1]),
                WordleRow(word: words[2], colors: colors[2]),
                WordleRow(word: words[3], colors: colors[3]),
                WordleRow(word: words[4], colors: colors[4]),
              ],
            ),
          ),
          SizedBox(
            width: size * 0.5,
            child: IgnorePointer(
              ignoring: isIgnoring,
              child: TextField(
                textAlign: TextAlign.center,
                focusNode: focusNode,
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(size * 0.05),
                  ),
                  errorText: errorText,
                ),
                maxLength: 5,
                onChanged: (input) {
                  handleInput(input);
                },
                onSubmitted: (input) {
                  handleSubmission(input);
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              playGame();
            },
            child: const Text("Play Game"),
          ),
        ],
      ),
    );
  }
}

class WordleRow extends StatefulWidget {
  const WordleRow({Key? key, required this.word, required this.colors})
      : super(key: key);

  final List<Color> colors;
  final List<String> word;

  @override
  State<WordleRow> createState() => _WordleRowState();
}

class _WordleRowState extends State<WordleRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        LetterBox(letter: widget.word[0], color: widget.colors[0]),
        LetterBox(letter: widget.word[1], color: widget.colors[1]),
        LetterBox(letter: widget.word[2], color: widget.colors[2]),
        LetterBox(letter: widget.word[3], color: widget.colors[3]),
        LetterBox(letter: widget.word[4], color: widget.colors[4]),
      ],
    );
  }
}

class LetterBox extends StatefulWidget {
  const LetterBox({Key? key, this.letter = "", this.color = Colors.grey})
      : super(key: key);

  final Color color;
  final String letter;

  @override
  State<LetterBox> createState() => _LetterBoxState();
}

class _LetterBoxState extends State<LetterBox> {
  @override
  Widget build(BuildContext context) {
    double size =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width;
    return Container(
      color: widget.color,
      width: size * 0.06,
      height: size * 0.06,
      child: Center(
        child: Text(
          widget.letter,
          style: TextStyle(
            fontSize: size * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
