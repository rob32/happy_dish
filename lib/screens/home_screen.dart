import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:happy_dish/constants/help_text.dart';
import 'package:happy_dish/providers/inspired_dishes.dart';
import 'package:happy_dish/utils/dialog_utils.dart';
import 'package:happy_dish/providers/my_dishes.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _toggle = false;
  bool _showText = false;
  String _randomDish = "Diet?!";

  void _toggleText() {
    setState(() {
      _showText = false;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.info_outline_rounded),
          onPressed: () {
            _showAboutDialog(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark),
            onPressed: () {
              DialogUtils.showHelpDialog(context, HelpText.homeScreen);
            },
          ),
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Column(
            children: [
              Text(
                "What to eat?",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 33,
                ),
              ),
              Text(
                "Get a random dish:",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () async {
                  bool? hasVibrator = await Vibration.hasVibrator();
                  if (hasVibrator == true) {
                    Vibration.vibrate(duration: 128);
                  }
                  _audioPlayer.play(AssetSource('sounds/Mouth_08.wav'));
                  setState(() {
                    _toggle = !_toggle;
                    _showText = true;
                    _randomDish = _getRandomDish();
                  });
                },
                child: Image.asset("assets/images/home-illustration.png")
                    .animate(target: _toggle ? 1 : 0)
                    .shake(),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Push Me!",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontStyle: FontStyle.italic),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    color: const Color(0xFFEB9661),
                    duration: 1500.ms,
                    delay: 1500.ms,
                  )
                  .shakeX(
                    amount: 3,
                    duration: 300.ms,
                  )..then(delay: 3000.ms)
            ],
          ),
          Visibility(
            visible: _showText ? true : false,
            replacement: const SizedBox(
              height: 50,
            ),
            child: SizedBox(
              height: 50,
              child: Text(
                _randomDish,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              )
                  .animate(
                    onComplete: (controller) {
                      _toggleText();
                    },
                  )
                  .shimmer(duration: 1000.ms)
                  .fadeIn()
                  .tint(color: Theme.of(context).colorScheme.primary)
                  .then(delay: 1200.ms)
                  .rotate(duration: 500.ms)
                  .fadeOut(),
            ),
          )
        ],
      )),
    );
  }

  void _showAboutDialog(BuildContext context) {
    return showAboutDialog(
      context: context,
      applicationName: 'Happy Dish',
      applicationVersion: 'v2.0.0',
      applicationIcon: Image.asset(
        'assets/images/android12splash.png',
        width: 60,
      ),
      applicationLegalese: '©2023 rburkhardt',
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text('"Happy Dish" is free and open source software licensed '
            'under the GNU GPL v3. The App does not collect any '
            'personal information or data from its users. '
            'For more info, read our'),
        InkWell(
          onTap: () => launchUrl(Uri.parse(
              'https://github.com/rob32/happy_dish/blob/main/docs/privacy.md')),
          child: Text(
            'Privacy Policy',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        )
      ],
    );
  }

  String _getRandomDish() {
    List<String> myDishes = ref.read(myDishesProvider);
    List<String> inspiredDishes = ref.read(inspiredDishesProvider);
    List<String> mergedList = [...myDishes, ...inspiredDishes];

    if (mergedList.isNotEmpty) {
      String newRandomDish = mergedList[Random().nextInt(mergedList.length)];
      return newRandomDish;
    } else {
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
      return "Diet?!";
    }
  }
}
