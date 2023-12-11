import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglistapp/components/editor.dart';
import 'package:shoppinglistapp/models/list.dart';
import 'package:shoppinglistapp/providers/lists.dart';
import 'package:shoppinglistapp/providers/suggested.dart';

class AddItemPage extends ConsumerStatefulWidget {
  const AddItemPage({
    required this.curName,
    super.key,
  });

  final String curName;

  @override
  AddItemPageState createState() => AddItemPageState();
}

class AddItemPageState extends ConsumerState<AddItemPage> {
  /* Local Variable */
  final TextEditingController _ct = TextEditingController();
  late String _dropdownValue = "";
  late bool _saveInSuggested = true;

  @override
  void initState() {
    super.initState();
    _saveInSuggested = widget.curName.isEmpty;
    if (widget.curName.isNotEmpty) {
      _ct.text = widget.curName;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* Providers */
    final myLists = ref.watch(listsProvider);

    /* DropDown */
    Widget dropDownButton() {
      return DropdownMenu(
        width: 200,
        initialSelection: "",
        onSelected: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            _dropdownValue = value!;
          });
        },
        dropdownMenuEntries: List<DropdownMenuEntry<String>>.generate(
          myLists.length,
          (index) {
            /* List Names */
            return DropdownMenuEntry<String>(
              label: myLists[index].name,
              value: myLists[index].name,
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ekle',
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
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                /* a little space */
                const SizedBox(height: 25),

                /* Name */
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _ct,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      hintText: "Eklemen istediğiniz şeyin adını girin...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                  ),
                ),

                /* a little space */
                const SizedBox(height: 25),

                /* Description */
                if (_ct.text.trim().isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Hangi listeye ekleyelim?",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                  ),

                /* My Lists */
                if (_ct.text.trim().isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /* List Names */
                        if (myLists.isNotEmpty)
                          Expanded(child: dropDownButton()),

                        /* Create a new List */
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const EditorWidget(btnName: 'Oluştur'),
                            ).then((value) async {
                              /* Send Notifier */
                              ref.read(listsProvider.notifier).addItem(
                                    ShopList(
                                      value.toString().trim(),
                                      objects: [],
                                    ),
                                  );

                              /* Local Refresh */
                              setState(() {
                                _dropdownValue = value.toString().trim();
                              });
                            }).catchError((err) {
                              throw 'Empty String';
                            });
                          },
                          child: const Text('Yeni Liste Oluştur'),
                        ),
                      ],
                    ),
                  ),

                /* a little space */
                const SizedBox(height: 75),

                /* Save In Suggested */
                if (_dropdownValue.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    width: double.infinity,
                    child: Row(
                      children: [
                        /* Check Box */
                        Checkbox(
                          value: _saveInSuggested,
                          onChanged: (val) {
                            setState(() {
                              _saveInSuggested = val!;
                            });
                          },
                        ),

                        /* Text */
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _saveInSuggested = !_saveInSuggested;
                              });
                            },
                            child: Text(
                              'Ana sayfaya ekleyelim mi? (${_ct.text.trim()})',
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                /* Save Button */
                if (_dropdownValue.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        /* Create New List */
                        ShopList list = myLists
                            .firstWhere((e) => e.name == _dropdownValue)
                          ..objects.add(ShopListObject(_ct.text.trim()));

                        /* Update List with Notifier */
                        ref
                            .read(listsProvider.notifier)
                            .updateListObjects(list);

                        /* Save to Home Page */
                        if (_saveInSuggested) {
                          ref
                              .read(suggestedItems.notifier)
                              .addItem(ShopListObject(_ct.text.trim()));
                        }

                        /* Close Page */
                        Navigator.of(context).pop();
                      },
                      child: const Text("Kaydet"),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
