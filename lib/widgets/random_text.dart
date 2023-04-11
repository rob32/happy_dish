import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../providers/food_items.dart';

class RandomText extends ConsumerWidget {
  const RandomText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String randomDish =
        ref.watch(foodItemsProvider.notifier).getRandomFoodItemName();
    return SizedBox(
      height: 120,
      child: AnimatedTextKit(
        isRepeatingAnimation: false,
        repeatForever: false,
        animatedTexts: [
          ScaleAnimatedText(
            'Hmmmm yummy',
            textStyle: const TextStyle(
              fontFamily: "KaushanScript",
              fontSize: 40,
            ),
          ),
          RotateAnimatedText(
            randomDish,
            rotateOut: false,
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
        onFinished: () {
          if (randomDish == "Diet?!") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(
                    child: Text('No dishes were found. '
                        'Please add some to the list first.')),
                duration: Duration(milliseconds: 2500),
              ),
            );
          }
        },
      ),
    );
  }
}
