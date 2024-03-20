import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';

class ExecutionPage extends StatefulWidget {
  int maxSeconds = 5;
  int seconds = 5;
  Timer? timer;
  String task = '';
  List<String> tasks = ['ベッドメイキング', '洗顔', '朝食', '歯磨き'];
  @override
  _ExecutionPageState createState() => _ExecutionPageState();
}

class _ExecutionPageState extends State<ExecutionPage> {
  //static const defaultSeconds = 10;
  int maxSeconds = 5;
  int seconds = 5;
  Timer? timer;
  String task = '';
  List<String> tasks = ['ベッドメイキング', '洗顔', '朝食', '歯磨き'];
  int count = 0;
  List<Map<String, dynamic>> taskList = [
    {"name": "ベッドメイク", "idealTime": 4, "realTime": 0},
    {"name": "洗顔", "idealTime": 5, "realTime": 0},
    {"name": "朝食", "idealTime": 6, "realTime": 0},
    {"name": "歯磨き", "idealTime": 3, "realTime": 0},
  ];
  int realTime = 0;

  _ExecutionPageState() {
    print('$count init');
    task = taskList[count]["name"];
    maxSeconds = taskList[count]["idealTime"];
    seconds = taskList[count]["idealTime"];
  }

  void startTimer({bool reset = true}) {
    print(task + 'をスタート');
    if (reset) {
      resetTimer();
    }
    // seconds: 1
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        stopTimer(reset: false);
        // seconds = maxSeconds;
      }
    });
  }

  void resetTimer() => setState(() => seconds = maxSeconds);

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    setState(() => timer?.cancel());
  }

  void setPrams() {
    task = taskList[count]["name"];
    maxSeconds = taskList[count]["idealTime"];
    seconds = taskList[count]["idealTime"];
  }

  void nextTask() {
    count = count + 1;
    if (count == tasks.length) {
      count = 0;
    }
    setPrams();
    // task = tasks[count];
    resetTimer();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(task),
      ),
      body: Container(
          width: double.infinity,
          color: Colors.lightBlue.shade100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTimer(),
              const SizedBox(height: 80),
              buildButtons()
            ],
          )));

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == 0;
    // final timeController = TextEditingController();

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ButtonWidget(
          text: isRunning ? '停止' : '再開',
          onClicked: () {
            if (isRunning) {
              stopTimer(reset: false);
            } else {
              startTimer(reset: false);
            }
          }),
      const SizedBox(width: 12),
      ButtonWidget(
          text: '初めから',
          onClicked: () {
            resetTimer();
          }),
      const SizedBox(width: 12),
      ButtonWidget(
        text: isRunning || isCompleted ? '完了' : 'スタート',
        onClicked: () {
          // maxSeconds = int.parse(timeController.text);
          isRunning || isCompleted ? nextTask() : startTimer();
        },
      ),
    ]);
  }

  Widget buildTimer() => SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: 1 - seconds / maxSeconds,
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 12,
            backgroundColor: Colors.greenAccent,
          ),
          Center(
            child: buildTime(),
          )
        ],
      ));

  Widget buildTime() {
    return Text('$seconds',
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 80));
  }
}

class ButtonWidget extends StatelessWidget {
  final color = Colors.white;

  final backgroundColor = Colors.black;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onClicked,
  });

  final String text;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onClicked,
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
        child: Text(text, style: TextStyle(fontSize: 20, color: color)),
      );
}
