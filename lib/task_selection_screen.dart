import 'package:flutter/material.dart';
import 'task.dart'; // Taskクラスをインポート

class TaskSelectionScreen extends StatelessWidget {
  const TaskSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Task>> parentTasks = {
      '朝のルーティン': [
        Task('ベッドメイキング', timeInMinutes: 10),
        Task('洗顔', timeInMinutes: 5),
        Task('朝食', timeInMinutes: 20),
        Task('歯磨き', timeInMinutes: 3),
      ],
      '夜のルーティン': [
        Task('手洗いうがい', timeInMinutes: 5),
        Task('夜ご飯', timeInMinutes: 30),
        Task('お風呂', timeInMinutes: 15),
        Task('今日の振り返り', timeInMinutes: 10),
      ],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('タスクを選択'),
      ),
      body: ListView(
        children: parentTasks.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(entry.key,
                    style: Theme.of(context).textTheme.headline5),
              ),
              ...entry.value.map((task) {
                return ListTile(
                  title: Text(task.name),
                  subtitle: Text('時間: ${task.timeInMinutes}分'),
                  onTap: () {
                    // 親タスク名とその子タスクリストを返す
                    Navigator.pop(context, {
                      'parentTask': entry.key,
                      'childTasks': entry.value,
                    });
                  },
                );
              }).toList(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
