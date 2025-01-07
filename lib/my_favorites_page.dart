import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:provider/provider.dart';

class MyFavoritesPage extends StatelessWidget {
  static const name = 'Favorite names';
  static const icon = Icons.favorite;

  const MyFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favoritePairs.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return Align(
      alignment: Alignment.bottomRight,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          verticalDirection: VerticalDirection.up,
          children: [
            SizedBox(height: 20),
            ...appState.favoritePairs.indexed.map(
              (idAndWordpair) => Card(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 20),
                    Text(
                      idAndWordpair.$2.asLowerCase,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    IconButton(
                      onPressed: () {
                        appState.removeFromFavorites(idAndWordpair.$1);
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
