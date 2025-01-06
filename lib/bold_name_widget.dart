import 'package:flutter/material.dart';

class BoldNameWidget extends StatelessWidget {
  BoldNameWidget({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.deepOrange,
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        name,
      ),
    );
  }
}
