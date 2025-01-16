import 'package:flutter/material.dart';
import 'package:flutter_application_1/name_generation/generator_page/generator_page.dart';
import 'package:flutter_application_1/name_generation/my_favorites_page/my_favorites_page.dart';
import 'package:go_router/go_router.dart';

class MyAppLayoutWidget extends StatefulWidget {
  final Widget child;

  static const routeName = "app";

  MyAppLayoutWidget(this.child);

  @override
  State<MyAppLayoutWidget> createState() => _MyAppLayoutWidgetState();
}

class _MyAppLayoutWidgetState extends State<MyAppLayoutWidget> {
  int _selectedPageId = 0;

  final GlobalKey<NavigatorState> navigationBarNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
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
                      setState(() {
                        _selectedPageId = navDestinationId;
                      });

                      _callRouter(context, navDestinationId);
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: widget.child,
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
                child: widget.child,
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: BottomNavigationBar(
                onTap: (itemId) {
                  setState(() {
                    _selectedPageId = itemId;
                  });

                  _callRouter(context, itemId);
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

  void _callRouter(BuildContext context, int selectedPageId) {
    switch (selectedPageId) {
      case 0:
        context.go("/${GeneratorPage.routeName}");
      case 1:
        context.go("/${MyFavoritesPage.routeName}");
      default:
        throw UnimplementedError('no widget for $selectedPageId');
    }
  }
}
