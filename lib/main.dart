import 'package:flutter/material.dart';
import 'package:flutter_application_1/bold_name_widget.dart';
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
  List<WordPair> favoritePairs = [];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void addToFavorites(final WordPair newPair) {
    favoritePairs.add(newPair);
    notifyListeners();
  }

  void removeFromFavorites(final int id) {
    favoritePairs.removeAt(id);
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BoldNameWidget(name: appState.current),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next')),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (itemId) => {
          if (itemId == 0)
            {Navigator.of(context).popAndPushNamed('name_generator')}
          else
            {Navigator.of(context).popAndPushNamed('favorites')}
        },
        currentIndex: 0,
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

class MyFavoritesPage extends StatelessWidget {
  const MyFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          ...appState.favoritePairs.indexed.map((idAndWordpair) => TextButton(
                onPressed: () {},
                child: Text(idAndWordpair.$2.asLowerCase),
              )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (itemId) => {
          if (itemId == 0)
            {Navigator.of(context).popAndPushNamed('name_generator')}
          else
            {Navigator.of(context).popAndPushNamed('favorites')}
        },
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            label: "name_generator",
            icon: Icon(Icons.cyclone),
            activeIcon: Icon(
              Icons.cyclone,
              weight: theme.iconTheme.weight,
            ),
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
