import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/play_button.dart';

class PlayIconButton extends ConsumerWidget {
  const PlayIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    bool isPressed = ref.watch(playButtonProvider);
    return IconButton(
      onPressed: () {
        ref.watch(playButtonProvider.notifier).toogleState();
      },
      icon: isPressed
          ? const Icon(Icons.refresh_outlined)
          : const Icon(Icons.play_arrow_rounded),
      iconSize: 62,
      style: IconButton.styleFrom(
        foregroundColor: colors.onPrimary,
        backgroundColor: colors.primary,
        disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
        hoverColor: colors.onPrimary.withOpacity(0.08),
        focusColor: colors.onPrimary.withOpacity(0.12),
        highlightColor: colors.onPrimary.withOpacity(0.12),
      ),
    );
  }
}
