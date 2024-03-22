import 'package:flutter/material.dart';
import 'task_selection_screen.dart';
import 'task.dart';
import 'executive_function.dart'; // executive_function.dart をインポート
import 'task_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'タスク選択アプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedParentTask;
  List<Task>? selectedChildTasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedParentTask != null) ...[
              Text('$selectedParentTask',
                  style: Theme.of(context).textTheme.headline5),
              if (selectedChildTasks != null) ...[
                ...selectedChildTasks!.map((task) {
                  return Column(
                    children: [
                      Text(task.name,
                          style: Theme.of(context).textTheme.subtitle1),
                      Text('時間: ${task.timeInMinutes}分',
                          style: Theme.of(context).textTheme.subtitle2),
                    ],
                  );
                }).toList(),
              ],
            ] else
              const Text('タスクが選択されていません'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TaskSelectionScreen()),
                    );

                    if (result != null) {
                      setState(() {
                        selectedParentTask = result['parentTask'];
                        selectedChildTasks = result['childTasks'];
                      });
                    }
                  },
                  child: const Text('タスクを選択する'),
                ),
                const SizedBox(width: 16), // 間隔を設ける
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ToDoListDetailPage()),
                    );
                  },
                  child: const Text('実行画面'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
