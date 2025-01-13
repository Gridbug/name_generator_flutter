import 'package:flutter/material.dart';
import 'package:flutter_application_1/generator_page/generator_page.dart';
import 'package:flutter_application_1/my_favorites_page/my_favorites_page.dart';
import 'package:flutter_application_1/top_level_resources.dart';
import 'package:flutter_application_1/wordpair_generator_state.dart';
import 'package:provider/provider.dart';

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
        title: ResTopLevelStrings.appName,
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
  int _selectedPageId = 0;

  final GlobalKey<NavigatorState> navigationBarNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // currentPage = AnimatedSwitcher(
    //   // offset: Offset(1.0, 0),
    //   duration: Duration(milliseconds: 300),
    //   child: currentPage,
    // );

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
                    selectedIndex: _selectedPageId,
                    onDestinationSelected: (navDestinationId) {
                      NavigatorState? navbarNavigatorState =
                          navigationBarNavigatorKey.currentState;

                      navbarNavigatorState
                          ?.popAndPushNamed(navDestinationId.toString());
                    },
                  ),
                ),
                _buildMediumOrWiderSizedBody(context),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: _buildCompactSizedBody(context),
            bottomNavigationBar: SafeArea(
              child: BottomNavigationBar(
                onTap: (itemId) {
                  NavigatorState? navbarNavigatorState =
                      navigationBarNavigatorKey.currentState;

                  navbarNavigatorState?.popAndPushNamed(itemId.toString());
                },
                elevation: 0,
                currentIndex: _selectedPageId,
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

  Widget _buildCompactSizedBody(BuildContext context) {
    return Navigator(
      key: navigationBarNavigatorKey,
      initialRoute: "0",
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) {
          return Center(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: settings.name == null
                  ? _buildSelectedPage(0)
                  : _buildSelectedPage(int.parse(settings.name!, radix: 10)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediumOrWiderSizedBody(BuildContext context) {
    return Navigator(
      key: navigationBarNavigatorKey,
      initialRoute: "0",
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) {
          return Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: settings.name == null
                  ? _buildSelectedPage(0)
                  : _buildSelectedPage(int.parse(settings.name!, radix: 10)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedPage(final int pageId) {
    switch (pageId) {
      case 0:
        return GeneratorPage();
      case 1:
        return MyFavoritesPage();
      default:
        throw UnimplementedError('no widget for $_selectedPageId');
    }
  }
}
