import 'package:flutter/material.dart';
import 'package:animedoro/model/animedoro_status.dart';

// Test case
const animedoroTotalTime = 5;
const shortBreakTime = 3;
const longBreakTime = 6;
const animedoriPerSet = 4;

// const animedoroTotalTime = 40 * 60;
// const shortBreakTime = 20 * 60;
// const longBreakTime = 25 * 60;
// const animedoriPerSet = 4;

const Map<AnimeDoroStatus, String> statusDesc = {
  AnimeDoroStatus.runningDoro: 'Animedoro is running, time to be focused',
  AnimeDoroStatus.pausedDoro: 'Ready for a focused yet fun Animedoro?',
  AnimeDoroStatus.runningShortBreak: 'Short break running, time to watch relax',
  AnimeDoroStatus.pausedShortBreak: "Let's watch anime, shall we?",
  AnimeDoroStatus.runningLongBreak:
      "Long break running, try a physical avtivity",
  AnimeDoroStatus.pausedLongBreak: "Let's go on a little run, shall we?",
  AnimeDoroStatus.setFinished: "You've earned an actual break, ready to start?",
};

const Map<AnimeDoroStatus, MaterialColor> statusColor = {
  AnimeDoroStatus.runningDoro: Colors.green,
  AnimeDoroStatus.pausedDoro: Colors.orange,
  AnimeDoroStatus.runningShortBreak: Colors.red,
  AnimeDoroStatus.pausedShortBreak: Colors.orange,
  AnimeDoroStatus.runningLongBreak: Colors.red,
  AnimeDoroStatus.pausedLongBreak: Colors.orange,
  AnimeDoroStatus.setFinished: Colors.orange,
};
