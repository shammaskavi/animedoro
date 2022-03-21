import 'dart:async';

import 'package:animedoro/utils/constants.dart';
import 'package:animedoro/widgets/custom_button.dart';
import 'package:animedoro/widgets/progresss_icon.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:animedoro/model/animedoro_status.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => HomeState();
}

const _btnTextStart = 'START ANIMEDORO';
const _btnTextResumeAnimedoro = 'RESUME ANIMEDORO';
const _btnTextResumeBreak = 'RESUME BREAK';
const _btnTextStartShortBreak = 'TAKE SHORT BREAK';
const _btnTextStartLongBreak = 'TAKE SHORT BREAK';
const _btnTextStartNewSet = 'START NEW SET';
const _btnTextPause = 'PAUSE';
const _btnTextReset = 'RESET';

class HomeState extends State<Home> {
  static AudioCache player = AudioCache();
  int remainingTime = animedoroTotalTime;
  String mainBtnText = _btnTextStart;
  AnimeDoroStatus animeDoroStatus = AnimeDoroStatus.pausedDoro;
  Timer? _timer;
  int animedoroNum = 0;
  int setNum = 0;

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    player.load('bell.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Number of AnimeDoro: $animedoroNum',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
              Text(
                'Set: $setNum',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 150,
                      lineWidth: 15.0,
                      percent: _getAnimedoroPercentage(),
                      progressColor: statusColor[animeDoroStatus],
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text(
                        _secondsToFormatedString(remainingTime),
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ProgressIcons(
                      total: animedoriPerSet,
                      done: animedoroNum - (setNum * animedoriPerSet),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "'${statusDesc[animeDoroStatus].toString()}'",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      onTap: _mainButtonPressed,
                      text: mainBtnText,
                    ),
                    CustomButton(
                      onTap: _resetButtonPressed,
                      text: _btnTextReset,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _secondsToFormatedString(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remainingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormated;
    if (remainingSeconds < 10) {
      remainingSecondsFormated = '0$remainingSeconds';
    } else {
      remainingSecondsFormated = remainingSeconds.toString();
    }

    return '$roundedMinutes:$remainingSecondsFormated';
  }

  _getAnimedoroPercentage() {
    int totalTime;
    switch (animeDoroStatus) {
      case AnimeDoroStatus.runningDoro:
        totalTime = animedoroTotalTime;
        break;
      case AnimeDoroStatus.pausedDoro:
        totalTime = animedoroTotalTime;
        break;
      case AnimeDoroStatus.runningShortBreak:
        totalTime = shortBreakTime;
        break;
      case AnimeDoroStatus.pausedShortBreak:
        totalTime = shortBreakTime;
        break;
      case AnimeDoroStatus.runningLongBreak:
        totalTime = longBreakTime;
        break;
      case AnimeDoroStatus.pausedLongBreak:
        totalTime = longBreakTime;
        break;
      case AnimeDoroStatus.setFinished:
        totalTime = animedoroTotalTime;
        break;
    }

    double percentage = (totalTime - remainingTime) / totalTime;
    return percentage;
  }

  _mainButtonPressed() {
    switch (animeDoroStatus) {
      case AnimeDoroStatus.pausedDoro:
        _startAnimedoroCountdown();
        break;
      case AnimeDoroStatus.runningDoro:
        _pauseAnimedoroCountdown();
        break;
      case AnimeDoroStatus.runningShortBreak:
        _pauseShortBreakCountdown();
        break;
      case AnimeDoroStatus.pausedShortBreak:
        _startShortBreak();
        break;
      case AnimeDoroStatus.runningLongBreak:
        _pauseLongBreakCountdown();
        break;
      case AnimeDoroStatus.pausedLongBreak:
        _startLongBreak();
        break;
      case AnimeDoroStatus.setFinished:
        setNum++;
        _startAnimedoroCountdown();
        break;
    }
  }

  _startAnimedoroCountdown() {
    animeDoroStatus = AnimeDoroStatus.runningDoro;

    _cancelTimer();

    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                    mainBtnText = _btnTextPause;
                  })
                }
              else
                {
                  _playSound(),
                  animedoroNum++,
                  _cancelTimer(),
                  if (animedoroNum % animedoriPerSet == 0)
                    {
                      animeDoroStatus = AnimeDoroStatus.pausedLongBreak,
                      setState(() {
                        remainingTime = longBreakTime;
                        mainBtnText = _btnTextStartLongBreak;
                      }),
                    }
                  else
                    {
                      animeDoroStatus = AnimeDoroStatus.pausedShortBreak,
                      setState(() {
                        remainingTime = shortBreakTime;
                        mainBtnText = _btnTextStartShortBreak;
                      }),
                    }
                }
            });
  }

  _startShortBreak() {
    animeDoroStatus = AnimeDoroStatus.runningShortBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                  }),
                }
              else
                {
                  _playSound(),
                  remainingTime = animedoroTotalTime,
                  _cancelTimer(),
                  animeDoroStatus = AnimeDoroStatus.pausedDoro,
                  setState(() {
                    mainBtnText = _btnTextStart;
                  }),
                }
            });
  }

  _startLongBreak() {
    animeDoroStatus = AnimeDoroStatus.runningLongBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                  }),
                }
              else
                {
                  _playSound(),
                  remainingTime = animedoroTotalTime,
                  _cancelTimer(),
                  animeDoroStatus = AnimeDoroStatus.setFinished,
                  setState(() {
                    mainBtnText = _btnTextStartNewSet;
                  }),
                }
            });
  }

  _pauseAnimedoroCountdown() {
    animeDoroStatus = AnimeDoroStatus.pausedDoro;
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumeAnimedoro;
    });
  }

  _resetButtonPressed() {
    animedoroNum = 0;
    setNum = 0;
    _cancelTimer();
    _stopCountDown();
  }

  _stopCountDown() {
    animeDoroStatus = AnimeDoroStatus.pausedDoro;
    setState(() {
      mainBtnText = _btnTextStart;
      remainingTime = animedoroTotalTime;
    });
  }

  _pauseShortBreakCountdown() {
    animeDoroStatus = AnimeDoroStatus.pausedShortBreak;
    _pausedBreakCountdown();
  }

  _pauseLongBreakCountdown() {
    animeDoroStatus = AnimeDoroStatus.pausedLongBreak;
    _pausedBreakCountdown();
  }

  _pausedBreakCountdown() {
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumeBreak;
    });
  }

  _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  _playSound() {
    player.play('bell.mp3');
  }
}
