import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "I'm a second year CS student at UPTP in Paraguay.\n",
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.grey[300],
            ),
            children: const <TextSpan>[
              TextSpan(text: "Currently learning web development."),
            ],
          ),
        ),
      ),
    );
  }
}
