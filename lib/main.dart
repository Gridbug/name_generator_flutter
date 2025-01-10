import 'package:flutter/material.dart';
import 'package:flutter_application_1/generator_page.dart';
import 'package:flutter_application_1/my_favorites_page.dart';
import 'package:flutter_application_1/wordpair_generator_state.dart';
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
      create: (context) => WordPairGeneratorState(),
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

    currentPage = AnimatedSwitcher(
      // offset: Offset(1.0, 0),
      duration: Duration(milliseconds: 300),
      child: currentPage,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final showNavRail = constraints.maxWidth > 450;

        if (showNavRail) {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth > 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(GeneratorPage.icon),
                        label: Text(GeneratorPage.name),
                      ),
                      NavigationRailDestination(
                        icon: Icon(MyFavoritesPage.icon),
                        label: Text(MyFavoritesPage.name),
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
                elevation: 0,
                currentIndex: selectedPageId,
                items: [
                  BottomNavigationBarItem(
                    label: GeneratorPage.name,
                    icon: Icon(GeneratorPage.icon),
                  ),
                  BottomNavigationBarItem(
                    label: MyFavoritesPage.name,
                    icon: Icon(MyFavoritesPage.icon),
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
