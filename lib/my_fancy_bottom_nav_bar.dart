import 'package:flutter/material.dart';

class MyFancyBottomNavBar extends StatelessWidget {
  final int currentId;

  MyFancyBottomNavBar({
    super.key,
    required this.currentId,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (itemId) {
        if (itemId == 0) {
          Navigator.of(context).popAndPushNamed('name_generator');
        } else {
          Navigator.of(context).popAndPushNamed('favorites');
        }
      },
      currentIndex: currentId,
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
    );
  }
}
