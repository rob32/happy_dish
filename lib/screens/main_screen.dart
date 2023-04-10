import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_screen.dart';
import 'home_screen.dart';
import 'list_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int index = 0;
  final screens = [
    const HomeScreen(),
    const AddScreen(),
    const ListScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (index) {
          setState(() {
            this.index = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.tips_and_updates_outlined),
            selectedIcon: Icon(Icons.tips_and_updates),
            label: "Play",
          ),
          NavigationDestination(
            icon: Icon(Icons.playlist_add_outlined),
            selectedIcon: Icon(Icons.playlist_add),
            label: "Add",
          ),
          NavigationDestination(
            icon: Icon(Icons.playlist_remove_outlined),
            selectedIcon: Icon(Icons.playlist_remove),
            label: "Remove",
          ),
        ],
      ),
    );
  }
}
