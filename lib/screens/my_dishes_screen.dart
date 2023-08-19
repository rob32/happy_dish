import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happy_dish/constants/help_text.dart';
import 'package:happy_dish/utils/dialog_utils.dart';

import '../providers/my_dishes.dart';

class MyDishesScreen extends ConsumerStatefulWidget {
  const MyDishesScreen({super.key});

  @override
  ConsumerState<MyDishesScreen> createState() => _MyDishesScreen();
}

class _MyDishesScreen extends ConsumerState<MyDishesScreen> {
  bool isDialogOpen = false;

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> names = ref.watch(myDishesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dishes'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark),
            tooltip: "Help",
            onPressed: () {
              DialogUtils.showHelpDialog(context, HelpText.myDishesScreen);
            },
          ),
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return Dismissible(
              background: Container(color: const Color(0xFFEB9661)),
              key: UniqueKey(),
              onDismissed: (direction) {
                setState(() {/*/remove divider*/});
                ref.read(myDishesProvider.notifier).removeDish(names[index]);
              },
              child: ListTile(
                title: Text(names[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_forever),
                  tooltip: "Remove Dish",
                  onPressed: () {
                    ref
                        .read(myDishesProvider.notifier)
                        .removeDish(names[index]);
                    setState(() {});
                  },
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: names.length),
      floatingActionButton: Visibility(
        visible: !isDialogOpen,
        child: FloatingActionButton.extended(
          onPressed: () => _openAddDishDialog(),
          icon: const Icon(Icons.add),
          label: const Text('Add Dish'),
        ),
      ),
    );
  }

  void _openAddDishDialog() {
    setState(() {
      isDialogOpen = true;
    });
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new dish:'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                onEditingComplete: () => _addItem(context),
                decoration: const InputDecoration(
                  hintText: 'type here',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            FilledButton(
              onPressed: () {
                _addItem(context);
                // Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        isDialogOpen = false;
      });
    });
  }

  void _addItem(BuildContext context) {
    String newDish = _controller.text.trim();
    List<String> foodItems = ref.watch(myDishesProvider);

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
              '"$newDish" already exists',
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

    ref.read(myDishesProvider.notifier).addDish(newDish);
    _controller.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Center(
          child: Text(
            '"$newDish" has been added.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }
}
