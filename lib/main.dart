import 'package:flutter/material.dart';
import 'package:flutter_application_1/bold_name_widget.dart';
import 'package:flutter_application_1/generator_page.dart';
import 'package:flutter_application_1/my_favorites_page.dart';
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
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: MyAppLayoutWidget(),
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

class MyAppLayoutWidget extends StatefulWidget {
  @override
  State<MyAppLayoutWidget> createState() => _MyAppLayoutWidgetState();
}

class _MyAppLayoutWidgetState extends State<MyAppLayoutWidget> {
  int selectedPageId = 0;

  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    switch (selectedPageId) {
      case 0:
        currentPage = GeneratorPage();
      case 1:
        currentPage = MyFavoritesPage();
      default:
        throw UnimplementedError('no widget for $selectedPageId');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final showNavRail = constraints.maxWidth >= 600;

        if (showNavRail) {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: true,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                    ],
                    selectedIndex: selectedPageId,
                    onDestinationSelected: (navDestinationId) {
                      setState(() {
                        selectedPageId = navDestinationId;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: currentPage,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: currentPage,
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: BottomNavigationBar(
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
            ),
          );
        }
      },
    );
  }
}
