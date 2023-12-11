import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglistapp/components/editor.dart';
import 'package:shoppinglistapp/layout/list_details.dart';
import 'package:shoppinglistapp/models/list.dart';
import 'package:shoppinglistapp/providers/lists.dart';

class ListsPage extends ConsumerStatefulWidget {
  const ListsPage({
    required this.list,
    required this.remove,
    super.key,
  });

  final List<ShopList> list;
  final Function remove;

  @override
  ListsPageState createState() => ListsPageState();
}

class ListsPageState extends ConsumerState<ListsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: ListView.builder(
            shrinkWrap: false,
            itemCount: widget.list.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListDetails(
                            list: widget.list[index],
                            remove: (name) {
                              widget.remove(name, widget.list[index]);
                            },
                          ),
                        ));
                  },
                  child: Row(
                    children: [
                      /* Buton Name */
                      Expanded(child: Text(widget.list[index].name)),

                      /* Edit Button */
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => EditorWidget(
                              btnName: "Değiştir",
                              curVal: widget.list[index].name,
                            ),
                          ).then((value) async {
                            if (widget.list.any(
                                (e) => e.name.contains(value.toString()))) {
                              value += "_1";
                            }

                            if (value.toString().isNotEmpty && value != null) {
                              /* Send Notifier */
                              ref
                                  .read(listsProvider.notifier)
                                  .updateItem(index, value.toString().trim());

                              /* Local Refresh */
                              setState(() {});
                            }
                          }).catchError((err) {
                            throw 'Empty String';
                          });
                        },
                        icon: const Icon(Icons.edit),
                        tooltip: 'Düzenle "${widget.list[index].name}"',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
