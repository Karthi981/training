import 'package:flutter/material.dart';


class Chatbubble extends StatelessWidget {

  final String message;
  const Chatbubble({super.key,required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.red[200],
      ),
      child: Text(message,
        style:const TextStyle(fontSize: 16) ,),
    );
  }
}
