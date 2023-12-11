import 'package:flutter/material.dart';
import 'package:shoppinglistapp/models/list.dart';

class ListDetails extends StatefulWidget {
  const ListDetails({
    required this.list,
    required this.remove,
    super.key,
  });

  final ShopList list;
  final Function remove;

  @override
  State<ListDetails> createState() => _ListDetailsState();
}

class _ListDetailsState extends State<ListDetails> {
  late ShopList _list;

  @override
  void initState() {
    super.initState();
    _list = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.list.name,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 21,
              ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          visualDensity: VisualDensity.compact,
          tooltip: 'Geri',
        ),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: ListView.builder(
            shrinkWrap: false,
            itemCount: _list.objects.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                child: Card(
                  color: Colors.grey.shade400,
                  elevation: 0,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _list.objects[index].name,
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            /* Notifier */
                            widget.remove(_list.objects[index].name);

                            /* Local Delete */
                            setState(() {
                              _list.objects.removeWhere(
                                (e) => e.name == _list.objects[index].name,
                              );
                            });
                          },
                          icon: Icon(
                            Icons.delete_forever,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Sil',
                        ),
                      ],
                    ),
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
