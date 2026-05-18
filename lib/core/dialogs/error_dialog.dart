import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShowErrorDialog extends StatelessWidget {
  final String title;
  final String content;

  const ShowErrorDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Ok"),
        ),
      ],
    );
  }
}
