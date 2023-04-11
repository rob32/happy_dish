import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/food_items.dart';

class AddScreen extends ConsumerStatefulWidget {
  const AddScreen({super.key});

  @override
  ConsumerState<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends ConsumerState<AddScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add dish:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'One by one',
                  prefixIcon: Icon(Icons.fastfood),
                  border: OutlineInputBorder(),
                ),
                onEditingComplete: () => _addItem(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _addItem(BuildContext context) {
    String newDish = _controller.text.trim();
    List<String> foodItems = ref.watch(foodItemsProvider);

    if (newDish.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Center(
            child: Text(
              'Input cannot be empty',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
          duration: const Duration(milliseconds: 2000),
        ),
      );
      return;
    }

    if (newDish.length >= 25) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Center(
            child: Text(
              'The input must not exceed 25 characters',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
          duration: const Duration(milliseconds: 2000),
        ),
      );
      return;
    }

    if (foodItems.contains(newDish)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Center(
            child: Text(
              '$newDish already exists',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
          duration: const Duration(milliseconds: 2000),
        ),
      );
      return;
    }

    // FoodItem newFoodItem = FoodItem(newDish);
    ref.read(foodItemsProvider.notifier).addFoodItemName(newDish);
    _controller.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text('"$newDish" has been added.')),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }
}
