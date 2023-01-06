import 'package:bookshelf/db/bookshelf_database.dart';
import 'package:flutter/material.dart';
import 'package:bookshelf/model/shelf.dart';

import '../model/book.dart';


class AddToShelf extends StatefulWidget {
  final int bookId;

  const AddToShelf({Key? key, required this.bookId}) : super(key: key);

  @override
  State<AddToShelf> createState() => _AddToShelfState();
}

class _AddToShelfState extends State<AddToShelf> {
  late List<Shelf> shelves;
  late List<int> shelvesLength;

  bool isLoading = false;

  int? _selectedShelfId;

  @override
  void initState() {
    shelves = [];
    shelvesLength = [];

    super.initState();
    refreshShelves();
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

  Future setBookShelf(int bookId) async {
    Book book = await BookShelfDatabase.instance.loadBook(bookId);

    BookShelfDatabase.instance.updateBook(
      Book(
        id: book.id,
        shelfId: _selectedShelfId,
        title: book.title,
        cover: book.cover,
        authorId: book.authorId,
        nPages: book.nPages,
        releaseDateTimestamp: book.releaseDateTimestamp,
        language: book.language,
        startedReadingDateTimestamp: book.startedReadingDateTimestamp,
        endedReadingDateTimestamp: book.endedReadingDateTimestamp,
        readingStatus: book.readingStatus,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int bookId = widget.bookId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add To Shelf'),
        actions: [
          TextButton(
            onPressed: () {
              setBookShelf(bookId);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: shelves.length,
          itemBuilder: (context, i) {
            // return ShelfListTile(shelves[i].name, shelvesLength[i]);
            return Column(
              children: [
                ListTile(
                  title: Text(shelves[i].name),
                  subtitle: Text("${shelvesLength[i]} books"),
                  trailing: Radio<int>(
                    value: shelves[i].id!,
                    groupValue: _selectedShelfId,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedShelfId = value;
                      });
                    },
                  ),
                ),
                const Divider(
                  height: 1,
                  indent: 16,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ShelfListTile extends StatelessWidget {
  final String shelfName;
  final int shelfLength;

  const ShelfListTile(this.shelfName, this.shelfLength, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                shelfName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Flexible(
                child: Text(
                  "$shelfLength books",
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
    );
  }
}
