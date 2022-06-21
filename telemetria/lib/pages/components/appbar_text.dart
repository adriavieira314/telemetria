import 'package:flutter/material.dart';

class AppBarText extends StatelessWidget {
  final String text;
  const AppBarText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: FittedBox(
        child: Text(
          text,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
