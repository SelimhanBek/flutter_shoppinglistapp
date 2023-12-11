import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglistapp/models/list.dart';
import 'package:shoppinglistapp/temp/dummy.dart';

final suggestedItems =
    NotifierProvider<ListsProvider, List<ShopListObject>>(ListsProvider.new);

class ListsProvider extends Notifier<List<ShopListObject>> {
  @override
  List<ShopListObject> build() => List<ShopListObject>.generate(
        dummyData.length,
        (index) => ShopListObject.fromJson(dummyData[index]),
      );

  /// Update my Lists
  updateLists(List<ShopListObject> list) {
    state = list;
  }

  /// Add Item
  addItem(ShopListObject obj) {
    List<ShopListObject> list = List.from(state);
    list.add(obj);
    state = list;
  }
}
