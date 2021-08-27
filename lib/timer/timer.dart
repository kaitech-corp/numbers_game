import 'package:crushai/services/constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class GameTimer extends StatefulWidget {
  @override
  _GameTimerState createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  late Timer _timer;
  double _start = 10.0;

  void startTimer() {
    const oneMilliSec = const Duration(milliseconds: 500);
    _timer = new Timer.periodic(
      oneMilliSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
            onTap: startTimer,
            child: Text(
              'Start',
              style: TextStyle(color: Colors.black, fontSize: defaultFontSize),
            )),
        Text("$_start",style: TextStyle(color: Colors.black, fontSize: defaultFontSize)),
      ],
    );
  }
}
