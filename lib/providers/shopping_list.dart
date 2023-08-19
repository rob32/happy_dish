import 'dart:convert';

import 'package:happy_dish/providers/shared_prefs.dart';
import 'package:happy_dish/models/shopping_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shopping_list.g.dart';

@Riverpod(keepAlive: true)
class ShoppingList extends _$ShoppingList {
  late SharedPreferences prefs;

  @override
  List<ShoppingItem> build() {
    prefs = ref.watch(sharedPrefsProvider);
    final activeDishes = _loadFromPreferences();
    return [...activeDishes];
  }

  void addItem(ShoppingItem item) {
    state = [...state, item];
    _saveToPreferences(state);
  }

  void removeItem(ShoppingItem item) {
    state.remove(item);
    _saveToPreferences(state);
  }

  void toggleItem(ShoppingItem item) {
    final index = state.indexOf(item);
    if (index != -1) {
      state[index] = ShoppingItem(
        itemName: item.itemName,
        isDone: !item.isDone,
      );
      _saveToPreferences(state);
    }
  }

  Future<void> _saveToPreferences(List<ShoppingItem> itemList) async {
    final jsonList = itemList.map((item) => item.toJson()).toList();
    await prefs.setString('shopping_items', jsonList.toString());
  }

  List<ShoppingItem> _loadFromPreferences() {
    final savedShoppingItems = prefs.getString('shopping_items');
    if (savedShoppingItems != null) {
      final List<dynamic> decodedList = jsonDecode(savedShoppingItems);
      return decodedList.map((json) => ShoppingItem.fromJson(json)).toList();
    }
    return [];
  }
}
