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
      child: Align(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AnimatedTextKit(
            isRepeatingAnimation: false,
            repeatForever: false,
            animatedTexts: [
              ScaleAnimatedText(
                'Yummy',
                textStyle: const TextStyle(
                  fontFamily: "KaushanScript",
                  fontSize: 38,
                ),
              ),
              RotateAnimatedText(
                randomDish,
                rotateOut: false,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
            onFinished: () {
              if (randomDish == "Diet?!") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    content: Center(
                      child: Text(
                        'Nothing found. Please add dishes first',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                    ),
                    duration: const Duration(milliseconds: 2000),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
