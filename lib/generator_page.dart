import 'package:flutter/material.dart';
import 'package:flutter_application_1/bold_name_widget.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/wordpair_generator_state.dart';
import 'package:provider/provider.dart';

class GeneratorPage extends StatelessWidget {
  static const name = 'Generator';
  static const icon = Icons.cyclone;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<WordPairGeneratorState>();

    IconData favoriteButtonIcon = appState.isCurrentFavorite()
        ? Icons.favorite
        : Icons.favorite_border_outlined;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BoldNameWidget(name: appState.current),
          SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
              SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavoriteStatus();
                },
                icon: Icon(favoriteButtonIcon),
                label: Text('Like'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
