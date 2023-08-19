import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happy_dish/screens/home_screen.dart';
import 'package:happy_dish/screens/my_dishes_screen.dart';
import 'package:happy_dish/screens/get_inspired_screen.dart';
import 'package:happy_dish/screens/shopping_list_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int index = 0;
  final screens = [
    const HomeScreen(),
    const MyDishesScreen(),
    const GetInspiredScreen(),
    const ShoppingListScreen(),
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
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        backgroundColor: const Color(0xFF14233A),
        elevation: 0,
        indicatorColor: Colors.transparent,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            selectedIcon: Icon(
              Icons.home_filled,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: "Home",
          ),
          NavigationDestination(
            icon: const Icon(Icons.fastfood_outlined),
            selectedIcon: Icon(
              Icons.fastfood,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: "My Dishes",
          ),
          NavigationDestination(
            icon: const Icon(Icons.tips_and_updates_outlined),
            selectedIcon: Icon(
              Icons.tips_and_updates,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: "Get Inspired",
          ),
          NavigationDestination(
            icon: const Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag,
                color: Theme.of(context).colorScheme.primary),
            label: "Shopping List",
          ),
        ],
      ),
    );
  }
}
