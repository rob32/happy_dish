import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:happy_dish/models/shopping_item.dart';
import 'package:happy_dish/providers/shopping_list.dart';
import 'package:happy_dish/constants/help_text.dart';
import 'package:happy_dish/utils/dialog_utils.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  bool isDialogOpen = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingItems = ref.watch(shoppingListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark),
            tooltip: "Help",
            onPressed: () {
              DialogUtils.showHelpDialog(context, HelpText.shoppingListScreen);
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: shoppingItems.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final item = shoppingItems[index];
          return Dismissible(
            key: Key(item.itemName),
            onDismissed: (direction) {
              ref.read(shoppingListProvider.notifier).removeItem(item);
              setState(() {});
            },
            child: ListTile(
              title: Text(
                item.itemName,
                style: TextStyle(
                  decoration: item.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: Checkbox(
                value: item.isDone,
                onChanged: (value) {
                  _audioPlayer
                      .play(AssetSource('sounds/Click_Standard_00.wav'));
                  ref.read(shoppingListProvider.notifier).toggleItem(item);
                  setState(() {/*/dirty rebuild*/});
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: Visibility(
        visible: !isDialogOpen,
        child: FloatingActionButton(
          onPressed: () => _openAddDishDialog(),
          child: const Icon(Icons.add),
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
          title: const Text('Add items:'),
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
    String newItem = _controller.text.trim();
    List<ShoppingItem> items = ref.watch(shoppingListProvider);

    if (newItem.isEmpty) {
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
    if (newItem.length >= 25) {
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
    if (items.any((item) => item.itemName == newItem)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Center(
            child: Text(
              '"$newItem" already exists',
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

    ref
        .read(shoppingListProvider.notifier)
        .addItem(ShoppingItem(itemName: newItem));
    _controller.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Center(
          child: Text(
            '"$newItem" has been added.',
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
