import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String? msg;
  const MessageDisplay({
    Key? key,
    required this.msg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: const Text(
        'Start Search',
        textAlign: TextAlign.center,
      ),
    );
  }
}
