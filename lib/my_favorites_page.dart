import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:provider/provider.dart';

class MyFavoritesPage extends StatelessWidget {
  const MyFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        ...appState.favoritePairs.indexed.map((idAndWordpair) => TextButton(
              onPressed: () {},
              child: Text(idAndWordpair.$2.asLowerCase),
            )),
      ],
    );
  }
}
