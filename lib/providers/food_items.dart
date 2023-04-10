import 'dart:math';
import 'package:happy_dish/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'food_items.g.dart';

// use List<FoodItem> instead of List<String>... (e.g. with "vegetarian bool")
@Riverpod(keepAlive: true)
class FoodItems extends _$FoodItems {
  late SharedPreferences prefs;
  @override
  List<String> build() {
    prefs = ref.watch(sharedPrefsProvider);
    final foodNames = _loadFromPreferences();
    return [...foodNames];
  }

  void addFoodItemName(String name) {
    state = [...state, name];
    _saveToPreferences(state);
  }

  void removeFoodItemName(String name) {
    state.remove(name);
    _saveToPreferences(state);
  }

  String getRandomFoodItemName() {
    if (state.isEmpty) {
      return "Diet?!";
    }
    return state[Random().nextInt(state.length)];
  }

  void clearList() {
    state = [];
    prefs.remove('names_list');
  }

  Future<void> _saveToPreferences(List<String> stringList) async {
    await prefs.setStringList('names_list', stringList);
  }

  List<String> _loadFromPreferences() {
    final savedNames = prefs.getStringList('names_list') ?? [];
    return savedNames;
  }
}
