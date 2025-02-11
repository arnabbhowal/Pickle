import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ScheduleResultPage extends StatelessWidget {
  final String scheduleText;

  const ScheduleResultPage({super.key, required this.scheduleText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Schedule')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Markdown(
          data: scheduleText,
          styleSheet: MarkdownStyleSheet(
            h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            h2: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
            p: TextStyle(fontSize: 16, color: Colors.grey[800]),
            listBullet: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ),
      ),
    );
  }
} 