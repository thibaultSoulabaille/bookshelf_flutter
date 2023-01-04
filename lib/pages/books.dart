import 'dart:typed_data';

import 'package:bookshelf/db/bookshelf_database.dart';
import 'package:bookshelf/pages/edit_book.dart';
import 'package:flutter/material.dart';
import 'package:bookshelf/model/book.dart';
import '../model/author.dart';
import 'add_to_shelf.dart';

class Books extends StatefulWidget {
  const Books({Key? key}) : super(key: key);

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  late List<Book> books;
  late List<Author> authors;

  bool isLoading = false;

  @override
  void initState() {
    books = [];
    authors = [];
    super.initState();
    refreshBooks();
  }

  Future refreshBooks() async {
    setState(() => isLoading = true);

    books = await BookShelfDatabase.instance.loadAllBooks();
    authors = List<Author>.filled(
        books.length, const Author(id: null, firstName: "", lastName: ""));

    for (int i = 0; i < books.length; i++) {
      authors[i] =
          await BookShelfDatabase.instance.loadAuthor(books[i].authorId);
    }

    setState(() => isLoading = false);
  }

  Future<Author> loadAuthor(int authorId) async {
    return await BookShelfDatabase.instance.loadAuthor(authorId);
  }

  Future cleanAuthors() async {
    setState(() => isLoading = true);

    List<Author> authors = await BookShelfDatabase.instance.loadAllAuthors();
    for (int i = 0; i < authors.length; i++) {
      int authorId = authors[i].id!;
      List<Book> authorBooks =
          await BookShelfDatabase.instance.loadBooksByAuthor(authorId);
      if (authorBooks.isEmpty) {
        await BookShelfDatabase.instance.deleteAuthor(authorId);
      }
    }

    setState(() => isLoading = false);
  }

  void _showModalBottomSheet(
      BuildContext context,
      int bookId,
      String bookTitle,
      Uint8List bookCover,
      String authorFirstName,
      String authorLastName,
      int bookPages,
      int bookReleaseDate,
      String bookLanguage) {
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
                "${DateTime.fromMillisecondsSinceEpoch(bookReleaseDate).year}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Divider(
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              leading: const Icon(Icons.my_library_add_rounded),
              title: Text('Add to shelf',
                  style: Theme.of(context).textTheme.bodyLarge),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddToShelf(
                      bookId: bookId,
                    ),
                    fullscreenDialog: true,
                  ),
                );
                Navigator.of(context).pop();
              },
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
                          BookShelfDatabase.instance.deleteBook(bookId);
                          refreshBooks();

                          cleanAuthors();

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
                await Navigator.of(context).push(_createRoute(
                    bookId,
                    bookTitle,
                    bookCover,
                    authorFirstName,
                    authorLastName,
                    bookPages,
                    bookReleaseDate,
                    bookLanguage));
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
      /*body: Container(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Book>>(
          future: BookShelfDatabase.instance.loadAllBooks(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(snapshot.data![index].title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                          Image.memory(snapshot.data![index].cover),
                          const Divider()
                        ]);
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Container(alignment: AlignmentDirectional.center,child: const CircularProgressIndicator(),);
          },
        ),
      ),*/
      body: Scrollbar(
        child: ListView.builder(
          itemCount: books.length * 2,
          itemBuilder: (context, i) {
            if (i.isOdd) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 8),
              );
            }

            final index = i ~/ 2;
            return InkWell(
              customBorder: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              onLongPress: () {
                _showModalBottomSheet(
                    context,
                    books[index].id!,
                    books[index].title,
                    books[index].cover,
                    authors[index].firstName,
                    authors[index].lastName,
                    books[index].nPages,
                    books[index].releaseDateTimestamp,
                    books[index].language);
              },
              child: BookListTile(
                  books[index].title,
                  books[index].cover,
                  authors[index].firstName,
                  authors[index].lastName,
                  books[index].nPages,
                  DateTime.fromMillisecondsSinceEpoch(
                          books[index].releaseDateTimestamp)
                      .year),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_rounded),
        onPressed: () async {
          await Navigator.of(context).push(
              _createRoute(0, '', Uint8List.fromList([]), '', '', 0, 0, ''));
          refreshBooks();
        },
        label: const Text("add book"),
      ),
    );
  }
}

class BookListTile extends StatelessWidget {
  final String bookTitle;
  final Uint8List bookCover;
  final String authorFirstName;
  final String authorLastName;
  final int bookPages;
  final int bookReleaseYear;

  const BookListTile(this.bookTitle, this.bookCover, this.authorFirstName,
      this.authorLastName, this.bookPages, this.bookReleaseYear,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Card(
            elevation: 0,
            color: ElevationOverlay.applySurfaceTint(
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceTint,
                0),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ), // Image border
                  child: SizedBox(
                    width: 75,
                    // height: 120,
                    // Image radius
                    child: Image.memory(
                      bookCover,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "$authorFirstName $authorLastName",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      bookReleaseYear.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      "$bookPages pages",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Route _createRoute(
    int bookId,
    String bookTitle,
    Uint8List bookCover,
    String authorFirstName,
    String authorLastName,
    int bookPages,
    int bookReleaseDate,
    String bookLanguage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => EditBook(
        bookId,
        bookTitle,
        bookCover,
        authorFirstName,
        authorLastName,
        bookPages,
        bookReleaseDate,
        bookLanguage),
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
