import 'package:bookshelf/db/bookshelf_database.dart';
import 'package:flutter/material.dart';
import 'package:bookshelf/model/shelf.dart';
import 'package:bookshelf/pages/edit_shelf.dart';
import 'package:bookshelf/pages/settings.dart';
import 'package:bookshelf/pages/test.dart';

import '../model/book.dart';
import 'books.dart';

class Shelves extends StatefulWidget {
  const Shelves({Key? key}) : super(key: key);

  @override
  State<Shelves> createState() => _ShelvesState();
}

class _ShelvesState extends State<Shelves> {
  late List<Shelf> shelves;
  late List<int> shelvesLength;

  bool isLoading = false;

  @override
  void initState() {
    shelves = [];
    shelvesLength = [];
    super.initState();
    refreshShelves();
  }

  @override
  void dispose() {
    BookShelfDatabase.instance.close();
    super.dispose();
  }

  Future refreshShelves() async {
    setState(() => isLoading = true);

    shelves = await BookShelfDatabase.instance.loadAllShelves();
    shelvesLength = List<int>.filled(shelves.length, 0);

    for (int i = 0; i < shelves.length; i++) {
      shelvesLength[i] =
          await BookShelfDatabase.instance.getShelfLength(shelves[i].id!);
    }

    setState(() => isLoading = false);
  }

  void _showModalBottomSheet(
      BuildContext context, int shelfId, String shelfName, int shelfLength) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.6),
                ),
              ),
            ),
            ListTile(
              title: Text(
                shelfName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                "$shelfLength books",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Divider(
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded),
              title: Text(
                'Delete',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Delete shelf'),
                    content: const Text(
                        'Are you sure you want to delete this shelf?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          BookShelfDatabase.instance.deleteShelf(shelfId);
                          refreshShelves();
                          Navigator.pop(context, 'OK');
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: Text('Edit', style: Theme.of(context).textTheme.bodyLarge),
              onTap: () async {
                await Navigator.of(context)
                    .push(_createRoute(shelfId, shelfName));
                refreshShelves();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Shelves'),
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: shelves.length,
          itemBuilder: (context, i) {
            return InkWell(
              onLongPress: () {
                _showModalBottomSheet(
                    context, shelves[i].id!, shelves[i].name, shelvesLength[i]);
              },
              child: ShelfListTile(
                  shelves[i].id!, shelves[i].name, shelvesLength[i]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_rounded),
        onPressed: () async {
          await Navigator.of(context).push(_createRoute(0, ''));
          refreshShelves();
        },
        label: const Text("add shelf"),
      ),
    );
  }
}

Route _createRoute(int shelfId, String shelfName) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        EditShelf(shelfId, shelfName),
    fullscreenDialog: true,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class ShelfListTile extends StatelessWidget {
  final int shelfId;
  final String shelfName;
  final int shelfLength;

  const ShelfListTile(this.shelfId, this.shelfName, this.shelfLength,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: BookShelfDatabase.instance.loadBooksByShelf(shelfId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          double readingTotal = 0.0;
          for (int i = 0; i < snapshot.data!.length; i++) {
            int readingStatus = snapshot.data![i].readingStatus;
            if (readingStatus == 2) {
              readingTotal += 1.0;
            }
          }

          double readingRatio = 0.0;
          if (snapshot.data!.isNotEmpty) {
            readingRatio = readingTotal / snapshot.data!.length;
          }

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            color: ElevationOverlay.applySurfaceTint(
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceTint,
                1),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  height: 140.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        snapshot.data!.length < 10 ? snapshot.data?.length : 10,
                    itemBuilder: (context, index) {
                      return Image.memory(snapshot.data![index].cover);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shelfName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            "$shelfLength books",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: readingRatio == 1.0
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    )
                                  : CircularProgressIndicator(
                                      value: readingRatio,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                            ),
                            Text(
                              "${(readingRatio * 100.0).toInt()} % read",
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Container(
          alignment: AlignmentDirectional.center,
          child: const CircularProgressIndicator(),
        );
      },
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(left: 12, top: 56, right: 12),
        children: [
          SizedBox(
            height: 56,
            child: ListTile(
              leading: const Icon(Icons.library_books_rounded, size: 24),
              selected: true,
              title: Text('Shelves',
                  style: Theme.of(context).textTheme.labelLarge),
              onTap: () {
                Navigator.pop(context);
              },
              contentPadding: const EdgeInsets.only(left: 16, right: 24),
              textColor: Theme.of(context).colorScheme.onSurfaceVariant,
              iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
              selectedColor: Theme.of(context).colorScheme.onSecondaryContainer,
              selectedTileColor:
                  Theme.of(context).colorScheme.secondaryContainer,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
          ),
          SizedBox(
            height: 56,
            child: ListTile(
              leading: const Icon(Icons.book_rounded, size: 24),
              selected: false,
              title:
                  Text('Books', style: Theme.of(context).textTheme.labelLarge),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Books(),
                  ),
                );
              },
              contentPadding: const EdgeInsets.only(left: 16, right: 24),
              textColor: Theme.of(context).colorScheme.onSurfaceVariant,
              iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
              selectedColor: Theme.of(context).colorScheme.onSecondaryContainer,
              selectedTileColor:
                  Theme.of(context).colorScheme.secondaryContainer,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
          ),
          SizedBox(
            height: 56,
            child: ListTile(
              leading: const Icon(Icons.schedule_rounded, size: 24),
              title: Text('Wishlist',
                  style: Theme.of(context).textTheme.labelLarge),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
              contentPadding: const EdgeInsets.only(left: 16, right: 24),
              textColor: Theme.of(context).colorScheme.onSurfaceVariant,
              iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
              selectedColor: Theme.of(context).colorScheme.onSecondaryContainer,
              selectedTileColor:
                  Theme.of(context).colorScheme.secondaryContainer,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
          ),
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          SizedBox(
            height: 56,
            child: ListTile(
              leading: const Icon(Icons.settings_rounded, size: 24),
              selected: false,
              title: Text('Settings',
                  style: Theme.of(context).textTheme.labelLarge),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
              contentPadding: const EdgeInsets.only(left: 16, right: 24),
              textColor: Theme.of(context).colorScheme.onSurfaceVariant,
              iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
              selectedColor: Theme.of(context).colorScheme.onSecondaryContainer,
              selectedTileColor:
                  Theme.of(context).colorScheme.secondaryContainer,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
