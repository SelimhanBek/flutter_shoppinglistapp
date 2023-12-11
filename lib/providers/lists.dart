import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglistapp/models/list.dart';

final listsProvider =
    NotifierProvider<ListsProvider, List<ShopList>>(ListsProvider.new);

class ListsProvider extends Notifier<List<ShopList>> {
  @override
  List<ShopList> build() => [];

  /// Update my Lists
  updateListObjects(ShopList list) {
    List<ShopList> lists = List.from(state);
    lists.firstWhere((e) => e.name == list.name).objects = list.objects;

    state = lists;
  }

  /// Remove object from list
  Future<void> removeObject(String name, ShopList from) async {
    List<ShopList> lists = List.from(state);
    lists
        .firstWhere((e) => e.name == from.name)
        .objects
        .removeWhere((e) => e.name == name);
    state = lists;
  }

  /// Add new item to List
  addItem(ShopList newList) {
    List<ShopList> list = List.from(state);
    list.add(newList);

    state = list;
  }

  /// Update an item
  updateItem(int index, String newName) {
    List<ShopList> list = List.from(state);
    list[index].name = newName;

    state = list;
  }
}
