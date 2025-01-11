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
        children: [
          Expanded(
            flex: 3,
            child: WordpairsHistoryListView(),
          ),
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
                  appState.toggleCurrentFavoriteStatus();
                },
                icon: Icon(favoriteButtonIcon),
                label: Text('Like'),
              ),
            ],
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}

class WordpairsHistoryListView extends StatefulWidget {
  const WordpairsHistoryListView({super.key});

  @override
  State<WordpairsHistoryListView> createState() =>
      _WordpairsHistoryListViewState();
}

class _WordpairsHistoryListViewState extends State<WordpairsHistoryListView> {
  static const Gradient _topMaskingGradient = LinearGradient(
      colors: [Colors.transparent, Colors.black],
      stops: [0.0, 0.5],
      begin: Alignment.center,
      end: Alignment.bottomCenter);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<WordPairGeneratorState>();

    return ShaderMask(
      shaderCallback: (bounds) => _topMaskingGradient.createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
          key: appState.historyListKey,
          reverse: true,
          padding: const EdgeInsets.only(top: 100),
          initialItemCount: appState.history.length,
          itemBuilder: (context, index, animation) {
            final pair = appState.history[index];

            return SizeTransition(
              sizeFactor: animation,
              child: Center(
                child: TextButton.icon(
                  onPressed: () {
                    appState.toggleHistoryPairFavoriteStatus(index);
                  },
                  icon: appState.isHistoryPairFavorite(index)
                      ? Icon(Icons.favorite)
                      : SizedBox(),
                  label: Text(
                    pair.asLowerCase,
                    semanticsLabel: pair.asPascalCase,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
