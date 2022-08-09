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
  final TextEditingController _controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  // true = textfield is ignored, false = textfield is not ignored
  bool isIgnored = true;

  int currentRow =
      0; // row that is taking input. 0 = top row, 1 = second row, ... , 4 = bottom row
  var target = ""; // target word to be searched
  String? errorText;
  http.Client client = http.Client();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final String text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //rows in the grid, each containing a list of 5 letters
  List rows = [
    List<String>.filled(5, ""),
    List<String>.filled(5, ""),
    List<String>.filled(5, ""),
    List<String>.filled(5, ""),
    List<String>.filled(5, ""),
  ];

  //colors of the boxes in the grid
  List colors = [
    List<Color>.filled(5, Colors.grey),
    List<Color>.filled(5, Colors.grey),
    List<Color>.filled(5, Colors.grey),
    List<Color>.filled(5, Colors.grey),
    List<Color>.filled(5, Colors.grey),
  ];

  // clear grid and starts a new game
  Future<void> playGame() async {
    rows = [
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

    try {
      target = await net.getTarget(client);
    } finally {
      setState(() {
        isIgnored = false;
      });
      focusNode.requestFocus();
    }
  }

  //update grid when input is entered in textfield
  void handleInput(input) {
    if (currentRow < 5) {
      for (var i = 0; i < rows[currentRow].length; i++) {
        setState(() {
          if (i < input.length) {
            rows[currentRow][i] = input[i];
          } else {
            rows[currentRow][i] = "";
          }
        });
      }
    }
  }

  //check if input is in database, if so, update grid colors and go to next row, if not, show error
  Future<void> handleSubmission(input) async {
    //check if input is a 5 letter word
    if (input.length < 5) {
      setState(() {
        errorText = "The word has 5 letters";
      });
      focusNode.requestFocus();
      return;
      //check if input is in database
    } else {
      if (!await net.isValidGuess(client, input)) {
        setState(() {
          errorText = "$input is not a valid word";
        });
        focusNode.requestFocus();
        return;
      }
    }

    //check if input is the target word, if yes, show victory dialog
    errorText = null;
    if (isGuessCorrect(input)) {
      setState(() {
        isIgnored = true;
      });
      _controller.clear();
      if (!mounted) return;
      playerWinDialog(context, playGame);
      return;
    }

    //if currentRow is the last row, show defeat dialog
    _controller.clear();
    if (currentRow == 4) {
      setState(() {
        currentRow++;
        isIgnored = true;
      });
      focusNode.unfocus();
      if (!mounted) return;
      playerLostDialog(context, playGame, target);
    }

    //if currentRow is not the last row, go to next row
    if (currentRow < 4) {
      setState(() {
        currentRow++;
      });
      focusNode.requestFocus();
    }
  }

  //check if input is the target word, if yes, return true, else return false and paint boxes
  //according to the letters in the input
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
    return Column(
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
              WordleRow(word: rows[0], colors: colors[0]),
              WordleRow(word: rows[1], colors: colors[1]),
              WordleRow(word: rows[2], colors: colors[2]),
              WordleRow(word: rows[3], colors: colors[3]),
              WordleRow(word: rows[4], colors: colors[4]),
            ],
          ),
        ),
        SizedBox(
          width: size * 0.5,
          height: size * 0.08,
          child: Center(
            child: IgnorePointer(
              ignoring: isIgnored,
              child: TextField(
                textAlign: TextAlign.center,
                focusNode: focusNode,
                controller: _controller,
                decoration: InputDecoration(
                  counterStyle: TextStyle(
                    color: Colors.grey[300],
                  ),
                  suffixIcon: IconButton(
                    padding: const EdgeInsets.only(right: 15),
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      handleSubmission(_controller.text);
                    },
                  ),
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
        ),
        ElevatedButton(
          //disable button while currentRow is different than 0
          onPressed: playGame,
          //change label to restart when currentRow is different than 0
          child: currentRow == 0
              ? const Text("Play")
              : const Text("Start a new game"),
        ),
      ],
    );
  }
}

//row widget for the grid
//takes in a list of letters and a list of colors and builds a row of LetterBoxes with them
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

//letter box widget, takes in a letter and a color, and displays the letter in a box with the color
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
