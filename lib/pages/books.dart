import 'package:bookshelf/db/bookshelf_database.dart';
import 'package:bookshelf/pages/edit_book.dart';
import 'package:flutter/material.dart';
import 'package:bookshelf/model/book.dart';

class Books extends StatefulWidget {
  const Books({Key? key}) : super(key: key);

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  late List<Book> books;
  bool isLoading = false;

  @override
  void initState() {
    books = [];
    super.initState();
    refreshBooks();
  }

  /*
  @override
  void dispose() {
    BooksDatabase.instance.close();
    super.dispose();
  }*/

  Future refreshBooks() async {
    setState(() => isLoading = true);

    books = await BookShelfDatabase.instance.loadAllBooks();

    setState(() => isLoading = false);
  }

  void _showModalBottomSheet(
      BuildContext context, int bookId, String bookTitle, int bookPages) {
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
                bookTitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                "$bookPages books",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.outline,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              leading: const Icon(Icons.delete_outlined),
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
                          BookShelfDatabase.instance.deleteBook(bookId);
                          refreshBooks();
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
              leading: const Icon(Icons.edit_outlined),
              title: Text('Edit', style: Theme.of(context).textTheme.bodyLarge),
              onTap: () async {
                await Navigator.of(context)
                    .push(_createRoute(bookId, bookTitle, bookPages));
                refreshBooks();
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
    refreshBooks();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, i) {
            return InkWell(
              onLongPress: () {
                _showModalBottomSheet(
                    context, books[i].id!, books[i].title, books[i].nPages);
              },
              child: BookListTile(books[i].title, books[i].nPages),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_rounded),
        onPressed: () async {
          await Navigator.of(context).push(_createRoute(0, '', 0));
        },
        label: const Text("add book"),
      ),
    );
  }
}

class BookListTile extends StatelessWidget {
  final String bookTitle;
  final int bookPages;

  const BookListTile(this.bookTitle, this.bookPages, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      child: Column(
        children: [
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "Firstname Surname",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "1985",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Flexible(
                    child: Text(
                      "$bookPages pages",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Route _createRoute(int bookId, String bookTitle, int bookPages) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        EditBook(bookId, bookTitle, bookPages),
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
