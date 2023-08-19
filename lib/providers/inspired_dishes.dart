import 'package:happy_dish/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'inspired_dishes.g.dart';

@Riverpod(keepAlive: true)
class InspiredDishes extends _$InspiredDishes {
  late SharedPreferences prefs;
  @override
  List<String> build() {
    prefs = ref.watch(sharedPrefsProvider);
    final activeDishes = _loadFromPreferences();
    return [...activeDishes];
  }

  void addDish(String name) {
    state = [...state, name];
    _saveToPreferences(state);
  }

  void removeDish(String name) {
    state.remove(name);
    _saveToPreferences(state);
  }

  Future<void> _saveToPreferences(List<String> stringList) async {
    await prefs.setStringList('inspired_active_dishes', stringList);
  }

  List<String> _loadFromPreferences() {
    final savedActiveDishes =
        prefs.getStringList('inspired_active_dishes') ?? [];
    return savedActiveDishes;
  }
}
