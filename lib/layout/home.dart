import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglistapp/layout/add_page.dart';
import 'package:shoppinglistapp/providers/suggested.dart';

class Home extends ConsumerStatefulWidget {
  const Home({
    super.key,
  });

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(suggestedItems);

    return SizedBox.expand(
      child: ListView.builder(
        shrinkWrap: false,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddItemPage(curName: items[index].name),
                ),
              );
            },
            child: Text(items[index].name),
          );
        },
      ),
    );
  }
}
