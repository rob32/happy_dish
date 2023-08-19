import 'dart:math';
import 'package:happy_dish/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'my_dishes.g.dart';

// use List<FoodItem> instead of List<String>... (e.g. with "vegetarian bool")
@Riverpod(keepAlive: true)
class MyDishes extends _$MyDishes {
  late SharedPreferences prefs;
  @override
  List<String> build() {
    prefs = ref.watch(sharedPrefsProvider);
    final dishes = _loadFromPreferences();
    return [...dishes];
  }

  void addDish(String name) {
    state = [...state, name];
    _saveToPreferences(state);
  }

  void removeDish(String name) {
    state.remove(name);
    _saveToPreferences(state);
  }

  String getRandomDish() {
    if (state.isEmpty) {
      return "Diet?!";
    }
    return state[Random().nextInt(state.length)];
  }

  void clearList() {
    state = [];
    prefs.remove('my_dishes');
  }

  Future<void> _saveToPreferences(List<String> stringList) async {
    await prefs.setStringList('my_dishes', stringList);
  }

  List<String> _loadFromPreferences() {
    final savedDishes = prefs.getStringList('my_dishes') ?? [];
    return savedDishes;
  }
}
