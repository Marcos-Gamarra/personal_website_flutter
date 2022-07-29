import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key, required this.menuWidth}) : super(key: key);
  final double menuWidth;
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
        color: Color(0xffdcd9ff),
      ),
      width: widget.menuWidth,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
}
