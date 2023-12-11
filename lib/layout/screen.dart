import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglistapp/components/editor.dart';
import 'package:shoppinglistapp/layout/add_page.dart';
import 'package:shoppinglistapp/layout/home.dart';
import 'package:shoppinglistapp/layout/lists.dart';
import 'package:shoppinglistapp/models/list.dart';
import 'package:shoppinglistapp/providers/lists.dart';
import 'package:shoppinglistapp/theme/theme.dart';

class ResponsiveLayout extends ConsumerStatefulWidget {
  const ResponsiveLayout({
    super.key,
  });

  @override
  ResponsiveLayoutState createState() => ResponsiveLayoutState();
}

class ResponsiveLayoutState extends ConsumerState<ResponsiveLayout>
    with TickerProviderStateMixin {
  /* Scaffold Key */
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  /* Tab Controller */
  late TabController _tabController;

  /* Bottom Navigation Variables */
  int _selectedIndex = 0;

  /* Change Page */
  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.index = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* Providers */
    final currentThemeMode = ref.watch(themeProvider);
    final myLists = ref.watch(listsProvider);

    /* Scroll Listener */
    _tabController.addListener(() {
      /* Update Bottom Navigation */
      if (_tabController.index != _selectedIndex) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });

    /* Drawer */
    Widget drawer() {
      return Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1.5,
        child: Column(
          children: [
            /* App Name */
            SafeArea(
              top: true,
              bottom: false,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                child: const Text(
                  "Market Listesi",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /* Widgets */
            Expanded(
                child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                /* Feedback */
                ListTile(
                  title: Text(
                    'Geri bildirim verin',
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                  leading: Icon(
                    Icons.feed_outlined,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onTap: () {},
                ),
              ],
            )),

            /* Seperate with divider */
            const Divider(height: 0),

            /* End Drawer */
            SafeArea(
              top: false,
              bottom: true,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /* Seperate with divider */
                    const Divider(height: 0),

                    /* Settings */
                    ListTile(
                      title: Row(
                        children: [
                          /* Description */
                          Expanded(
                            child: Text(
                              'Koyu Tema',
                              style: Theme.of(context).textTheme.bodyMedium!,
                            ),
                          ),

                          /* Theme Mode */
                          Switch(
                            value: currentThemeMode == ThemeMode.dark,
                            onChanged: (val) {
                              /* Notifier */
                              ref.read(themeProvider.notifier).changeAppTheme(
                                    mode:
                                        val ? ThemeMode.dark : ThemeMode.light,
                                  );
                            },
                          ),
                        ],
                      ),
                      leading: Icon(
                        Icons.palette_outlined,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onTap: () {
                        /* Notifier */
                        ref.read(themeProvider.notifier).changeAppTheme(
                              mode: currentThemeMode == ThemeMode.light
                                  ? ThemeMode.dark
                                  : ThemeMode.light,
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      key: _key,
      drawer: drawer(),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Sepet' : 'Listeler',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 21,
              ),
        ),
        leading: IconButton(
          onPressed: () {
            _key.currentState!.openDrawer();
          },
          icon: Icon(
            Icons.menu_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
          visualDensity: VisualDensity.compact,
          tooltip: 'menu',
          splashRadius: 20,
        ),
        actions: [
          /* Create a new List */
          if (_selectedIndex == 1)
            IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => const EditorWidget(btnName: 'Oluştur'),
                ).then((value) async {
                  if (myLists.any((e) => e.name.contains(value.toString()))) {
                    value += "_1";
                  }

                  /* Send Notifier */
                  ref.read(listsProvider.notifier).addItem(
                        ShopList(
                          value.toString().trim(),
                          objects: [],
                        ),
                      );

                  /* Local Refresh */
                  setState(() {});
                }).catchError((err) {
                  throw 'Empty String';
                });
              },
              icon: Icon(
                Icons.add_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              visualDensity: VisualDensity.compact,
              tooltip: 'Yeni Liste',
            ),

          /* a little padding */
          const Padding(padding: EdgeInsets.only(right: 8)),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          /* Items */
          const Home(),

          /* Lists */
          ListsPage(
            list: myLists,
            remove: (String name, ShopList list) {
              ref
                  .read(listsProvider.notifier)
                  .removeObject(name, list)
                  .then((value) {
                setState(() {
                  myLists;
                });
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddItemPage(curName: ""),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _selectedIndex == 0
                  ? null
                  : Theme.of(context).iconTheme.color,
            ),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: _selectedIndex == 1
                  ? null
                  : Theme.of(context).iconTheme.color,
            ),
            label: 'Listeler',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
