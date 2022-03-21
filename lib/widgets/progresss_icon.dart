import 'package:flutter/material.dart';

class ProgressIcons extends StatelessWidget {
  final int total;
  final int done;

  // ignore: use_key_in_widget_constructors
  const ProgressIcons({required this.total, required this.done});

  @override
  Widget build(BuildContext context) {
    const double iconScale = 56;

    final doneIcon = Image.asset(
      'assets/done.png',
      width: iconScale,
      height: iconScale,
    );
    final notDoneIcon = Image.asset(
      'assets/notdone.png',
      width: iconScale,
      height: iconScale,
      color: Colors.white54,
    );

    List<Image> icons = [];

    for (int i = 0; i < total; i++) {
      if (i < done) {
        icons.add(doneIcon);
      } else {
        icons.add(notDoneIcon);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [...icons],
      ),
    );
  }
}


