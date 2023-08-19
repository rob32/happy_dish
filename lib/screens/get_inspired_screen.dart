import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:happy_dish/constants/popular_dishes.dart';
import 'package:happy_dish/providers/inspired_dishes.dart';
import 'package:happy_dish/constants/help_text.dart';
import 'package:happy_dish/utils/dialog_utils.dart';

class GetInspiredScreen extends ConsumerStatefulWidget {
  const GetInspiredScreen({super.key});

  @override
  ConsumerState<GetInspiredScreen> createState() => _GetInspiredScreen();
}

class _GetInspiredScreen extends ConsumerState<GetInspiredScreen> {
  List<String> suggestedDishes = PopularDishes.internationalDishes;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> checkedDishes = ref.watch(inspiredDishesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Inspired'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark),
            tooltip: "Help",
            onPressed: () {
              DialogUtils.showHelpDialog(context, HelpText.getInspiredScreen);
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: suggestedDishes.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              suggestedDishes[index],
              style: TextStyle(
                color: checkedDishes.contains(suggestedDishes[index])
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onBackground,
              ),
            ),
            trailing: Switch(
              value: checkedDishes.contains(suggestedDishes[index]),
              onChanged: (value) {
                _audioPlayer.play(AssetSource('sounds/Click_Standard_05.wav'));
                _checkAvtiveDishes(context, suggestedDishes[index]);
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }

  void _checkAvtiveDishes(BuildContext context, String name) {
    List<String> activeDishes = ref.read(inspiredDishesProvider);
    if (!activeDishes.contains(name)) {
      ref.read(inspiredDishesProvider.notifier).addDish(name);
    } else {
      ref.read(inspiredDishesProvider.notifier).removeDish(name);
    }
  }
}
