import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final List<Map<String, dynamic>> taskList;

  ResultPage({required this.taskList});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late List<String> _selectedTimes;
  late List<int> _selectedIndexes;

  @override
  void initState() {
    super.initState();
    _selectedTimes = List.generate(widget.taskList.length, (index) => _formatTime(widget.taskList[index]["idealTime"]));
    _selectedIndexes = List.generate(widget.taskList.length, (index) => 0);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        '朝のルーティン　結果画面',
        style: TextStyle(fontSize: 20),
      ),
    ),
    body: Container(
      width: double.infinity,
      color: Colors.lightBlue.shade100,
      child: ListView.builder(
        itemCount: widget.taskList.length,
        itemBuilder: (context, index) {
          bool isOnSchedule = widget.taskList[index]["realTime"] <= widget.taskList[index]["idealTime"];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'タスク名: ${widget.taskList[index]["name"]}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isOnSchedule ? Colors.red : Colors.black),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '経過時間: ${_formatTime(widget.taskList[index]["realTime"])}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _selectedTimes[index],
                      onChanged: (value) {
                        setState(() {
                          _selectedTimes[index] = value!;
                          _selectedIndexes[index] =
                          _buildDropdownItems().indexWhere((item) => item.value == value);
                        });
                        int seconds = int.parse(value!.split(':')[0]) * 60 + int.parse(value.split(':')[1]);
                      },
                      items: _buildDropdownItems(),
                    ),
                  ],
                ),
                Divider(), 
              ],
            ),
          );
        },
      ),
    ),
  );

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return '$formattedMinutes:$formattedSeconds';
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return List.generate(
      24 * 60,
          (index) {
        int hour = index ~/ 60;
        int minute = index % 60;
        String formattedHour = hour.toString().padLeft(2, '0');
        String formattedMinute = minute.toString().padLeft(2, '0');
        return DropdownMenuItem<String>(
          value: '$formattedHour:$formattedMinute',
          child: Text('$formattedHour:$formattedMinute'),
        );
      },
    );
  }
}
