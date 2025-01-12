import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/wordpair_generator_state.dart';
import 'package:provider/provider.dart';

class MyFavoritesPage extends StatelessWidget {
  static const name = 'Favorite names';
  static const icon = Icons.favorite;

  const MyFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<WordPairGeneratorState>();

    if (appState.favoritePairs.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return FavoritesListView(appState: appState);
  }
}

class FavoritesListView extends StatefulWidget {
  const FavoritesListView({
    super.key,
    required this.appState,
  });

  final WordPairGeneratorState appState;

  @override
  State<FavoritesListView> createState() => _FavoritesListViewState();
}

class _FavoritesListViewState extends State<FavoritesListView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var appState =
          Provider.of<WordPairGeneratorState>(context, listen: false);

      appState.removedItemBuilder = _buildRemovedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: widget.appState.favoritesListKey,
      reverse: true,
      initialItemCount: widget.appState.favoritePairs.length + 1,
      itemBuilder: (context, index, animation) {
        if (index == 0) {
          return SizedBox(height: 20);
        }
        index = index - 1;

        final WordPair p = widget.appState.favoritePairs[index];

        return Row(
          children: [
            Spacer(),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 20),
                  Text(
                    p.asLowerCase,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  IconButton(
                    onPressed: () {
                      widget.appState.removeFromFavorites(index);
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRemovedItem(
      WordPair item, BuildContext context, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Row(
        children: [
          Spacer(),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 20),
                Text(
                  item.asLowerCase,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
