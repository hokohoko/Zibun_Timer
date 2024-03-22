import 'package:flutter/material.dart';
import './task_detail.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'テンプレート選択画面（仮）です。'
        )
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('タスク詳細に遷移するよ'),
          onPressed: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ToDoListDetailPage(),
              ),
            ),
          },
        ),
      ),
    );
  }
}