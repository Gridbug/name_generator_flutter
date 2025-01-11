import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class BoldNameWidget extends StatelessWidget {
  BoldNameWidget({
    super.key,
    required this.name,
  });

  final WordPair name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final nameStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          name.asLowerCase,
          style: nameStyle,
          semanticsLabel: "${name.first} ${name.second}",
        ),
      ),
    );
  }
}
