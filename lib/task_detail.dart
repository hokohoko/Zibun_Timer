import 'package:flutter/material.dart';
import './execution.dart';

class ToDoListDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('タスク詳細')),
      body: Column(children: <Widget>[
        Card(
          child: ListTile(
            title: Text('ベッドメイキング 1分'),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('洗顔 10分'),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('朝食 20分'),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('歯磨き 5分'),
          ),
        ),
        ButtonWidget(
          text: 'スタート',
          onClicked: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ExecutionPage(),
              ),
            );
          },
        ),
      ]),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     //nothing
      //   },
      //   child: Icon(Icons.add)
      // )
    );
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
