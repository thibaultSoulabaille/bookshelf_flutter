import 'package:flutter/material.dart';
import 'package:bookshelf/db/shelves_database.dart';
import 'package:bookshelf/model/shelf.dart';
import 'package:bookshelf/pages/edit_shelf.dart';
import 'package:bookshelf/pages/settings.dart';

class Shelves extends StatefulWidget {
  const Shelves({Key? key}) : super(key: key);

  @override
  State<Shelves> createState() => _ShelvesState();
}

class _ShelvesState extends State<Shelves> {
  late List<Shelf> shelves;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshShelves();
  }

  @override
  void dispose() {
    ShelvesDatabase.instance.close();

    super.dispose();
  }

  Future refreshShelves() async {
    setState(() => isLoading = true);

    shelves = await ShelvesDatabase.instance.loadAllShelves();

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
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                child: const Divider(),
              ),
            ),
            ListTile(
              textColor: Theme.of(context).colorScheme.onSecondaryContainer,
              title: Text(
                shelfName,
              ),
              subtitle: Text(
                "$shelfLength books",
              ),
            ),
            Divider(
              height: 8,
              thickness: 1,
              color: Theme.of(context).colorScheme.outline,
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete'),
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
                          ShelvesDatabase.instance.deleteShelf(shelfId);
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
            const ListTile(
              leading: Icon(Icons.edit_outlined),
              title: Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.only(left: 12, top: 56, right: 12),
          children: [
            ListTile(
              leading: const Icon(Icons.library_books_outlined),
              selected: true,
              title: const Text('Shelves'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_outlined),
              title: const Text('Books'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(
              height: 16,
              thickness: 1,
              indent: 8,
              endIndent: 8,
              color: Theme.of(context).colorScheme.outline,
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Shelves'),
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: shelves.length * 2,
          itemBuilder: (context, i) {
            if (i.isOdd) {
              return Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).colorScheme.outline,
              );
            }

            final index = i ~/ 2;
            return InkWell(
              onLongPress: () {
                _showModalBottomSheet(
                    context, shelves[index].id!, shelves[index].name, 0);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          shelves[index].name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Flexible(
                          child: Text(
                            "0 books",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text("BOOKS COVERS",
                              style: Theme.of(context).textTheme.headlineLarge),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditShelf(),
              fullscreenDialog: true,
            ),
          );
          refreshShelves();
        },
        label: const Text("add shelf"),
      ),
    );
  }
}
