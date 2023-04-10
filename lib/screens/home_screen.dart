import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/play_button.dart';
import '../widgets/play_icon_button.dart';
import '../widgets/random_text.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              _showAboutDialog(context);
            },
          )
        ],
      ),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "What to eat?",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: 15,
                ),
                const PlayIconButton(),
                Visibility(
                  visible: ref.watch(playButtonProvider),
                  replacement: const SizedBox(
                    height: 70,
                  ),
                  child: const RandomText(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    return showAboutDialog(
      context: context,
      applicationName: 'Happy Dish',
      applicationVersion: 'v1.0.0',
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
            'For more info, click on the following link:'),
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
}
