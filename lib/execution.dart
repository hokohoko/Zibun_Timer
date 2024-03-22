import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';

class ExecutionPage extends StatefulWidget {
  @override
  _ExecutionPageState createState() => _ExecutionPageState();
}

class _ExecutionPageState extends State<ExecutionPage> {
  int maxSeconds = 5;
  int seconds = 5;
  Timer? idealTimer;
  Timer? realTimer;
  String task = '';
  List<String> tasks = ['ベッドメイキング', '洗顔', '朝食', '歯磨き'];
  int count = 0;
  List<Map<String, dynamic>> taskList = [
    {"name": "ベッドメイク", "idealTime": 60, "realTime": 0},
    {"name": "洗顔", "idealTime": 63, "realTime": 0},
    {"name": "朝食", "idealTime": 30, "realTime": 0},
    {"name": "歯磨き", "idealTime": 3, "realTime": 0},
  ];
  int realTime = 0;
  TextEditingController timeController = TextEditingController(); // 時間入力
  int displayMinutes = 0;
  int displaySeconds = 0;

  _ExecutionPageState() {
    task = taskList[count]["name"];
    maxSeconds = taskList[count]["idealTime"];
    seconds = taskList[count]["idealTime"];
    displayMinutes = taskList[count]["idealTime"] ~/ 60;
    displaySeconds = (taskList[count]["idealTime"] % 60 == 0)
        ? 00
        : taskList[count]["idealTime"] % 60;
    print('$displayMinutes : $displaySeconds init');
  }

  void startTimer({bool reset = true}) {
    print(task + 'をスタート');
    if (reset) {
      resetRealTimer();
      resetIdealTimer();
    }

    idealTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
        setState(() => displayMinutes = seconds ~/ 60);
        setState(() => displaySeconds = seconds % 60);
      } else {
        stopTimer(reset: false);
        // seconds = maxSeconds;
      }
    });

    realTimer = Timer.periodic(Duration(seconds: 1), (_) {
      realTime++;
      // setState(() => realTime--);
    });
  }

  void resetRealTimer() => setState(() => seconds = maxSeconds);

  void resetIdealTimer() {
    realTime = 0;
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetRealTimer();
    }
    setState(() => idealTimer?.cancel());
  }

  void setPrams() {
    task = taskList[count]["name"];
    maxSeconds = taskList[count]["idealTime"];
    seconds = taskList[count]["idealTime"];
  }

  void nextTask() {
    print(realTimer?.tick);
    taskList[count]["realTime"] = realTimer?.tick;
    realTimer?.cancel();
    idealTimer?.cancel();
    print(taskList);
    print(realTimer?.tick);

    count = count + 1;
    if (count == tasks.length) {
      count = 0;
    }
    setPrams();
    // task = tasks[count];
    resetRealTimer();
    if (count == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => NextScreen(
                  tasks: tasks,
                  taskList: taskList,
                )),
      );
    }
    // resetRealTimer();
    // resetIdealTimer();
    startTimer();
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
    final isRunning = idealTimer == null ? false : idealTimer!.isActive;
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
            resetRealTimer();
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
      width: 400,
      height: 400,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: 1 - seconds / maxSeconds,
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 14,
            backgroundColor:
                seconds > 2 ? Colors.greenAccent : Colors.redAccent,
          ),
          Center(
            child: buildTime(),
          )
        ],
      ));

  Widget buildTime() {
    return Text('$displayMinutes分 $displaySeconds秒',
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 60));
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

class NextScreen extends StatelessWidget {
  final List<String> tasks;
  final List<Map<String, dynamic>> taskList;

  NextScreen({
    required this.tasks,
    required this.taskList,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('朝のルーティン'),
        ),
        body: Container(
          width: double.infinity,
          color: Colors.lightBlue.shade100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('結果'),
                    Text('朝のルーティン'),
                  ],
                ),
              ),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    for (int i = 0; i < tasks.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${tasks[i]} 結果：${_formatTime(taskList[i]["idealTime"])} ：00 / ',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(width: 10),
                            DropdownButton<int>(
                              value: taskList[0]["idealTime"],
                              onChanged: (value) {},
                              items: _buildDropdownItems(),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      );
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    return minutes.toString().padLeft(2, '0');
  }

  List<DropdownMenuItem<int>> _buildDropdownItems() {
    return List.generate(
      60,
      (index) => DropdownMenuItem<int>(
        value: index,
        child: Text('$index ：00'),
      ),
    );
  }
}
