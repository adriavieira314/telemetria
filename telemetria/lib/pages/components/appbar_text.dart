import 'package:flutter/material.dart';

class AppBarText extends StatelessWidget {
  final String text;
  const AppBarText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
  }
}
