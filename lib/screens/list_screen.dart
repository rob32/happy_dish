import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/food_items.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> names = ref.watch(foodItemsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe to delete'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            tooltip: "Clear all",
            onPressed: () {
              ref.read(foodItemsProvider.notifier).clearList();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          for (final name in names)
            Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                ref.read(foodItemsProvider.notifier).removeFoodItemName(name);
              },
              child: Card(
                child: ListTile(
                  title: Text(name),
                ),
              ),
            )
        ],
      ),
    );
  }
}
