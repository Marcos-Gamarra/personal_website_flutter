import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  SystemMouseCursor cursor = SystemMouseCursors.basic;
  
  void setCursorToClick(PointerEvent details) {
    setState(() {
      cursor = SystemMouseCursors.click;
    });
  }

  setCursorToBasic() {
    setState(() {
      cursor = SystemMouseCursors.basic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            html.window
                .open('https://github.com/marcos-gamarra', 'new tab');
          },
          child: MouseRegion(
            cursor: cursor,
            onEnter: setCursorToClick,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[300],
                ),
                children: const [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.top,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child:
                          FaIcon(FontAwesomeIcons.github, color: Colors.white),
                    ),
                  ),
                  TextSpan(
                    text: "github.com/marcos-gamarra",
                  ),
                ],
              ),
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[300],
            ),
            children: const [
              WidgetSpan(
                alignment: PlaceholderAlignment.bottom,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Icon(
                    Icons.email,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
              TextSpan(
                text: "marcosgamarralopez@gmail.com",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
