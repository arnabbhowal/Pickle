import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String message;
  final String subMessage;

  const LoadingScreen({
    super.key,
    this.message = 'Processing your request',
    this.subMessage = 'This may take a few moments',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              subMessage,
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.normal),
            ),
          ],
        ),
      ),
    );
  }
} 