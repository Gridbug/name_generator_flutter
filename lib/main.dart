import 'package:flutter/material.dart';
import 'package:flutter_application_1/bold_name_widget.dart';
import 'package:flutter_application_1/my_fancy_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: SafeArea(
        child: MaterialApp(
          title: 'Namer App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            useMaterial3: true,
          ),
          home: MyHomePage(),
          routes: {
            "name_generator": (context) => MyHomePage(),
            "favorites": (context) => MyFavoritesPage(),
          },
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  WordPair current = WordPair.random();
  bool currentIsFavorite = false;

  List<WordPair> favoritePairs = [];

  void getNext() {
    current = WordPair.random();
    currentIsFavorite = false;
    notifyListeners();
  }

  void toggleFavoriteStatus() {
    if (currentIsFavorite) {
      favoritePairs.remove(current);
    } else {
      favoritePairs.add(current);
    }

    currentIsFavorite = !currentIsFavorite;

    notifyListeners();
  }

  bool isCurrentFavorite() {
    return currentIsFavorite;
  }

  void removeFromFavorites(final int id) {
    favoritePairs.removeAt(id);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPageId = 0;

  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    switch (selectedPageId) {
      case 0:
        currentPage = GeneratorPage();
        break;
      case 1:
        currentPage = MyFavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedPageId');
    }

    return Scaffold(
      body: Center(
        child: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: currentPage,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (itemId) {
          setState(() {
            selectedPageId = itemId;
          });
        },
        currentIndex: selectedPageId,
        items: [
          BottomNavigationBarItem(
            label: "name_generator",
            icon: Icon(Icons.cyclone),
          ),
          BottomNavigationBarItem(
            label: "favorites",
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

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
