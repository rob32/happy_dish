class ShoppingItem {
  final String itemName;
  bool isDone;

  ShoppingItem({required this.itemName, this.isDone = false});

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'isDone': isDone,
    };
  }

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      itemName: json['itemName'],
      isDone: json['isDone'],
    );
  }
}
