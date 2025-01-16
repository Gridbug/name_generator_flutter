import 'package:flutter/material.dart';
import 'package:flutter_application_1/name_generation/generator_page/generator_page.dart';
import 'package:flutter_application_1/my_app_layout_widget.dart';
import 'package:flutter_application_1/name_generation/my_favorites_page/my_favorites_page.dart';
import 'package:flutter_application_1/name_generation/persistance_classes/fancy_name_repository_impl.dart';
import 'package:flutter_application_1/top_level_resources.dart';
import 'package:flutter_application_1/wordpair_generator_state.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const MyApp());

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final _fancyNamesRepo = FancyNameMemoryRepository();

final _appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/${GeneratorPage.routeName}',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MyAppLayoutWidget(child);
      },
      routes: [
        GoRoute(
          path: '/${GeneratorPage.routeName}',
          builder: (context, _) => GeneratorPage(),
          // routes: <RouteBase>[
          //   GoRoute(
          //     path: 'settings',
          //     builder: (BuildContext context, GoRouterState state) {
          //       return GeneratorSettingsScreen();
          //     },
          //   ),
          // ],
        ),
        GoRoute(
          path: '/${MyFavoritesPage.routeName}',
          builder: (context, _) => MyFavoritesPage(),
          // routes: <RouteBase>[
          //   GoRoute(
          //     path: 'check_availability',
          //     builder: (BuildContext context, GoRouterState state) {
          //       return CheckAvailabilityScreen();
          //     },
          //   ),
          // ],
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WordPairGeneratorState(_fancyNamesRepo),
      child: MaterialApp.router(
        title: ResTopLevelStrings.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        routerConfig: _appRouter,
      ),
    );
  }
}
