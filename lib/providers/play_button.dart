import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'play_button.g.dart';

@riverpod
class PlayButton extends _$PlayButton {
  @override
  bool build() {
    return false;
  }

  void toogleState() {
    state = !state;
  }
}
